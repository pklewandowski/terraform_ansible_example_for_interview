#!/usr/bin/python
# -*- coding: utf-8 -*-

EXPECTED_CONTENT = "HSBC DevOps work is GREAT!!!"

DOCUMENTATION = r'''
---
module: hsbc_greetings
short_description: Ensure a file contains proper text
description:
  - This module checks if a file with the given path exists and contains proper text
  - If the file does not exist or its content is different, the module will create or update it.
options:
  path:
    description:
      - Path to the file that should be checked or created.
    required: true
    type: str
author:
  - "Piotr Lewandowski"
'''

EXAMPLES = r'''
# Ensure the file contains proper text
- name: Ensure HSBC greetings file exists
  hsbc_file:
    path: /tmp/hsbc.txt
'''

RETURN = r'''
changed:
  description: Whether the file was changed
  type: bool
message:
  description: Status message
  type: str
'''

import os

from ansible.module_utils.basic import AnsibleModule


def file_has_expected_content(path):
    """Check if the file exists and contains the expected text."""
    if not os.path.isfile(path):
        return False

    with open(path, 'r', encoding='utf-8') as f:
        content = f.read().strip()

    return content == EXPECTED_CONTENT


def run_module():
    module_args = dict(
        path=dict(type='str', required=True),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    result = dict(
        changed=False,
        message=''
    )

    path = module.params['path']

    if module.check_mode:
        if file_has_expected_content(path):
            result['message'] = f"Check mode: file {path} already contains expected text"

        else:
            result['message'] = f"Check mode: file {path} would be created/updated"

        module.exit_json(**result)

    # Idempotency – check state before changing
    if file_has_expected_content(path):
        result['message'] = f"File {path} already contains expected text"

    else:
        try:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(f'{EXPECTED_CONTENT}\n')

            result['changed'] = True
            result['message'] = f"File {path} created/updated with expected text"

        except Exception as e:
            module.fail_json(msg=f"Failed to create/update file {path}: {str(e)}")

    module.exit_json(**result)


def main():
    try:
        run_module()
    except Exception as e:
        AnsibleModule(argument_spec={}).fail_json(msg=f"Unexpected error: {str(e)}")


if __name__ == '__main__':
    main()

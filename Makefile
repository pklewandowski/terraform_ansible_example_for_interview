TF_DIR=terraform
TF=terraform -chdir=$(TF_DIR)/src
TF_WORKDIR=../.workdir
export TF_DATA_DIR= ../.terraform_files/

tf:
	@echo "Use: make tf-[init|plan|apply|destroy]"

tf-init:
	$(TF) init

tf-plan:
	$(TF) plan -state=$(TF_WORKDIR)/terraform.tfstate

tf-apply:
	$(TF) apply -auto-approve -state=$(TF_WORKDIR)/terraform.tfstate

tf-destroy:
	$(TF) destroy -auto-approve -state=$(TF_WORKDIR)/terraform.tfstate

ansible-play:
	./.venv/bin/ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

ansible-test:
	./.venv/bin/ansible-playbook -i ansible/inventory.ini ansible/roles/db/tests/test.yml

ansible-selected-tasks:
	./.venv/bin/ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags "hsbc_greetings,hsbc_greetings_full_result"

ansible-skip:
	./.venv/bin/ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --skip-tags hsbc_greetings
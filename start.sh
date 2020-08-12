#!/bin/sh

# Fill in Azure credentials properly.
export TF_VAR_arm_subscription_id=
export TF_VAR_arm_client_id=
export TF_VAR_arm_client_secret=
export TF_VAR_arm_tenant_id=

echo 'API image creating...'
packer build -force packer-api.json
echo 'API image done.'

echo 'DB image creating...'
packer build -force packer-db.json
echo 'DB image done.'

echo 'Infrastructure provisioning...'
terraform init
terraform plan
terraform apply -auto-approve
echo 'Infrastructure done.'
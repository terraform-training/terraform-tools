# terraform-tools
Terraform related tools demo

## setup

```bash
# set up AWS profile and region
export AWS_PROFILE=your_profile
export AWS_REGION=eu-west-2  # or whatever

# create an SSH key
ssh-keygen -t rsa -b 4096 -C demo -f bastion.key

```
## terraform-docs

```bash
terraform-docs terraform/
# modify variables description and try again
# check out and modify .terraform-docs.yml
# also check out github workflow docs check
```

## checkov

```bash
# analyze output 
checkov -d terraform/
# uncomment code and try again
checkov -d terraform/
# suppress security rule warning
# fix the encryption warning

# try sarif and view it online
checkov -d terraform/ -o sarif
```

## infracost

```bash
cd terraform
# You need to login
infracost auth login

# credentials are in the file
cat ~/.config/infracost/credentials.yml

# sync up usage file
infracost breakdown --sync-usage-file --usage-file infracost-usage.yml --path ./
cat infracost-usage.yml
infracost breakdown --show-skipped --path ./

# comment out eip_association and try the breakdown again
```

## driftctl 

```bash
cd terraform
# print drift
driftctl scan
# print drift to file
driftctl scan -o json://result.json
# generate drift
driftctl gen-driftignore -i result.json
# check drift again
driftctl scan
# create infra
terraform apply
# repeat
driftctl scan
driftctl scan -o json://stdout | driftctl gen-driftignore
driftctl scan
```


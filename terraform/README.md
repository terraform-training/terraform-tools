<!-- BEGIN_TF_DOCS -->
# Demo project for terraform tools

This project creates AWS keypair and a bastion machine in a given network.

This documentation is auto-generated!

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_author"></a> [author](#input\_author) | Author | `string` | `"None"` | no |
| <a name="input_bastion_key_filename"></a> [bastion\_key\_filename](#input\_bastion\_key\_filename) | Bastion public key filename | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment type | `string` | `"dev"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_keypair_arn"></a> [bastion\_keypair\_arn](#output\_bastion\_keypair\_arn) | n/a |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

Disclaimer: this code is auto-generated by [tf-docs](https://terraform-docs.io)

[Return](../README.md)
<!-- END_TF_DOCS -->
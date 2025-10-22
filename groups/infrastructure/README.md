<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tenable_audit_role"></a> [tenable\_audit\_role](#module\_tenable\_audit\_role) | git@github.com:companieshouse/terraform-modules//aws/tenable-audit | 1.0.353 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [vault_generic_secret.security_kms](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.tenable](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS account | `string` | n/a | yes |
| <a name="input_enable_audit"></a> [enable\_audit](#input\_enable\_audit) | Toggle tenable role provisioning | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The default tags to add to all resources | `map(string)` | <pre>{<br>  "Environment": "aci",<br>  "Terraform": "https://github.com/companieshouse/aws-aci-infrastructure-terraform"<br>}</pre> | no |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
# Oracle Cloud Infrastructure Terraform Module for OCI PostgreSQL
This OpenTofu/Terraform module provisions and configures OCI Database for PostgreSQL. 

## Features
- **OCI PostgreSQL Deployment**: Deploys a PostgreSQL database with customizable parameters.
  
- **Network Setup**: Configures a private subnet and security groups.
  
- **Automated Backups**: Enables automatic daily backups.
  
- **Custom Configuration**: Fine-tunes database settings such as max_connections.
  
- **Monitoring and Alerts**: Sets up alarms for key performance metrics.
  
- **User and Database Initialization**: Creates users, roles, and necessary extensions.

## Configuration details
- While creating PostgreSQL custom configurations:
  - Fixed shapes require specifying the exact OCPU and memory values corresping to the selected shape.
  - For flexible shapes, set the memory and OCPU values as 0 or skip them, as these resources are controlled dynamically at the ``` dbsystem ``` level. 
  - In custom configuration creation, the shape has to be specified without the ```PostgresQL``` prefix (e.g., VM.```Standard.E4.Flex```). However, when creating a PostgreSQL database using this configuration, append ```PostgreSQL``` to the shape name (e.g., ```PostgreSQL..VM.Standard.E4.Flex```)

## Prerequisites
Ensure you have the following before using this module:
- [OpenTofu](https://opentofu.org/docs/intro/install/) or [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed
- An Oracle Cloud Infrastruture(OCI) Account
- [Configure OCI CLI](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-provider.htm#prepare) with appropriate credentials
- Required [IAM policies](https://docs.oracle.com/en-us/iaas/Content/postgresql/policies.htm)

## Using with Terraform

This module is compatible with OpenTofu. To use Terraform instead of OpenTofu, ensure you have Terraform installed and use the following provider configuration:

```hcl

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

```

## Deploy using OpenTofu or Terraform

1. Use `terraform.tfvars` File

   The repository includes a terraform.tfvars.example file. Edit it and replace the placeholder values with your actual OCI credentials, to create your own terraform.tfvars file.
   
3. To deploy the resources, initialize and apply the configuration:

```sh
tofu init  # or terraform init
tofu plan  # or terraform plan
tofu apply # or terraform apply
```

## Cleanup
To destroy the created resources, use:

```sh
tofu destroy # or terraform destroy
```
## Documentation
- [OCI PostgreSQL](https://docs.oracle.com/en-us/iaas/Content/postgresql/overview.htm)
- [OCI PostgreSQL custom configurations](https://docs.oracle.com/en-us/iaas/Content/postgresql/config.htm)
- [Supported Shapes](https://docs.oracle.com/en-us/iaas/Content/postgresql/supported-shapes.htm)
- [OCI Monitoring](https://docs.oracle.com/en-us/iaas/Content/Monitoring/Concepts/monitoringoverview.htm)
- [OCI Notifications](https://docs.oracle.com/en-us/iaas/Content/Notification/Concepts/notificationoverview.htm)
- [OCI PostgreSQL Metrics](https://docs.oracle.com/en-us/iaas/Content/postgresql/metrics.htm)
- [MQL Reference](https://docs.oracle.com/en-us/iaas/Content/Monitoring/Reference/mql.htm)


## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/angeline-hilda/OCI-PostgreSQL/blob/main/LICENSE) file for details.

# Terminology Cheat sheet

## [Configurations](https://registry.terraform.io/)

Configurations are code written for Terraform, using the human-readable HashiCorp Configuration Language (HCL) to describe the desired state of infrastructure resources.

-------------------------------

## [Provider](https://registry.terraform.io/)

Providers are the plugins that Terraform uses to manage those resources. Every supported service or infrastructure platform has a provider that defines which resources are available and performs API calls to manage those resources.

* [List of provider](https://registry.terraform.io/search/providers?namespace=hashicorp)

-------------------------------

## [Registry](https://registry.terraform.io/)

Registry makes it easy to use any provider or module. To use a provider or module from this registry, just add it to your configuration; when you run `terraform init`, Terraform will automatically download everything it needs.

-------------------------------

## [Backend](https://www.terraform.io/docs/language/settings/backends/index.html)

Backend defines where and how operations are performed, where state snapshots are stored, etc.

The local backend performs API operations directly from the machine where the terraform command is run

* Local backend: local
* Remote backend: Terraform Cloud, Terraform Enterprise
* Default: local backend

-------------------------------

## [State](https://www.terraform.io/docs/language/state/index.html)

State is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

* Remote state candidates: Amazon S3,
* Default: local file named `terraform.tfstate`

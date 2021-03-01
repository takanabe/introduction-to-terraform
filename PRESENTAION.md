footer: Search infrastructure study session1 - Introduction to Terraform, Cookpad. Inc (Mar 1, 2021) / Takayuki Watanabe
autoscale: true
slidenumbers: true

[.slidenumbers: false]

# Introduction to

![](img/terraform-logo.svg)

-------------------------------
# Who is this session for?

* This material is used to transfer the knowledge about Terraform for **team mates who are not familiar with Terraform**.

* This session **does not touch advanced topics for pros (module, workspace, project structure, etc...)**. If you can use the tool without other members' supports, this session is not for you.

-------------------------------
[.autoscale: true]

# Today's take away

After this session:

- You can explain what Terraform is
- You know 3 fundamental commands in Terraform
- You can deploy AWS resources using Terraform

If time allows:

- You can split existing Terraform states into pieces
- You can refer AWS resources not managed by Terraform

-------------------------------

# Out of scope

* Explanation of AWS
* Advanced Terraform topics such as workspace, module, and project structures

-------------------------------

# Table of contents

1. What is Terraform?
1. Fundamentals of Terraform
1. Usage in the search team
1. Hands-on
1. Q&A

-------------------------------
<!-- This page is the start of new section !!-->

# What is Terraform?

-------------------------------

# Terraform is:

* **A software which is responsible for provisions, updates, and destroys infrastructure resources**
* The **software can be applied to cloud infra, VMs**, physical machines, network switches, containers, and more
* Multi-cloud adoption: **Applicable for 300+ public clouds**

-------------------------------

# Usage in the search team

![](img/search-infra-overview.drawio.svg)

-------------------------------
<!-- This page is the start of new section !!-->

# Fundamentals of Terraform

* Terminology
* Configuration Language
* Command

-------------------------------
# Terminology

You need to understand the following terminology in Terraform contexts

* Configurations
* Provider
* Registry
* Backend
* States

-------------------------------

# [Configurations](https://registry.terraform.io/)

Configurations are code written for Terraform, using the human-readable HashiCorp Configuration Language (HCL) to describe the desired state of infrastructure resources.

-------------------------------

# [Provider](https://registry.terraform.io/)

Providers are the plugins that Terraform uses to manage those resources. Every supported service or infrastructure platform has a provider that defines which resources are available and performs API calls to manage those resources.

* [List of provider](https://registry.terraform.io/search/providers?namespace=hashicorp)

-------------------------------

# [Registry](https://registry.terraform.io/)

Registry makes it easy to use any provider or module. To use a provider or module from this registry, just add it to your configuration; when you run `terraform init`, Terraform will automatically download everything it needs.

-------------------------------

# [Backend](https://www.terraform.io/docs/language/settings/backends/index.html)

Backend defines where and how operations are performed, where state snapshots are stored, etc.

The local backend performs API operations directly from the machine where the terraform command is run

-------------------------------

# [State](https://www.terraform.io/docs/language/state/index.html)

State is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

* Default: local file named `terraform.tfstate`

-------------------------------

# HCl: Hashicorp Configuration Languaage

Terraform uses the [HCL](https://github.com/hashicorp/hcl) as DSL

* Pros:
  * Enable developers to manage many cloud providers with HCL
  * Mature
  * Well maintained official documents
* Cons:
  * HCL is not commonly used by non-Terraform software
  * Quality of the [language server](https://github.com/hashicorp/terraform-ls) is not good (but getting better recently)

-------------------------------

# 3 fundamental commands

We need to understand the following commands at least

* `terraform init`
* `terraform plan`
* `terraform apply`

-------------------------------

# [terraform init](https://www.terraform.io/docs/cli/commands/init.html)

* **Initialize a working directory containing Terraform configuration files**
* Safe to execute multiple times
* This command will never delete your existing configuration or state

-------------------------------

# [terraform plan](https://www.terraform.io/docs/cli/commands/plan.html)

* **Create an execution plan**
* You can check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state

-------------------------------

# [terraform apply](https://www.terraform.io/docs/cli/commands/apply.html)

* Apply the changes required to reach the desired state of the configuration

-------------------------------
<!-- This page is the start of new section !!-->

# Hands-on

See the [hands-on materials](./HANDSON.md)

-------------------------------
<!-- This page is the start of new section !!-->

# Tips

-------------------------------

# Don't be afraid of writing similar Terraform configs

The module feature is good for the team that heavily uses Terraform on daily bases. But, the design of a good module is not so easy if teams are not familiar with Terraform.

Instead, I strongly recommend writing Terraform like the official document describes (Let's accept redundancies!!). This way, all members can easily catch up even they don't configure the files by themselves.

-------------------------------
<!-- This page is the start of new section !!-->

# Q & A

-------------------------------

# Homework

If you want, we will assign some actual GitHub issues to use Terraform to you!

# ToDo

- [ ] Add more direct reference citation

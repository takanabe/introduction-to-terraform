# Hands-on 2: Incorporate existing AWS resources from new Terraform projects

## Background

If you used AWS and deployed some AWS resources such as S3, ECR, RDS from the web console, you may think that you want to manage them using Terraform as well. Through this hands-on, you will learn how we can manage existing AWS resources using Terraform.

## Goals

Through this session you will experience:

* How to retrieve information of existing AWS resources with `data` sources
* How to incorporate existing AWS resources to Terraform configurations (`terraform import`)

## Prerequisite

Please install the following software in advance for this hands-on.

* [jq](https://stedolan.github.io/jq/download/)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* [tfenv](https://github.com/tfutils/tfenv#installation)

## Related documents

* [Terraform: Date Sources](https://www.terraform.io/docs/language/data-sources/index.html)
* [Terraform import](https://www.terraform.io/docs/cli/import/index.html)

## Phase1. Create a new ECR with a new Terraform project

### Hands-on (5min)

Please create a new Terraform project directory named `project1` and deploy a new ECR repository. Expected output is illustrated as follows.

* repository_name: `tf_study_YOURNAME` (YOURNAME will be replaced by your name)
* tags
  * Name             = "search-infra-table-YOURNAME"
  * Owner            = "YOURNAME"
  * ExpireDate       = "2021-03-04"
  * ReasonForKeeping = "Used for search infra study session"

### Expected result

![](img/hands-on-2/phase1.drawio.svg)

If you don't understand how to set up a new Terraform project, please follow the steps of "[Hands-on 1: Phase1. Setup hands-on environment](./HANDSON1.md#)" so you can initialize Terraform project in `project1` directory.

### Example answer

```
$ mkdir project1 && cd project1
# initialize Terraform with the step described in HANDSON1.md
```

Now, check the [Terraform document to check the configurations of the ECR resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) and configure a new ECR.

```
$ cat <<EOF > ecr.tf
resource "aws_ecr_repository" "tf_study_taka" {
  name = "tf_study_taka"

  tags = {
    Name             = "tf-study-ecr-taka"
    Owner            = "taka"
    ExpireDate       = "2021-03-04"
    ReasonForKeeping = "Used for search infra study session"
  }
}
EOF
```

```
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_ecr_repository.tf_study_taka will be created
  + resource "aws_ecr_repository" "tf_study_taka" {
      + arn                  = (known after apply)
      + id                   = (known after apply)
      + image_tag_mutability = "MUTABLE"
      + name                 = "tf_study_taka"
      + registry_id          = (known after apply)
      + repository_url       = (known after apply)
      + tags                 = {
          + "ExpireDate"       = "2021-03-04"
          + "Name"             = "tf-study-ecr-taka"
          + "Owner"            = "taka"
          + "ReasonForKeeping" = "Used for search infra study session"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```



## Phase2. Retrieve another Terraform project

### Hands-on (5min)

We created the new ECR repository in the `project1`. Now, let's create another project directory named `project2` and initialize the project as you did for the project1.

Then, retrieve the ECR information using [data source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository). To check if your retrieval is succeeded, you can use [terraform console](https://www.terraform.io/docs/cli/commands/console.html) and specify the resources you defined with the ECR data source.

### Expected result

![](img/hands-on-2/phase2.drawio.svg)

### Example answer


```
cat <<EOF > ecr.tf
data "aws_ecr_repository" "tf_study_ecr_repo" {
  name = "tf_study_taka"
}
EOF
```

Check the successful data retrieval via `console` command.

```
$ terraform console
> data.aws_ecr_repository.tf_study_ecr_repo
{
  "arn" = "arn:aws:ecr:us-east-1:12345678910:repository/tf_study_taka"
  "encryption_configuration" = tolist([
    {
      "encryption_type" = "AES256"
      "kms_key" = ""
    },
  ])
  "id" = "tf_study_taka"
  "image_scanning_configuration" = tolist([
    {
      "scan_on_push" = false
    },
  ])
  "image_tag_mutability" = "MUTABLE"
  "name" = "tf_study_taka"
  "registry_id" = "12345678910"
  "repository_url" = "12345678910.dkr.ecr.us-east-1.amazonaws.com/tf_study_taka"
  "tags" = tomap({
    "ExpireDate" = "2021-03-04"
    "Name" = "tf-study-ecr-taka"
    "Owner" = "taka"
    "ReasonForKeeping" = "Used for search infra study session"
  })
}

> data.aws_ecr_repository.tf_study_ecr_repo.id
"tf_study_taka"
```

## Phase3. Import the state of ECR

### Hands-on (5min)

Finally, we will import the ECR repository created by the project1. This emulate the situation that somebody had created AWS resources without using Terraform and the people who manage the project 2 incorporate the AWS resources under their Terraform states.

You can use `terraform import` command to import states from the existing AWS resources. **The command you need to executed is described at the bottom of each (AWS provider) resource page**. For instance, if you want to know how to import the ECR repository your created, you need to check [the ecr_repository resource page](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#import)

### Expected result

![](img/hands-on-2/phase3.drawio.svg)


### Example answer

```
$ terraform state list
data.aws_ecr_repository.tf_study_ecr_repo
```

```
$ cat <<EOF > ecr.tf
resource "aws_ecr_repository" "tf_study_taka" {
  name = "tf_study_taka"

  tags = {
    Name             = "tf-study-ecr-taka"
    Owner            = "taka"
    ExpireDate       = "2021-03-04"
    ReasonForKeeping = "Used for search infra study session"
  }
}
EOF
```

```
$ terraform import aws_ecr_repository.tf_study_taka tf_study_taka
aws_ecr_repository.tf_study_taka: Importing from ID "tf_study_taka"...
aws_ecr_repository.tf_study_taka: Import prepared!
  Prepared aws_ecr_repository for import
aws_ecr_repository.tf_study_taka: Refreshing state... [id=tf_study_taka]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

```
$ terraform state list
data.aws_ecr_repository.tf_study_ecr_repo
aws_ecr_repository.tf_study_taka
```

Awesome! Now your Terraform states starts managing the ECR repository created by other project! 


Note: The ECR is currently managed by both the project1 and project2. But this does not recommend managing the state with this way. It just prepared the situation for `terraform import`.

![](img/hands-on-2/overview_of_hands_on_resutls.drawio.svg)

## Clean up!!

Congratulations!  You completed the all hands-on!

Before you leave this session, please remove all AWS resources you configured . The ECR is now managed by both project1 and project2 and you can run the following command in either directory.

```
$ terraform destroy
```

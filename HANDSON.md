# Hands-on

## Background

<details>
<summary>Hey, Taka! How did you learn and memorize Terraform configs?</summary>

```
# Answer

* Taka does not memorize most of the Terraform configs.
* But remember the fundamental terminlogies and initial config setups.
```

</details>

## Goals

Through this session you will experience:

* How to use the official documents of Terraform
* How to deploy AWS resouces using Terraform

## Expected output for you

The AWS resources surrounded by the red rectangle is your today's deploy target.

![](img/overview_of_hands_on_results.drawio.svg)

## Prerequisite

Please install the following software in advance for this hands-on.

* [jq](https://stedolan.github.io/jq/download/)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* [tfenv](https://github.com/tfutils/tfenv#installation)

## Phase1. Setup hands-on environment

### Step1. Assume to specified AWS IAM role

During this hands-on, you will use AWS account for development purpose. So, you need to assume role from your production IAM role to the development IAM role.

![](img/assume-role.drawio.svg)

Note: `arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME` will be provided by Taka during the hands-on.

```
git clone TODO
```


Please execute the following command to assume the specified IAM role:

```
$ envchain aws-cookpad script/assume-role.sh arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
```

<details>
<summary>Expected command output</summary>

```
envchain aws-cookpad script/assume-role.sh arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
Assuming role to arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
Succeed to assume role to arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
```
</details>
<br>

Now your terminal prompt becomes

```
[AWS_DEV_ACCOUNT] ~/Desktop/introduction-to-terraform]$
```

#### What if I don't use envchain?

If you don't store your AWS keys in credential manager using `envchain`, you can also directly pass the environment variables with:

```
$ AWS_ACCESS_KEY_ID=xxxxxxxxxx AWS_SECRET_ACCESS_KEY=yyyyyyyyyyyyyy script/assume-role.sh arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
Assuming role to arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
Succeed to assume role to arn:aws:iam::123456789:role/IAM_ROLE_YOU_WANT_TO_ASSUME
```

### Step2. Check if the assume role succeeded

To check if your assume role succeeded, please execute the command below.

```
$ aws s3 ls | grep search-infra-study-shared
2021-03-01 15:55:03 search-infra-study-shared
```

If you can find `search-infra-study-shared` in your `aws s3 ls` output, you successfully assumed the correct role.

### Step3. Terraform installation

```
$ mkdir new_project
$ cd new_project
$ echo 0.14.2 > .terraform-version
```

```
$ tfenv install
Terraform v0.14.2 is already installed
```

```
$ tfenv use 0.14.2
Switching default version to v0.14.2
Default version file overridden by /Users/takayuki-watanabe/Desktop/introduction-to-terraform/new_project/.terraform-version, changing the default version has no effect
Switching completed
```

## Phase2. Setup AWS provider

Next, we will setup the AWS provider. You can find the doc about the AWS provider [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).  With this hands-on, we will create `provider.tf`.

<details>
<summary>Cheat command to setup AWS provider</summary>

```
cat <<EOF > provider.tf
# Defined which provider we use
# This time we use AWS provider  version 3.0
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
EOF
```
</details>

## Phase3: Initialize Terraform project


Next, we will initiialze Terraform project. To do this, you need to run `terraform init` command.

<details>
<summary>Expected command output</summary>

```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 3.0"...
- Installing hashicorp/aws v3.30.0...
- Installed hashicorp/aws v3.30.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
</details>
<br>

This will create `.terraform` and `.terraformlock.hcl`. The `.terraform` directory stores the provider plugins and modules.

```
$ ls -lat
total 24
drwxr-xr-x  4 takayuki-watanabe  staff   128 Feb 26 16:21 ..
drwxr-xr-x  6 takayuki-watanabe  staff   192 Feb 26 16:20 .
-rwxrwxrwx  1 takayuki-watanabe  staff  1106 Feb 26 16:19 .terraform.lock.hcl
drwxr-xr-x  3 takayuki-watanabe  staff    96 Feb 26 16:19 .terraform
-rw-r--r--  1 takayuki-watanabe  staff   265 Feb 26 16:19 provider.tf
-rw-r--r--  1 takayuki-watanabe  staff     7 Feb 26 16:10 .terraform-version

$ tree .terraform
.terraform
└── providers
    └── registry.terraform.io
        └── hashicorp
            └── aws
                └── 3.30.0
                    └── darwin_amd64
                        └── terraform-provider-aws_v3.30.0_x5
```

## Phase4. Deploy your first AWS resources (S3)

Now you are ready to deploy your AWS resources using Terraform!! As the first challenge, let's deploy a new S3 bucket together. The document about S3 bucket resource is [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

![](./img/phase4.drawio.svg)

### Requirements of the new S3 bucket

* filename: `s3.tf`
* bucket name: `search-infra-study-YOURNAME` (YOURNAME will be replaced by your name)
* acl: `private`
* Put your test file onto the created S3 bucket after you created the S3 bucket

```
$ echo hello > hello_s3.txt
$ aws s3 cp hello_s3.txt s3://search-infra-study-taka/
$ aws s3 ls search-infra-study-taka/
2021-02-26 16:59:56          6 hello_s3.txt
```

### Example answer

<details>
<summary>Cheat command for S3 config</summary>

```
cat <<EOF > s3.tf
resource "aws_s3_bucket" "search_infra_study_YOURNAME" {
  # You should not use underscore as bucket names
  # Follow S3 bucket naming rules!!
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = "search-infra-study-YOURNAME"
  acl    = "private"

  tags = {
    Name        = "YOURNAME"
    Environment = "Dev"
  }
}
EOF
```
</details>

<details>
<summary>terraform plan</summary>

```
$ terraform plan
Acquiring state lock. This may take a few moments...
aws_s3_bucket.taka-test-project2-bucket-12345: Refreshing state... [id=taka-test-project2-bucket-12345]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.search_infra_study_YOURNAME will be created
  + resource "aws_s3_bucket" "search_infra_study_YOURNAME" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "search-infra-study-YOURNAME"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "Dev"
          + "Name"        = "YOURNAME"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

Releasing state lock. This may take a few moments...

```
</details>



### Note

If you have too many AWS resources deployed on developer account. You will encounter errors like below. In that case, please clean them up by yourself.

```
$ cat .terraform.tfstate.lock.info
{"ID":"8eaa4ed3-2e81-fdd6-6ec1-232d6ad37998","Operation":"OperationTypeApply","Info":"","Who":"takayuki-watanabe@P1753-19P13U.local","Version":"0.14.2","Created":"2021-02-26T07:34:38.589058Z","Path":"terraform.tfstate"}
```

# Phase5. Deploy your second AWS resource (DynamoDB)

Cool! you successfully deployed a new S3 bucket using Terraform. Now, you've understood how we can apply(deploy) AWS resources using Terraform. As the second challenge, let's deploy a new DynamoDB table by yourself. The document about DynamoDB table resource is [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)

### Hands-on (5min)

![](./img/phase5.drawio.svg)

I will give you 5 min. Please deploy a new DynamoDB table with the new file name `dynamodb.tf` and with the following requirements.

* table_name: `search-infra-study-YOURNAME` (YOURNAME will be replaced by your name)
* billing_mode: `PAY_PER_REQUEST`
* hash_key: `pk` with type string
* sort_key: `sk` with type string
* tags
  * Name             = "search-infra-table-YOURNAME"
  * Owner            = "YOURNAME"
  * ExpireDate       = "2021-03-04"
  * ReasonForKeeping = "Used for search infra study session"

### Example answer

<details>
<summary>Cheat command for DynamoDB table configurations</summary>

```
cat <<EOF > dynamodb.tf
resource "aws_dynamodb_table" "search_infra_study_taka" {
  name         = "search_infra_study_taka"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  tags = {
    Name             = "search-infra-table-taka"
    Owner            = "taka"
    ExpireDate       = "2021-03-04"
    ReasonForKeeping = "Used for search infra study session"
  }
}
EOF
```
</details>


<details>
<summary>Expected list-table output</summary>

```
$aws dynamodb --region us-east-1 list-tables
{
    "TableNames": [
        "search_infra_study_taka"
    ]
}
```
</details>


## Phase6. Use remote shared state

We've used local file systems to keep Terraform states. But, it's difficult to share with the team. Now, let's switch the state store from your local file system to Amazon S3.

The document on how we can setup the remote state storage is doicumented [here](https://www.terraform.io/docs/language/settings/backends/s3.html#example-configuration).


### Hands-on (5min)

![](./img/phase6.drawio.svg)

* Create a new file `backend.tf` and add remote backend configurations which uses
  * `search-infra-study-shared` as bucket
  * `terraform` as workspace_key_prefix
  * `terraform/search-infra-study-YOURNAME.tfstate` as key
  * region = "us-east-1"

### Example answer

<details>
<summary>Cheat command to set up remote state with S3 backend</summary>

```
$ cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket = "search-infra-study-shared"
    workspace_key_prefix = "terraform"
    key                  = "terraform/search-infra-study-YOURNAME.tfstate"
    region = "us-east-1"
  }
}
EOF
```
</details>

When you change the backend configurations, we need to run `terraform init`.

```
$ terraform init

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v3.30.0...
- Installed hashicorp/aws v3.30.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Now, you can find that your Terraform state is kept on the `search-infra-study-shared` S3 bucket!

```
aws s3 ls search-infra-study-shared/terraform/
2021-03-01 16:57:18       1806 search-infra-study-YOURNAME.tfstate
```


## Phase7. Use shared lock using DynamoDB

Awesome! You now shared the state on the S3 bucket. However, we still need to communicate with team members during `terraform` command because there are possibilities to override the terraform command each other and produce inconsistent states. 

To eliminate the inconsistent state issues, let's share state locks with the team members using DynamoDB! The configuration is described [here](https://www.terraform.io/docs/language/settings/backends/s3.html).

### Hands-on (5min)

![](img/phase7.drawio.svg)

* Add `dynamodb_table = "terraform-state-lock"` to your `backend.tf`

### Example answer

<details>
<summary>Command to configure state lock with DynamoDB</summary>

```
cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket = "search-infra-study-shared"
    workspace_key_prefix = "terraform"
    key                  = "terraform/search-infra-study-YOURNAME.tfstate"
    region = "us-east-1"
    dynamodb_table       = "terraform-state-lock"
  }
}
EOF
```
</details>

## Phase8. Import existing AWS resources (ECR)

Taka will carry on this phase instead of you since, he could prepare for cleaning up steps when all members share the remote state. (`terraform destroy` will cause issue.)

[here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)

### Hands-on

![](img/phase8.drawio.svg)

## Clean up!!

Congratulations!  You completed the all hands-on!

![](img/overview_of_hands_on_results.svg)

Before you leave this session, please remove all AWS resources you configured

```
$ aws s3api delete-object --key hello_s3.txt --bucket search-infra-study-YOURNAME
```

```
$ terraform destroy
```

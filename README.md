# Admin infrastructure

## About

Marc Gavanier Global Admin infrastructure describes resources involved in global and administration tasks such as identity and access management.

> This repository is NOT required for local development.

## Table of contents

- 🪧 [About](#about)
- 📦 [Prerequisites](#prerequisites)
- 🚀 [Installation](#installation)
- 🛠️ [Usage](#usage)
- 🤝 [Contribution](#contribution)
- 🏗️ [Built with](#built-with)
- 📝 [Licence](#licence)

## Prerequisites

- [Docker](https://www.docker.com/) or [Terraform CLI](https://www.terraform.io/cli)

## Installation

The following command allows to use the Terraform command line via Docker:
```shell
docker run --rm -it --name terraform -v ~/:/root/ -v $(pwd):/workspace -w /workspace hashicorp/terraform:light
```

For simplified use, you can create an alias:
```shell
alias terraform='docker run --rm -it --name terraform -v ~/:/root/ -v $(pwd):/workspace -w /workspace hashicorp/terraform:light'
```

Using this alias, there is no longer any difference between a terraform command executed via Docker or via Terraform CLI.

## Usage

### First use

When you deploy global admin infrastructure for the first time, you do not have any AWS IAM service account user neither associated AWS IAM access key to set up Terraform Cloud environment variables, since you are actually provisioning them using the global admin infrastructure.

There are two ways you can solve this for the first deployment:
- Temporary set Terraform Cloud environment variables with your root credentials, then replace them with the global admin service account credentials as soon as they are available. Finally, remove any access key associated with your root account when you do not need it
- Connect to your root account on your machine, then run Terraform apply locally, without using Terraform Cloud. Once your deployment has been completed, you can:
  - Set up AWS IAM access key id and secret access key in Terraform Cloud environment variables
  - Migrate your local state to Terraform Cloud
  - Remove your local root user configuration

### Set up variables in Terraform Cloud

#### Admin Users

```hcl
{
  "marc.gavanier" = {
    pgp_key_base_64 = "...[BASE64 PGP KEY OR KEYBASE USERNAME FOR USER 'marc.gavanier']..."
  }
  "firsname.lastname" = {
    pgp_key_base_64 = "...[BASE64 PGP KEY OR KEYBASE USERNAME FOR USER 'firsname.lastname']..."
  }
}
```

#### Service Users

Any service user is dedicated to a `service` in a `layer` of `project`.

In the following example, you can find the configuration for the service account of this project, service is `admin` in `infrastructure` layer of `marc-gavanier` project.

Next you can find multiple services accounts for `example` project which is composed of three layers `infrastructure`, `api` and `client`:
- `infrastructure` layer contains a service for `api` infrastructure deployment and another for `client` infrastructure deployment. These service accounts are used to create ressources required to run `api` and `client`
- `api` layer contains a service for `ci`. This service account is used by CI jobs to deploy the api on dedicated ressources provisioned by the `api` service of the `infrastructure` layer
- `client` layer contains a service for `ci`. This service account is used by CI jobs to deploy the client on dedicated ressources provisioned by the `client` service of the `infrastructure` layer

`groups` refers to json policy files you can find in [./assets/policies](./assets/policies) folder. Policy files contains the minimal statement required to fulfill a dedicated task by applying the least privilege principle.

```hcl
[
  {
    "project" = "marc-gavanier"
    "layer" = "infrastructure"
    "service" = "admin"
    "groups" = ["admin.deployer"]
    "pgp_key_base_64" = "...[BASE64 PGP KEY FOR SERVICE USER IN 'marc-gavanier' PROJECT, 'infrastructure' LAYER, AND 'admin' SERVICE - PART OF 'admin.deployer' GROUP]..."
  },
  {
    "project" = "example"
    "layer" = "infrastructure"
    "service" = "api"
    "groups" = ["api.deployer"]
    "pgp_key_base_64" = "...[BASE64 PGP KEY FOR SERVICE USER IN 'example' PROJECT, 'infrastructure' LAYER, AND 'api' SERVICE - PART OF 'api.deployer' GROUP]..."
  },
  {
    "project" = "example"
    "layer" = "infrastructure"
    "service" = "client"
    "groups" = ["client.deployer"]
    "pgp_key_base_64" = "...[BASE64 PGP KEY FOR SERVICE USER IN 'example' PROJECT, 'infrastructure' LAYER, AND 'client' SERVICE - PART OF 'client.deployer' GROUP]..."
  },
  {
    "project" = "example"
    "layer" = "api"
    "service" = "ci"
    "groups" = ["api.publisher"]
    "pgp_key_base_64" = "...[BASE64 PGP KEY FOR SERVICE USER IN 'example' PROJECT, 'api' LAYER, AND 'ci' SERVICE - PART OF 'api.publisher' GROUP]..."
  },
  {
    "project" = "example"
    "layer" = "client"
    "service" = "ci"
    "groups" = ["client.publisher"]
    "pgp_key_base_64" = "...[BASE64 PGP KEY FOR SERVICE USER IN 'example' PROJECT, 'client' LAYER, AND 'ci' SERVICE - PART OF 'client.publisher' GROUP]..."
  }
]
```

### Get users access keys id secret and login profile password

When an admin or a service user is present in Terraform variables, sensitive information such as access keys id secret and login profile password are encrypted using given pgp key.

You can get this encrypted sensitive information from [run outputs](https://app.terraform.io/app/marc-gavanier/workspaces/admin-production), then you need to use your private pgp key to decrypt the actual generated access keys id secret or login profile password.

Copy the encrypted value of `user_login_profiles_password` for a user you can find in the run outputs, then execute:
```shell
echo PASTE_USER_ENCRYPTED_PASSWORD | base64 --decode | gpg --decrypt
```

> Things to do when logged in for the first time:
> - Activate MFA in account security credentials
> - Change your password - consider using a very strong password stored in a password manager

Copy the encrypted value of `user_access_keys_id_secret` or `service_user_access_keys_id_secret` for a user you can find in the run outputs, then execute:
```shell
echo PASTE_USER_ENCRYPTED_SECRET_ACCESS_KEY | base64 --decode | gpg --decrypt
```

### Check and fix `.tf` files format

```shell
terraform fmt
```

### Verify ressources consistency

```shell
terraform validate
```

### Retrieve Terraform Cloud authentication token locally

```shell
terraform login
```

### Initialize state and plugins locally

```shell
terraform init
```

### Plan a run to check differences between the current and the next infrastructure state to be deployed

```shell
terraform plan
```

## Contribution

### Apply the next state of the infrastructure

Simply push the changes to the `main` branch, to apply the next state of the infrastructure in production, 

## Built with

### Langages & Frameworks

- [Terraform](https://www.terraform.io/) is an infrastructure as code software tool that allow to define and provide infrastructure using a declarative configuration language

### Tools

#### CI

- [Github Actions](https://docs.github.com/en/actions) is the continuous integration and deployment tool provided by GitHub
  - Deployment history is available [under Actions tab](https://github.com/marc-gavanier/admin-infrastructure/actions/)
- Repository secrets:
  - `TF_API_TOKEN`: Terraform Cloud API token which allows the CI to operate actions on Terraform Cloud

#### Deployment

- [Terraform Cloud](https://app.terraform.io/) is a cloud platform provided by HashiCorp to host Terraform infrastructure state and apply changes
  - Organization: [marc-gavanier](https://app.terraform.io/app/marc-gavanier/workspaces)
  - Workspaces: `admin-*`
    - [admin-production](https://app.terraform.io/app/marc-gavanier/workspaces/admin-production)
- [AWS](https://aws.amazon.com/) is a cloud provider platform provided by Amazon
  - User: `marc-gavanier.infrastructure.admin`
  - Group: `admin.deployer`

## Licence

See [LICENSE.md](./LICENSE.md) file in this repository.

# secure-service-networking-for-aws
Secure Service Networking for AWS w/ HashiCorp Consul

## Table of Contents

- [Architecture Overview](#Architecture%20Overview) 
- [Build Environment](#Build%20Environment) 
- [Obtain AWS credentials](#Obtain%20AWS%20credentials) 
- [Obtain HCP credentials](#Obtain%20HCP%20credentials) 
- [Troubleshooting](#Troubleshooting)

---

# Architecture Overview

Using AWS and HCP Credentials, you can create this architecture from a single `terraform apply` command (approx 35 mins build time).

![Secure Service Networking for AWS Architecture Overview](DOCS/DIAGS/Architecture_Overview.jpg)

---
# Build Environment

Executing this terraform definition will recreate the environment from the "Secure Service Networking for AWS" Instruqt workshop:
https://play.instruqt.com/hashicorp/tracks/secure-service-networking-for-aws


To run this you will need to set the following environment variables:

```sh
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
HCP_CLIENT_ID
HCP_CLIENT_SECRET
```

For example:
```sh
export HCP_CLIENT_ID=XxXx1xx47X5x4xxXxxXXXx0Xxx8xxxXX
export HCP_CLIENT_SECRET=Xxxx16xX2XXxXXxXxxx2xxxXxXXXxxxxXX0XxxXx_Xx4x09XxxXxxxxxxxxxxx9X
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXX6XXXXXX
export AWS_SECRET_ACCESS_KEY=Xx7XX9XxXXXXxxxXXx/xXXXXxx7xXXXxXXXxXXxX
```

Then:
```sh
terraform init
terraform plan
terraform apply
```

Approximately 25 - 30 minutes later you will receive the three HashiCups URLs for the three environments: EKS prod, EKS Dev, and ECS Dev.

To access the HCP Consul UI, first fetch the ACL token so that you can login using the following command:

`terraform output hcp_acl_token_secret_id`


---
# Troubleshooting

Tested with the following versions:

```sh
Terraform v1.1.9
on darwin_amd64
+ provider registry.terraform.io/gavinbunney/kubectl v1.14.0
+ provider registry.terraform.io/hashicorp/aws v3.75.1
+ provider registry.terraform.io/hashicorp/cloudinit v2.2.0
+ provider registry.terraform.io/hashicorp/consul v2.15.1
+ provider registry.terraform.io/hashicorp/hcp v0.26.0
+ provider registry.terraform.io/hashicorp/helm v2.5.1
+ provider registry.terraform.io/hashicorp/http v2.1.0
+ provider registry.terraform.io/hashicorp/kubernetes v2.11.0
+ provider registry.terraform.io/hashicorp/local v2.2.2
+ provider registry.terraform.io/hashicorp/random v3.1.3
+ provider registry.terraform.io/hashicorp/template v2.2.0
+ provider registry.terraform.io/hashicorp/tls v3.3.0
+ provider registry.terraform.io/terraform-aws-modules/http v2.4.1
```

Troubleshooting steps have been moved to the `./DOCS` folder:
[TROUBLESHOOTING.md](./DOCS/TROUBLESHOOTING.md)

---
# Terraform Trivadis LAB Host for OCI

## Introduction

A reusable and extensible Terraform module that provisions a Trivadis LAB Host for Oracle Cloud Infrastructure

It creates the following resources:

* A compute instance for a given VCN
* Optional n-number of hosts for multiple VCNs. This is used to build several identical environments for a training and laboratory environment.

The module can be parametrized by the number of participants. This will then create n numbers of  hosts.

## Prerequisites

* An OCI account
* Install [Terraform](https://www.terraform.io/downloads.html)
* Create a Terraform Configuration

**HINT** This terraform module does use `count` to create multiple identical resources. Due to this at least Terraform version 0.13.0+ is required.

## Quickstart

The module is available in [Terraform registry](https://registry.terraform.io/modules/Trivadis/tvdlab-host/oci/latest). You may either us it via registry or clone [terraform-oci-tvdlab-host](https://github.com/Trivadis/terraform-oci-tvdlab-host) from github.

Add the module to the `main.tf` with the mandatory parameter. Whereby the `host_subnet` does expect a list of subnet IDs where to create the hosts. Ideally create with the terraform module [tvdlab-vcn](https://registry.terraform.io/modules/Trivadis/tvdlab-vcn/oci/latest).

```bash
module "tvdlab-host" {
  source  = "Trivadis/tvdlab-host/oci"
  version = ">= 1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  tenancy_ocid          = var.tenancy_ocid
  compartment_id        = var.compartment_id
  ssh_public_key_path   = var.ssh_public_key_path
  host_subnet           = module.tvdlab-vcn.private_subnet_id
}
```

To create multiple hosts in different VCNs just specify the `numberOf_labs` parameter. The following example will create 3 hosts in the provided subnets. It is expected that `host_subnet` contains 3 different subnets.

```bash
module "tvdlab-host" {
  source  = "Trivadis/tvdlab-host/oci"
  version = ">= 1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  tenancy_ocid          = var.tenancy_ocid
  compartment_id        = var.compartment_id
  ssh_public_key_path   = var.ssh_public_key_path
  host_subnet           = module.tvdlab-vcn.private_subnet_id
  numberOf_labs      = 3
}
```

The module can be customized by a couple of additional parameter. See [variables](./doc/variables.md) for more information about customisation. The folder [examples](examples) does contain an example files for [main.tf](examples/main.tf), [variables.tv](examples/variables.tf) and [terraform.tfvars](examples/terraform.tfvars.example).

## Related Documentation, Blog

* [Oracle Cloud Infrastructure Documentation](https://docs.cloud.oracle.com/iaas/Content/home.htm)
* [Terraform OCI Provider Documentation](https://www.terraform.io/docs/providers/oci/index.html)
* [Terraform Creating Modules](https://www.terraform.io/docs/modules/index.html)

## Projects using this module

* [terraform-oci-tvdlab-base](https://github.com/Trivadis/terraform-oci-tvdlab-base) A reusable and extensible Terraform module that provisions a Trivadis LAB on Oracle Cloud Infrastructure.

## Releases and Changelog

You find all releases and release information [here](https://github.com/Trivadis/terraform-oci-tvdlab-host/releases).

## Issues
Please file your bug reports, enhancement requests, questions and other support requests within [Github's issue tracker](https://help.github.com/articles/about-issues/).

* [Questions](https://github.com/Trivadis/terraform-oci-tvdlab-host/issues?q=is%3Aissue+label%3Aquestion)
* [Open enhancements](https://github.com/Trivadis/terraform-oci-tvdlab-host/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement)
* [Open bugs](https://github.com/Trivadis/terraform-oci-tvdlab-host/issues?q=is%3Aopen+is%3Aissue+label%3Abug)
* [Submit new issue](https://github.com/Trivadis/terraform-oci-tvdlab-host/issues/new)

## How to Contribute

1. Describe your idea by [submitting an issue](https://github.com/Trivadis/terraform-oci-tvdlab-host/issues/new)
2. [Fork this respository](https://github.com/Trivadis/terraform-oci-tvdlab-host/fork)
3. [Create a branch](https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/), commit and publish your changes and enhancements
4. [Create a pull request](https://help.github.com/articles/creating-a-pull-request/)

## Acknowledgement

Code derived and adapted from [oracle-terraform-modules/terraform-oci-vcn](https://github.com/oracle-terraform-modules/terraform-oci-vcn) and Hashicorp's [Terraform 0.12 examples](https://github.com/terraform-providers/terraform-provider-oci/tree/master/examples).

## License

Copyright (c) 2019, 2020 Trivadis AG and/or its associates. All rights reserved.

The Trivadis Terraform modules are licensed under the Apache License, Version 2.0. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

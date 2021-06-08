# Example for tvdlab-compute

This directory contains examples for the use of the Terraform module *tvdlab-compute*.

* [main.tf](./main.tf) Example main file to use terraform module *tvdlab-compute* with all input variables.
* [terraform.tfvars.example](./terraform.tfvars.example) Example Terraform variable file.
* [variables.tf](./variables.tf) Variable definition file for the terraform module *tvdlab-vcn*.
* [linux](linux) Example for a linux based compute instance with cloud init bootstrap.
* [windows](windows) Example for a windows based compute instance cloud init bootstrap.

## Usage

The module is available in [Terraform registry](https://registry.terraform.io/modules/Trivadis/tvdlab-compute/oci/latest). You may either us it via registry or clone [terraform-oci-tvdlab-compute](https://github.com/Trivadis/terraform-oci-tvdlab-compute) from github.

__Note: This are an examples to demonstrate reusing this Terraform module to create additional network resources. Ensure you evaluate your own security needs when creating security lists, network security groups etc.__

### Basic Usage

In the simplest case, the module is used to create a single VCN. To do so add the module to the `main.tf` with the mandatory parameter.

```bash
module "tvdlab-compute" {
  source  = "Trivadis/tvdlab-compute/oci"
  version = ">= 1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  region         = var.region
  compartment_id = var.compartment_id
}
```

### Multiple VCN

This module uses the terraform function `count` to create several equal VCNs. Therefore the variable `tvd_participants` is set to the number of VCNs to be created. The following example will create 3 equal VCN where each VCN is named according its number and the compartment or if specified according to the variable `resource_name`. e.g. for a compartment O-SEC it will create VCN *osec00*, *osec01* and *osec02*. The naming schema will also be used for all other resources.

```bash
module "tvdlab-vcn" {
  source  = "Trivadis/tvdlab-vcn/oci"
  version = ">= 1.0.0"

  # - Mandatory Parameters --------------------------------------------------
  region            = var.region
  compartment_id    = var.compartment_id
  tvd_participants  = 3
}
```

## Customization

The module can be customized by a couple of additional parameter. See [variables](./doc/variables.md) for more information about customisation.

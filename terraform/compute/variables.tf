variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "cluster_subnet_id" {
  description = "Subnet for the bastion instance"
  type        = string
}

variable "permit_ssh_nsg_id" {
  description = "NSG to permit SSH"
  type        = string
}

variable "permit_k0s_api_nsg_id" {
  description = "NSG to permit K0S API"
  type        = string

}

variable "ssh_authorized_keys" {
  description = "List of authorized SSH keys"
  type        = list(any)
}

locals {
  controller_instance_config = {
    shape_id = "VM.Standard.A1.Flex"
    ocpus    = 1
    ram      = 6
    // Canonical-Ubuntu-22.04-aarch64-2022.08.10-0
    source_id   = "ocid1.image.oc1.iad.aaaaaaaaqkqbcixqa4vqmc2zmyeekjujq3uchh7p537gk7phvwhsvbr2btaa"
    source_type = "image"
    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
  worker_instance_config = {
    shape_id = "VM.Standard.A1.Flex"
    ocpus    = 1
    ram      = 6
    // Canonical-Ubuntu-22.04-Minimal-2022.08.16-0
    source_id   = "ocid1.image.oc1.iad.aaaaaaaaqkqbcixqa4vqmc2zmyeekjujq3uchh7p537gk7phvwhsvbr2btaa"
    source_type = "image"
    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
}
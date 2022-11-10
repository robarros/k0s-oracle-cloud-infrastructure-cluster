terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.75"
    }
  }
  required_version = ">= 0.15"
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

module "network" {
  source = "./network"

  compartment_id = var.compartment_id
  tenancy_ocid   = var.tenancy_ocid
}

module "compute" {
  source     = "./compute"
  depends_on = [module.network]

  compartment_id        = var.compartment_id
  tenancy_ocid          = var.tenancy_ocid
  cluster_subnet_id     = module.network.cluster_subnet.id
  permit_k0s_api_nsg_id = module.network.permit_k0s_api.id
  permit_ssh_nsg_id     = module.network.permit_ssh.id
  ssh_authorized_keys   = var.ssh_authorized_keys
}

# module "load_balancer" {
#   source     = "./load_balancer"
#   depends_on = [module.network]

#   compartment_id    = var.compartment_id
#   tenancy_ocid      = var.tenancy_ocid
#   workers           = module.compute.worker
#   cluster_subnet_id = module.network.cluster_subnet.id

# }

resource "oci_core_instance" "controller" {
  count               = 1
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad_3.name
  display_name        = "k8s-controller-${count.index + 1}"
  shape               = local.controller_instance_config.shape_id
  freeform_tags = {
    "role" = "controller"
  }
  source_details {
    source_id   = local.controller_instance_config.source_id
    source_type = local.controller_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.controller_instance_config.ram
    ocpus         = local.controller_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    nsg_ids    = [var.permit_ssh_nsg_id, var.permit_k0s_api_nsg_id]
  }
  metadata = {
    "ssh_authorized_keys" = local.controller_instance_config.metadata.ssh_authorized_keys
    "user_data" = base64encode(file("${path.module}/templates/user_data.sh"))
  }
}

resource "oci_core_instance" "worker" {
  count               = 3
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  display_name        = "k8s-worker-${count.index + 1}"
  shape               = local.worker_instance_config.shape_id
  freeform_tags = {
    "role" = "worker"
  }
  source_details {
    source_id   = local.worker_instance_config.source_id
    source_type = local.worker_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.worker_instance_config.ram
    ocpus         = local.worker_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id = var.cluster_subnet_id
    nsg_ids   = [var.permit_ssh_nsg_id, var.permit_k0s_api_nsg_id]
  }
  metadata = {
    "ssh_authorized_keys" = local.worker_instance_config.metadata.ssh_authorized_keys
    "user_data" = base64encode(file("${path.module}/templates/user_data.sh"))
  }
  depends_on = [oci_core_instance.controller]
}

locals {
  name          = "certmgr"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"

  layer = "services"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

module "service_account" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-service-account"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  namespace = var.namespace
  name = "installplan-approver-job"
  rbac_rules = [{
    apiGroups = ["operators.coreos.com"]
    resources = ["installplans","subscriptions"]
    verbs = ["get","list","patch"]
  }]
  sccs = ["anyuid"]
  server_name = var.server_name
  rbac_cluster_scope = false
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.yaml_dir}' '${var.namespace}'"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(var.git_credentials)
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}

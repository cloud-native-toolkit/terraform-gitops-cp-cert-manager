locals {
  name          = "certmgr"
  yaml_dir      = "${path.module}/chart/base"

  layer = "infrastructure"
  type = "base"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
  namespace = "cert-manager"
}

resource gitops_module module {

  name        = local.name
  namespace   = local.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer       = local.layer
  type        = local.type
  branch      = local.application_branch
  config      = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}

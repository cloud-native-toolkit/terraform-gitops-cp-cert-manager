![Verify and release module](https://github.com/cloud-native-toolkit/terraform-gitops-ocp-cert-manager/workflows/Verify%20and%20release%20module/badge.svg)


#  Gitops Certificate Manager terraform module

Deploys Jetstack cert-manager in RH OpenShift cluster via Gitops.  

## Supported platforms

- OCP 4.6+

## Suggested companion modules

The module itself requires some information from the cluster and needs a
namespace to be created. The following companion
modules can help provide the required information:

- Cluster - https://github.com/ibm-garage-cloud/terraform-cluster-ibmcloud

## Example usage

```hcl-terraform
module "ocp_certmgr" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-ocp-cert-manager"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name

}
```
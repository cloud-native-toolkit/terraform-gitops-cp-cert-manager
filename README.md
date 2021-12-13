![Verify and release module](https://github.com/cloud-native-toolkit/terraform-gitops-ocp-cert-manager/workflows/Verify%20and%20release%20module/badge.svg)


#  Gitops Certificate Manager terraform module

Deploys Jetstack cert-manager in RH OpenShift cluster via Gitops.  

***** This module is under development *****

## Supported platforms

- OCP 4.6+

## Module dependencies

The module uses the following elements

### Terraform providers

- null - used to run the shell scripts

### Environment

- kubectl - used to apply yaml 

## Suggested companion modules

The module itself requires some information from the cluster and needs a
namespace to be created. The following companion
modules can help provide the required information:

- Cluster - https://github.com/ibm-garage-cloud/terraform-cluster-ibmcloud

## Example usage

```hcl-terraform
module "dev_ocp_certmgr" {


}
```


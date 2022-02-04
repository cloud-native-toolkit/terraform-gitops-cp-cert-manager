#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE="openshift-operators"
BRANCH="main"
SERVER_NAME="default"
TYPE="base"
LAYER="2-services"

COMPONENT_NAME="certmgr"

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"

if [[ ! -f "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/cert-manager.yaml" ]]; then
  echo "Application values not found - payload/2-services/namespace/${NAMESPACE}/${COMPONENT_NAME}/cert-manager.yaml"
  exit 1
fi

echo "Printing payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/cert-manager.yaml"
cat "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/cert-manager.yaml"

#wait for argocd gitops to deploy
sleep 2m

count=0
NAMES=$(kubectl get csv cert-manager.v1.5.4 -n openshift-operators -o=jsonpath={.status..requirementStatus..name})

until [[ "$NAMES" =~ cert-manager.v1.5.4 && "$NAMES" =~ certificaterequests.cert-manager.io  ]] || [[ $count -eq 15 ]]; do
    count=$((count + 1))
    sleep 60
    NAMES=$(kubectl get csv cert-manager.v1.5.4 -n openshift-operators -o=jsonpath={.status..requirementStatus..name})
done

if [[ $count -eq 15 ]]; then
  echo "Timed out waiting for CertManager to deploy"
  exit 1
fi


cd ..
rm -rf .testrepo

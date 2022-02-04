#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../chart"; pwd -P)

DEST_DIR="$1"
NAMESP="$2"

mkdir -p "${DEST_DIR}"


echo "adding certmgr sub chart..."

#create operator
cat > "${DEST_DIR}/cert-manager.yaml" << EOL
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cert-manager
  namespace: ${NAMESP}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  channel: stable
  installPlanApproval: Manual
  name: cert-manager
  source: community-operators
  sourceNamespace: openshift-marketplace
  startingCSV: cert-manager.v1.5.4

EOL

echo "adding job to approve chart..."
$(mv ${CHART_DIR}/cert-job.yaml ${DEST_DIR}/job.yaml)


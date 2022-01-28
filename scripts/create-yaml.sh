#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
#MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../chart"; pwd -P)

DEST_DIR="$1"
#NAMESPACE="$2"

## Add logic here to put the yaml resource content in DEST_DIR

#find "${DEST_DIR}" -name "*"

mkdir -p "${DEST_DIR}"

mv ${CHART_DIR}/cert-mgr-sub.yaml ${DEST_DIR}/cert-manager.yaml

#sed -e "s/{{NAMESP}}/${NAMESPACE}/g" \
#    ${CHART_DIR}/certmgr-template.yaml > ${DEST_DIR}/certmgr.yaml

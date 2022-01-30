#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../chart"; pwd -P)

DEST_DIR="$1"

mkdir -p "${DEST_DIR}"

$(mv ${CHART_DIR}/cert-mgr-sub.yaml ${DEST_DIR}/cert-manager.yaml)

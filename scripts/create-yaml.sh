#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../chart"; pwd -P)

DEST_DIR="$1"
export NAMESPACE="$2"

if [[ -z "${DEST_DIR}" ]] || [[ -z "${NAMESPACE}" ]]; then
  echo "usage: create-yaml.sh DEST_DIR NAMESPACE"
fi

mkdir -p "${DEST_DIR}"

echo "adding job to approve chart..."
cp -R "${CHART_DIR}/"* "${DEST_DIR}"

YQ=$(command -v yq4 || command -v "${BIN_DIR}/yq4")

${YQ} e -i '.namespace = env(NAMESPACE)' "${DEST_DIR}/kustomization.yaml"
${YQ} e -i '.webhooks[0].namespaceSelector.matchExpressions[0].values[0] = env(NAMESPACE)' "${DEST_DIR}/patches/webhook-namespace-selector.yaml"

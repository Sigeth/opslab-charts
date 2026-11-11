#!/usr/bin/env bash
# Copies the files the chart takes from other repositories:
#   opslab/crds/                     <- opslab-core-go crds/ (tag in CORE_GO_VERSION)
#   opslab/files/operator-role.yaml  <- opslab-operator config/rbac/role.yaml (tag in OPERATOR_VERSION)
#
# CORE_GO_DIR / OPERATOR_DIR use local checkouts instead (development).
set -euo pipefail

cd "$(dirname "$0")/.."
OWNER="Sigeth"

fetch_dir() { # repo tag subdir dest
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "https://codeload.github.com/$OWNER/$1/tar.gz/refs/tags/$2" \
    | tar -xz -C "$tmp" --strip-components=1
  cp -r "$tmp/$3/." "$4/"
  rm -rf -- "$tmp"
}

find opslab/crds -name '*.yaml' -delete
if [[ -n "${CORE_GO_DIR:-}" ]]; then
  cp "$CORE_GO_DIR"/crds/*.yaml opslab/crds/
else
  fetch_dir opslab-core-go "$(tr -d '[:space:]' < CORE_GO_VERSION)" crds opslab/crds
fi

if [[ -n "${OPERATOR_DIR:-}" ]]; then
  cp "$OPERATOR_DIR/config/rbac/role.yaml" opslab/files/operator-role.yaml
else
  tmp="$(mktemp -d)"
  fetch_dir opslab-operator "$(tr -d '[:space:]' < OPERATOR_VERSION)" config/rbac "$tmp"
  cp "$tmp/role.yaml" opslab/files/operator-role.yaml
  rm -rf -- "$tmp"
fi
echo "synced CRDs and operator role"

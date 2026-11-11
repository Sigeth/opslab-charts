CHART := opslab

.PHONY: all sync lint template verify-generated

all: lint template

## sync: copy CRDs (core-go) and the operator RBAC role (operator) at their pinned tags
sync:
	scripts/sync.sh

lint:
	helm lint $(CHART)
	helm lint $(CHART) --set profile=cluster

## template: render the chart (both profiles) into rendered/
template:
	mkdir -p rendered
	helm template opslab $(CHART) --namespace opslab-system > rendered/single.yaml
	helm template opslab $(CHART) --namespace opslab-system --set profile=cluster > rendered/cluster.yaml

## verify-generated: fail if the synced files differ from the pinned tags (CI)
verify-generated: sync
	git diff --exit-code -- $(CHART)/crds $(CHART)/files

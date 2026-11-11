# opslab-charts

Helm chart of opslab (working name): the operator, the api (which also serves the web UI) and the gateway, plus the CRDs and the cluster-wide `PlatformConfig`.

> Status: M0. The chart renders and validates against a real API server. The images are published from M1.

## Install

```sh
helm install opslab ./opslab --namespace opslab-system --create-namespace
helm install opslab ./opslab --namespace opslab-system --create-namespace --set profile=cluster
```

| Value | Default | |
|---|---|---|
| `profile` | `single` | `single`: one Linux machine, `cluster`: 2 replicas + leader election |
| `image.registry` / `image.tag` | `ghcr.io/sigeth` / appVersion | Component images `opslab-<component>` |
| `instancesNamespace.name` | `opslab-instances` | Namespace of student instances (Pod Security `restricted`) |
| `platform.*` | | Cluster-wide policy (`PlatformConfig`) |
| `api.signingKeySecret` | generated | Secret holding the Ed25519 access token key (`key.pem`) |
| `httpRoute.*` | disabled | Gateway API routes for the UI/api and the gateway |

The api's access token key is generated at install time and kept across upgrades.

## Files synced from other repositories

`opslab/crds/` comes from [opslab-core-go](https://github.com/Sigeth/opslab-core-go), at the tag in `CORE_GO_VERSION`. `opslab/files/operator-role.yaml` comes from [opslab-operator](https://github.com/Sigeth/opslab-operator), at the tag in `OPERATOR_VERSION`. Don't edit these files: bump the tag and run `make sync`. CI fails if they drift.

## Development

```sh
make lint template                                   # rendered/single.yaml, rendered/cluster.yaml
CORE_GO_DIR=../core-go OPERATOR_DIR=../operator make sync
```

## License

[MIT](LICENSE)

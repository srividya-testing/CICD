# GitHub Actions: Build Docker & Deploy with Helm

This workflow builds your Docker image, pushes it to GHCR, and deploys to your cluster using Helm.

## Prerequisites

1. **GHCR permissions**: No extra secret needed. The built-in `GITHUB_TOKEN` has `packages:write` via the workflow's `permissions` block.
2. **Kubernetes access**: Create a kubeconfig for your target cluster and store it as **base64** in a repo secret `KUBECONFIG_B64`:

```bash
# example to generate the secret value
cat ~/.kube/config | base64 -w0
# copy this output into GitHub -> Settings -> Secrets and variables -> Actions -> New repository secret
# Name: KUBECONFIG_B64
```

> Tip: For cloud-native auth via OIDC (EKS IRSA, GKE Workload Identity, or AKS Federated Credentials), you can replace the kubeconfig step with cloud-specific setup and `kubectl` context login.

## Usage

- **Automatic on push to `main`** → deploys to **dev** using `charts/nodeapp/values-dev.yaml`.
- **Manual** via "Run workflow" → choose `dev` / `stage` / `prod` and optional custom `image_tag`.

The image is pushed to:
```
ghcr.io/<owner>/nodejs-docker-k8s-starter:<git-sha>
ghcr.io/<owner>/nodejs-docker-k8s-starter:latest
```

Helm command used:
```bash
helm upgrade --install nodeapp charts/nodeapp   -n <namespace>   -f charts/nodeapp/values-<env>.yaml   --set namespaceOverride=<namespace>   --set image.repository=ghcr.io/<owner>/nodejs-docker-k8s-starter   --set image.tag=<git-sha>
```

## Files

- `.github/workflows/deploy.yaml` — workflow
- `charts/nodeapp/values-dev.yaml` — dev config
- `charts/nodeapp/values-stage.yaml` — stage config
- `charts/nodeapp/values-prod.yaml` — prod config
```


# Kustomize for NodeApp

This adds Kustomize (base + overlays for dev / stage / prod).

## Structure
kustomize/
  base/                  # common manifests
    kustomization.yaml
    namespace.yaml
    deployment.yaml
    service.yaml
    ingress.yaml
    hpa.yaml
  overlays/
    dev/
      kustomization.yaml
      patch-replicas.yaml
      patch-ingress.yaml
    stage/
      kustomization.yaml
      patch-replicas.yaml
      patch-ingress.yaml
      patch-resources.yaml
    prod/
      kustomization.yaml
      patch-replicas.yaml
      patch-ingress.yaml
      patch-hpa.yaml

## Usage

### Build (see the rendered YAML)
kustomize build kustomize/overlays/dev
kustomize build kustomize/overlays/stage
kustomize build kustomize/overlays/prod

### Apply to a cluster
kubectl apply -k kustomize/overlays/dev
# or
kubectl apply -k kustomize/overlays/stage
kubectl apply -k kustomize/overlays/prod

## Customization tips

- **Image & tag**: in each overlay `kustomization.yaml`, edit the `images` section:
  ```yaml
  images:
    - name: ghcr.io/ajdevopssolutions/nodejs-docker-k8s-starter
      newTag: dev  # or stage/prod/<sha>
  ```

- **Config values**: change config literals via `configMapGenerator` in overlays; Kustomize will generate a new ConfigMap with a hash and update references automatically.

- **Namespaces**: overlays set namespaces (`app-demo`, `app-stage`, `app-prod`).

- **TLS**: in `prod/patch-ingress.yaml` add/change your real domain and certificate secret.

- **Scaling**: prod overlay sets replicas=3 and adjusts HPA via `patch-hpa.yaml`.

> You can combine with GitHub Actions using `kubectl apply -k` per environment.

# nodeapp Helm Chart

This chart deploys the minimal Express app to Kubernetes.

## Quickstart

```bash
# From repo root
cd charts/nodeapp

# Preview the manifests
helm template nodeapp . --namespace app-demo

# Install (namespace will be created automatically if you set namespaceOverride)
helm install nodeapp . --namespace app-demo --create-namespace   --set namespaceOverride=app-demo

# Or customize values
helm install nodeapp . -n app-demo -f myvalues.yaml
```

## Common customizations

- **Image**
  ```yaml
  image:
    repository: ghcr.io/<org-or-user>/nodejs-docker-k8s-starter
    tag: "1.0.0"
    pullPolicy: IfNotPresent
  ```

- **Ingress**
  ```yaml
  ingress:
    enabled: true
    className: nginx
    hosts:
      - host: nodeapp.example.com
        paths:
          - path: /?(.*)
            pathType: Prefix
    tls:
      - secretName: nodeapp-tls
        hosts:
          - nodeapp.example.com
  ```

- **Autoscaling**
  ```yaml
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 60
  ```

- **Environment (ConfigMap)**
  ```yaml
  env:
    PORT: "3000"
    MESSAGE: "Hello from ConfigMap 👋"
  ```

## Upgrade

```bash
helm upgrade nodeapp . -n app-demo
```

## Uninstall

```bash
helm uninstall nodeapp -n app-demo
```

## Notes

- Set `namespaceOverride` if you want resources explicitly in a given namespace (defaults to the release namespace).
- HPA requires `metrics-server`.
- Ingress requires an ingress controller (e.g., `ingress-nginx`).
```


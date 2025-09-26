# Node.js → Docker → Kubernetes (Ready-to-run Starter)

This is a minimal Express app, containerized with Docker, and deployable to Kubernetes with standard manifests.

## 1) Run locally (no Docker)

```bash
cd app
npm install
npm start
# open http://localhost:3000
```

## 2) Build & run with Docker

```bash
# from repo root
docker build -t nodejs-docker-k8s-starter:1.0.0 .
docker run -p 3000:3000 -e MESSAGE="Hello Local" nodejs-docker-k8s-starter:1.0.0
# open http://localhost:3000 and /healthz
```

## 3) Push to a registry (example: GitHub Container Registry)

1. Login:
   ```bash
   echo "$GHCR_TOKEN" | docker login ghcr.io -u <your-username> --password-stdin
   ```

2. Tag & push:
   ```bash
   docker tag nodejs-docker-k8s-starter:1.0.0 ghcr.io/<your-org-or-user>/nodejs-docker-k8s-starter:1.0.0
   docker push ghcr.io/<your-org-or-user>/nodejs-docker-k8s-starter:1.0.0
   ```

3. Update `k8s/deployment.yaml` image to the pushed registry path.

## 4) Deploy to Kubernetes

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml     # requires an Ingress controller like ingress-nginx
kubectl apply -f k8s/hpa.yaml         # requires metrics-server
```

Watch rollout:
```bash
kubectl -n app-demo get pods,svc,ingress,deploy,hpa
kubectl -n app-demo logs deploy/nodeapp -f
```

## 5) Accessing the app

- **Without Ingress**: Port-forward the service
  ```bash
  kubectl -n app-demo port-forward svc/nodeapp 8080:80
  # open http://localhost:8080
  ```

- **With Ingress**:
  - Make sure an Ingress controller (e.g., `ingress-nginx`) is installed.
  - Set a DNS record or add a hosts entry like: `127.0.0.1 nodeapp.local`
  - Open `http://nodeapp.local/`

## 6) Health, Probes & Scaling

- Readiness/Liveness: `/healthz`
- HPA scales between 2–10 pods at 60% CPU Utilization (requires `metrics-server`).

## 7) Customize

- Edit `MESSAGE` in `k8s/configmap.yaml`.
- Change image in `k8s/deployment.yaml` to your registry.
- Tweak resources/replicas as per environment.
- Add TLS to the Ingress by adding a `tls:` section and cert secret.

---

Made for quick starts in dev/test. For production, consider:
- Separate overlays per env (dev/stage/prod) via Kustomize or Helm
- PodDisruptionBudgets, PodSecurity, NetworkPolicies
- Centralized logging/metrics, structured logs
- CI/CD pipelines (GitHub Actions / Azure DevOps) to build & deploy automatically

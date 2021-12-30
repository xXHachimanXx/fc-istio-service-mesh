# Service Mesh with Istio

Here are all the "Service Mesh with Istio" course files. 

## Installation guides
- [k3d / Getting Started](https://k3d.io/)
- [Istio / Getting Started](https://istio.io/latest/docs/setup/getting-started/)
- [Fortio / Getting Started](https://github.com/fortio/fortio)

## Create a cluster
You can create a cluster in the cloud, but, for these experiments, i created a local cluster with K3d running the command:
```sh
k3d cluster create -p "8000:30000@loadbalancer" --agents 2
```

## How to install Istio in cluster?
```sh
istioctl install -y
```
## Inject sidecar proxy
To enable the sidecar proxy injection you need to run:
```sh
kubectl label namespace default istio-injection=enabled
```
This command will enable the sidecar proxy injection in every pod created in namespace with `default` label.

## Apply the deployment
```sh
kubectl apply -f deployment.yaml
```

## How to install Grafana, Jaeger, Kiali and Prometheus addons on Istio?
```sh
bash run-observers.sh
```

## Open kiali dashboard

```sh
istioctl dashboard kiali
```
After running the command, access: `http://localhost:20001/kiali/console`  

## Fire requests with Fortio

```sh
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/httpbin/sample-client/fortio-deploy.yaml
export FORTIO_POD=$(kubectl get pods -lapp=fortio -o 'jsonpath={.items[0].metadata.name}')
kubectl exec "$FORTIO_POD" -c fortio -- fortio load -c 2 -qps 0 -t 200s -loglevel Warning http://nginx-service:8000
```


```sh
kubectl apply -f consistent-hash.yaml
POD=$(kubectl get pods | grep nginx-a | head -n1 | cut -d' ' -f1)
kubectl exec -it $POD -- bash
```
When you are inside the pod, run `curl --header "x-user: user1" http://nginx-service:8000` many times. You will get the same response. Try another `x-user` and note the same effect. Stick sessions and consistent hash work to keep the users on the same version, in this case.

## How to create fault injections?

Run the command:
```sh
kubectl apply -f fault-injection.yaml
```
You can observe them in Kiali dashboard. 

## How to create an istio ingress gateway (if you have a cloud cluster)?

Just run the command:
```sh
kubectl apply -f gateway.yaml
```
## How to create an istio ingress gateway (if you have a local cluster)?

When you access localhost:8000, you'll be redirected to cluster port 30000, this way, you can access the LoadBalancer of `deployment.yaml`.

But now, we wanna access localhost:8000 and get redirected to the istio-ingressgateway. First, open `deployment.yaml` and edit the LoadBalancer nodePort to 30001 to let port 30000 free.

### Discover the NodePort of **istio-ingressgateway**
Run `kubectl get svc -n istio-system` and get the response:

```
NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)
istio-ingressgateway   LoadBalancer   10.43.31.68     <pending>     15021:30847/TCP,80:31784(<---- this one)/TCP
```

### Edit the **istio-ingressgateway** service NodePort

```sh
kubectl edit svc istio-ingressgateway -n istio-system
# Search for:
# - name: http2
#   nodePort: 31784 # Change 31784 to 30000 and save
#   port: 80
```

## How to create istio gateway based on subdomains?

Add "a.fullcycle.com" and "b.fullcycle.com" to /etc/hosts (or another hosts file) and run the command:
```sh
kubectl apply -f gateway-subdomains.yaml
```

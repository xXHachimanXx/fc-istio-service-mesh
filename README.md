# fc-istio-service-mesh

Here are all the "Service Mesh with Istio" course files.

## Links
- [k3d / Getting Started](https://k3d.io/)
- [Istio / Getting Started](https://istio.io/latest/docs/setup/getting-started/)
- [Fortio / Getting Started](https://github.com/fortio/fortio)

## How to install Istio in cluster?
```sh
istioctl install -y
```

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

## How to create an istio ingress gateway?

Just run the command:
```sh
kubectl apply -f gateway.yaml
```

## How to create istio gateway based on subdomains?

Add "a.fullcycle.com" and "b.fullcycle.com" to /etc/hosts (or another hosts file) and run the command:
```sh
kubectl apply -f gateway-subdomains.yaml
```

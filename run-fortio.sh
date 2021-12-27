kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/httpbin/sample-client/fortio-deploy.yaml;

export FORTIO_POD=$(kubectl get pods -l app=fortio -o 'jsonpath={.items[0].metadata.name}');

kubectl exec "$FORTIO_POD" -c fortio -- fortio load -c 2 -qps 0 -t 200s -loglevel Warning http://nginx-service:8080
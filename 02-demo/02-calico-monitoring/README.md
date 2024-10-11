aws-vault exec custom -- kubectl patch felixconfiguration default --type merge --patch '{"spec":{"prometheusMetricsEnabled": true}}'

aws-vault exec custom -- kubectl apply -f monitoring.yaml

aws-vault exec custom -- kubectl apply -f node-exporter.yaml

aws-vault exec custom -- kubectl apply -f kube-state-metrics/examples/standard/


aws-vault exec custom -- kubectl create -f svc.yaml



aws-vault exec custom -- kubectl create -f grafana.yaml


aws-vault exec custom -- kubectl apply -f dashboard.yaml

aws-vault exec custom -- kubectl create -f grafana-pod.yaml


echo "open http://localhost:3000"
aws-vault exec custom -- kubectl port-forward pod/grafana-pod 3000:3000 -n calico-monitoring


echo "open http://localhost:9090"
aws-vault exec custom -- kubectl port-forward svc/prometheus-dashboard-svc 9090:9090 -n calico-monitoring


aws-vault exec custom -- kubeshark tap
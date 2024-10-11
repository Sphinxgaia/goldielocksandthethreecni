#!/usr/bin/env bash

echo "open http://localhost:3000"
kubectl port-forward pod/grafana-pod 3000:3000 -n calico-monitoring


echo "open http://localhost:9090"
kubectl port-forward svc/prometheus-dashboard-svc 9090:9090 -n calico-monitoring
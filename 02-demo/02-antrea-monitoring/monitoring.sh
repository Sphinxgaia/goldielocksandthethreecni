#!/usr/bin/env bash


kubectl create -f dashboard.yaml

kubectl apply -f node-exporter.yaml

kubectl apply -f kube-state-metrics/examples/standard/


kubectl apply -f monitoring.yaml --wait

sleep 30

echo "open http://localhost:3000"
kubectl -n antrea-monitoring port-forward service/grafana --address 0.0.0.0 --address :: 3000:3000&
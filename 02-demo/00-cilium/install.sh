#!/usr/bin/env bash

cilium install --set cluster.name=goldie-cilium --version v1.16.2 -f config.yaml --set-string hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"

kubectl create -f ../02-$mycni-monitoring/dashboard.yaml

kubectl apply -f ../02-$mycni-monitoring/monitoring.yaml

kubectl apply -f ../02-$mycni-monitoring/node-exporter.yaml

kubectl apply -f ../02-$mycni-monitoring/kube-state-metrics/examples/standard/


cilium hubble enable --ui

echo "cilium hubble ui"

echo "kubectl -n cilium-monitoring port-forward service/grafana --address 0.0.0.0 --address :: 3000:3000"
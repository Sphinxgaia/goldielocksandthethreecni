#!/usr/bin/env bash

cilium uninstall

cilium install --version v1.16.2 --set cluster.name=goldie-cilium --set encryption.enabled=true    --set encryption.type=wireguard -f config.yaml --set-string hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"


kubectl create -f ../02-$mycni-monitoring/dashboard.yaml

kubectl apply -f ../02-$mycni-monitoring/monitoring.yaml

kubectl apply -f ../02-$mycni-monitoring/node-exporter.yaml

kubectl apply -f ../02-$mycni-monitoring/kube-state-metrics/examples/standard/


cilium hubble enable --ui

cilium status --wait

# aws autoscaling start-instance-refresh --auto-scaling-group-name goldielock-cnis-$mycni-sys --preferences MinHealthyPercentage=90,InstanceWarmup=60
# aws autoscaling start-instance-refresh --auto-scaling-group-name goldielock-cnis-$mycni-app --preferences MinHealthyPercentage=90,InstanceWarmup=60

echo -e  "### CHECK WIREGUARD in cilium agent ###"

kubectl -n kube-system exec -ti ds/cilium -- bash -c "
ip a

cilium status | grep Encryption

apt-get update
apt-get -y install tcpdump

tcpdump -n -i cilium_wg0

cilium debuginfo --output json | jq .encryption
"

# cilium config view | grep encryption

# kubectl -n kube-system exec -ti ds/cilium -- bash

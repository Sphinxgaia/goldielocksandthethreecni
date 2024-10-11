#!/usr/bin/env bash

kubectl patch ds aws-node -n kube-system --patch-file aws-node-delete.yaml

kubectl apply -f antrea-node-init.yaml
kubectl apply -f antrea.yaml

aws autoscaling start-instance-refresh --auto-scaling-group-name goldielock-cnis-$mycni-sys --preferences MinHealthyPercentage=90,InstanceWarmup=60
aws autoscaling start-instance-refresh --auto-scaling-group-name goldielock-cnis-$mycni-app --preferences MinHealthyPercentage=90,InstanceWarmup=60

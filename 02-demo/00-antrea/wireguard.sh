#!/usr/bin/env bash


kubectl apply -f antrea-wireguard.yaml

aws autoscaling start-instance-refresh --auto-scaling-group-name goldielock-cnis-$mycni-sys --preferences MinHealthyPercentage=90,InstanceWarmup=60
aws autoscaling start-instance-refresh --auto-scaling-group-name goldielock-cnis-$mycni-app --preferences MinHealthyPercentage=90,InstanceWarmup=60

sleep 180

kubectl get nodes -o yaml | grep -i wireguard
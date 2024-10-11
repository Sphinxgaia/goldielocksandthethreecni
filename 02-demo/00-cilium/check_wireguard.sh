#!/usr/bin/env bash


echo -e  "### CHECK WIREGUARD in cilium agent ###"

kubectl -n kube-system exec -ti ds/cilium -- bash -c "
ip a

cilium status | grep Encryption

cilium debuginfo --output json | jq .encryption
"
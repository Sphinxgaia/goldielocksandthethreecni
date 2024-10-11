#!/usr/bin/env bash

cilium hubble ui&

echo "open http://localhost:3000"
kubectl -n cilium-monitoring port-forward service/grafana --address 0.0.0.0 --address :: 3000:3000&
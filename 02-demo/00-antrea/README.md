# Installation & Configuring Antrea

> Un reboot des noeuds AWS peuvent s'avérer nécessaire pour la prise en compte de votre configuration

## Install

./install.sh

## Configuring wireguard

./wireguard.sh

## Configuring MTU

./mtu.sh

## Checks


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
spec:
  containers:
  - name: busybox
    image: busybox:1.28
    args:
    - sleep
    - "1000000"
EOF

kubectl exec --stdin --tty busybox-pod -- ip a | grep "eth0"
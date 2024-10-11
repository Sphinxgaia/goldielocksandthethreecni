# Goldie Locks and the Three CNI - Demo

## Préparation de votre poste utilisateur

> ########################################
> 
> Warning /!\ ceci est un lab, la configuration fournie n'est pas Prod-Ready /!\
> 
> ########################################

Pour ce labs, vous devez :
  [ ] Configurer votre shell
    [ ] Avoir votre shell configurer avec des tokens pour AWS et un rôle vous permettant de créer VPC et autres configurations nécessaire pour votre/cos clusters EKS  
  [ ] Installer des binaires
    [ ] Installer Terraform: `>= 0.13.1`
    [ ] Installer la CLI cilium : https://docs.cilium.io/en/v1.13/gettingstarted/k8s-install-default/#install-the-cilium-cli
    [ ] Installer HELM
  [ ] Configurer l'environnement de Terraform
    [ ] Mettre à jour les fichiers YAML en accord avec votre environnement `01-infra/aws/envs/...yaml`
    [ ] la partie CIDR doit être un /16 au risque de voir les configurations en place poser des soucis
  [ ] Niveau connexion internet
    [ ] ëtre dans la capacité de vous connecter sur des ports exotiques

## Configuration Environment

Configurer votre shell

> Pour ma part j'utilise aws-vault pour me connecter sur mon compte AWS
`alias cmd_prefix="aws-vault exec sso -- " `

```bash
alias cmd_prefix=""

export myarn="..."

export mycni="cilium"
export currentinstall=$(pwd)

cmd_prefix aws sts get-caller-identity


echo -e "### INITIALISATION DU DOSSIER TERRAFORM ### \n"

cd $currentinstall/01-infra/aws

terraform init
```

## Install

```bash
### CREATING EKS CLUSTER ###
echo -e "### CREATING EKS CLUSTER ### \n"

cd $currentinstall/01-infra/aws

terraform workspace select $mycni || terraform workspace new $mycni

cmd_prefix terraform apply -var adminarn="$myarn"

### CHECKING EKS CLUSTER ###
echo -e "### CHECKING EKS CLUSTER ### \n"

cmd_prefix aws eks update-kubeconfig --region eu-west-1 --name goldielock-cnis-$mycni

kubectl config set-context arn:aws:eks:eu-west-1:955480398230:cluster/goldielock-cnis-$mycni

cmd_prefix kubectl get no
cmd_prefix k9s 

### GET default MTU ### 
echo -e "### GET default MTU ### \n"

cd $currentinstall/02-demo/01-apps

cmd_prefix kubectl apply -f busypod.yaml
sleep 5
cmd_prefix kubectl exec --stdin --tty busybox-pod -- ip a | grep "eth0"

cmd_prefix kubectl delete -f busypod.yaml

### Install APPS ###
echo -e "### Install APPS ### \n"

cd $currentinstall/02-demo/01-apps

cmd_prefix kubectl apply -f manifest.yaml

cmd_prefix kubectl apply -f test.yaml

### INSTALL $mycni CNI ### 
echo -e "### INSTALL $mycni CNI ### \n"

cd $currentinstall/02-demo/00-$mycni

cmd_prefix ./cli.sh
cmd_prefix ./install.sh

cd $currentinstall/02-demo/01-apps

cmd_prefix kubectl delete --force -f busypod.yaml || true
cmd_prefix kubectl apply -f busypod.yaml
sleep 5
cmd_prefix kubectl exec --stdin --tty busybox-pod -- ip a | grep "eth0"

### ENABLE WIREGUARD ###
echo -e "### ENABLE WIREGUARD ###\n"

cd $currentinstall/02-demo/00-$mycni

cmd_prefix ./wireguard.sh

cd $currentinstall/02-demo/01-apps


cmd_prefix kubectl delete --force -f busypod.yaml

cmd_prefix kubectl delete deploy goldie-main
cmd_prefix kubectl delete ds goldie-body

cmd_prefix kubectl apply -f test.yaml

cmd_prefix kubectl apply -f busypod.yaml
sleep 5
cmd_prefix kubectl exec --stdin --tty busybox-pod -- ip a | grep "eth0"

cmd_prefix kubectl apply -f manifest.yaml

cmd_prefix kubectl apply -f test.yaml

### SHOW MONITORING ###
echo -e "### SHOW MONITORING ###\n"


cd $currentinstall/02-demo/02-$mycni-monitoring

cmd_prefix ./monitoring.sh

cmd_prefix kubectl -n $mycni-monitoring port-forward service/grafana --address 0.0.0.0 --address :: 3000:3000

```

## SHARKS

```bash

cd $currentinstall/02-demo/01-apps


cmd_prefix kubectl delete --force -f busypod.yaml

cmd_prefix kubectl delete deploy goldie-main
cmd_prefix kubectl delete ds goldie-body

sleep 10

cmd_prefix kubectl apply -f manifest.yaml

cmd_prefix kubeshark tap

export LB=$(cmd_prefix kubectl get svc goldie-main -o json | jq -r '.status.loadBalancer.ingress[0].hostname')

echo "open http://$LB:80/parts/body/body.svg"


echo -e "### CHANGING MTU ###\n"

cd $currentinstall/02-demo/00-$mycni

cmd_prefix ./mtu.sh


echo -e "### ENABLE EBPF ###\n"

cd $currentinstall/02-demo/00-$mycni

cmd_prefix ./ebpf.sh

cd $currentinstall/02-demo/01-apps

sleep 60

cmd_prefix kubectl delete --force -f busypod.yaml

cmd_prefix kubectl delete deploy goldie-main
cmd_prefix kubectl delete ds goldie-body

cmd_prefix kubectl apply -f test.yaml

cmd_prefix kubectl apply -f busypod.yaml
sleep 5
cmd_prefix kubectl exec --stdin --tty busybox-pod -- ip a | grep "eth0"

cmd_prefix kubectl apply -f manifest.yaml

cmd_prefix kubectl apply -f test.yaml


cmd_prefix kubeshark tap

```

## Clean up infra

```bash
export mycni="cilium"
export currentinstall=$(pwd)

echo -e "### Remove APPS ### \n"

cd $currentinstall/02-demo/01-apps

cmd_prefix kubectl delete -f manifest.yaml

echo -e "### DESTROY EKS CLUSTER ### \n"

cd $currentinstall/01-infra/aws
cd
terraform workspace select $mycni || terraform workspace new $mycni

cmd_prefix terraform destroy -var adminarn="$myarn"
```


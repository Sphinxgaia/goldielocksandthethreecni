# Préparation de votre poste utilisateur

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
  
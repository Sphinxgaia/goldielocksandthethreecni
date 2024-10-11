## Start API

aws-vault exec custom -- kubectl apply -f busybox.yaml

aws-vault exec custom -- kubectl apply -f manifest.yaml

## Test
export LB=$(aws-vault exec custom -- kubectl get svc goldie-main -o json | jq -r '.status.loadBalancer.ingress[0].hostname')

echo "open http://$LB:9000/parts/body/body.svg"

for i in {1..100}
do
  curl http://$LB:9000/parts/body/body.svg
  sleep 0.5
done








aws-vault exec custom -- kubectl delete -f manifest.yaml

DEFAULT_REGION=$(gcloud config get-value compute/region)
DEFAULT_ZONE=$(gcloud config get-value compute/zone)

gcloud -q compute instances delete \
  controller-0 controller-1 controller-2 \
  worker-0 worker-1 worker-2 \
  --zone $(gcloud config get-value compute/zone)
  
  
echo "Delete the external load balancer network resources:"


{
  gcloud -q compute forwarding-rules delete kubernetes-forwarding-rule \
    --region $DEFAULT_REGION

  gcloud -q compute target-pools delete kubernetes-target-pool

  gcloud -q compute http-health-checks delete kubernetes --region $DEFAULT_REGION

  gcloud -q compute addresses delete kubernetes-the-hard-way --region $DEFAULT_REGION
}

echo "Delete the kubernetes-the-hard-way firewall rules:"


gcloud -q compute firewall-rules delete \
  kubernetes-the-hard-way-allow-nginx-service \
  kubernetes-the-hard-way-allow-internal \
  kubernetes-the-hard-way-allow-external \
  kubernetes-the-hard-way-allow-health-check
  


echo "Delete the kubernetes-the-hard-way network VPC:"

{
  gcloud -q compute routes delete \
    kubernetes-route-10-200-0-0-24 \
    kubernetes-route-10-200-1-0-24 \
    kubernetes-route-10-200-2-0-24

  gcloud -q compute networks subnets delete kubernetes
  gcloud -q compute networks delete kubernetes-the-hard-way
}

echo "removing the Certs and configs"

rm *.pem
rm *.csr
rm *.json
rm *config

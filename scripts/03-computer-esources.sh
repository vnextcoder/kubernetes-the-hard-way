echo "Creating Network"

gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

echo "Create Network Subnet"
gcloud compute networks subnets create kubernetes \
  --network kubernetes-the-hard-way \
  --range 10.240.0.0/24


echo "Create a firewall rule that allows internal communication across all protocols:"

gcloud compute firewall-rules create kubernetes-the-hard-way-allow-internal \
  --allow tcp,udp,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

echo "Create a firewall rule that allows external SSH, ICMP, and HTTPS:"

gcloud compute firewall-rules create kubernetes-the-hard-way-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 0.0.0.0/0

echo "List the firewall rules in the kubernetes-the-hard-way VPC network:"
gcloud compute firewall-rules list --filter="network:kubernetes-the-hard-way"


echo "Allocate a static IP address that will be attached to the external load balancer fronting the Kubernetes API Servers:"

echo "Allocate a static IP address that will be attached to the external load balancer fronting the Kubernetes API Servers:"


DEFAULT_REGION=$(gcloud config get-value compute/region)
DEFAULT_ZONE=$(gcloud config get-value compute/zone)
gcloud compute addresses create kubernetes-the-hard-way --region $DEFAULT_REGION

gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"

echo "Create three controlplane instances:"
for i in 0 1; do
  gcloud compute instances create controller-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-2004-lts \
    --image-project ubuntu-os-cloud \
    --machine-type e2-standard-2 \
    --private-network-ip 10.240.0.1${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kubernetes-the-hard-way,controller \
    --zone $DEFAULT_ZONE
done

echo "Created three controlplane instances"


echo "Create three worker node instances "
for i in 0 1; do
  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-2004-lts \
    --image-project ubuntu-os-cloud \
    --machine-type e2-medium \
    --metadata pod-cidr=10.200.${i}.0/24 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kubernetes-the-hard-way,worker \
    --zone $DEFAULT_ZONE
done

echo "Created three worker node instances"

echo "listing all the instances"
gcloud compute instances list --filter="tags.items=kubernetes-the-hard-way"

echo "test the ssh keys by issuing 'gcloud compute ssh controller-0'"


docker build -t k8sclienttools .

docker run -ti --name gcloud-config2 k8sclienttools:latest  gcloud auth login
docker run --rm -it --volumes-from gcloud-config2 k8sclienttools:latest  gcloud compute instances list --project

docker run --rm -it -v C:\certs:/root/certs -v C:\sshkeys:/root/.ssh  --volumes-from gcloud-config2 k8sclienttools:latest /bin/bash


# gcloud compute project-info add-metadata \  --metadata google-compute-default-region=us-west1,google-compute-default-zone=us-west1-b

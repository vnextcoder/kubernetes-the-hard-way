FROM gcr.io/google.com/cloudsdktool/cloud-sdk:latest
WORKDIR /tmp
RUN apt-get update && apt-get install wget -y
COPY netscope.cer /tmp 
RUN cp /tmp/netscope.cer /usr/share/ca-certificates \
    && update-ca-certificates \
    && gcloud config set core/custom_ca_certs_file /tmp/netscope.cer
RUN wget --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson \
  --no-check-certificate
RUN chmod +x cfssl cfssljson && mv cfssl cfssljson /usr/local/bin/ && cfssl version && cfssljson --version

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl --no-check-certificate \
    && chmod +x kubectl \
    &&  mv kubectl /usr/local/bin/ && kubectl version --client
VOLUME [ "/root/.ssh" ]
# ENTRYPOINT [ "/bin/bash" , "-c"]

# FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine
# RUN apk --update add openjdk7-jre
# RUN gcloud components install app-engine-java kubectl
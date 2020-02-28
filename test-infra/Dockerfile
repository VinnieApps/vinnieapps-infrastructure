FROM ubuntu

RUN apt-get update && apt-get install -y git curl unzip gnupg2 python3 jq

# Create dir to store all binaries
RUN mkdir /tmp/bin
ENV PATH="/tmp/bin:${PATH}"

# Install terraform
RUN curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
RUN unzip /tmp/terraform.zip -d /tmp
RUN mv /tmp/terraform /tmp/bin

# Install gcloud tools
RUN curl -o gcp-script.sh https://sdk.cloud.google.com && chmod +x gcp-script.sh
RUN ./gcp-script.sh --install-dir=$(pwd) --disable-prompts
ENV PATH="/google-cloud-sdk/bin:${PATH}"
RUN gcloud components install kubectl

ARG CACHEBUST=1

# Clone repo
RUN git clone https://github.com/VinnieApps/vinnieapps-infrastructure.git

# Set working dir and checkout branch
WORKDIR vinnieapps-infrastructure
ARG BRANCH
RUN git fetch origin ${BRANCH} && git checkout ${BRANCH}

ARG PASSPHRASE
RUN /bin/bash scripts/decrypt.sh ${PASSPHRASE}

# Setup Google Cloud tools
RUN gcloud auth activate-service-account --key-file=environments/dev/credentials.json
RUN gcloud config set compute/zone us-east1-b
RUN gcloud config set project vinnieapps

RUN /bin/bash scripts/create_dev.sh vinnieapps tf-state-dev-vinnieapps

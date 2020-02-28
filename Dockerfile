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

RUN mkdir -p /opt/src

COPY . /opt/src/
WORKDIR /opt/src

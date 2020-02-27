FROM ubuntu

RUN apt-get update && apt-get install -y git curl unzip

# Create dir to store all binaries
RUN mkdir /tmp/bin
ENV PATH="/tmp/bin:${PATH}"

# Install terraform
RUN curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
RUN unzip /tmp/terraform.zip -d /tmp
RUN mv /tmp/terraform tmp/bin

ARG CACHEBUST=1 

# Clone repo
RUN git clone https://github.com/VinnieApps/vinnieapps-infrastructure.git

# Set working dir and checkout branch
WORKDIR vinnieapps-infrastructure
ARG BRANCH
RUN git fetch origin ${BRANCH} && git checkout ${BRANCH}

RUN /bin/bash scripts/create_dev.sh vinnieapps tf-state-dev-vinnieapps

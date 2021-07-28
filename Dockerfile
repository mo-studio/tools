
FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y curl git graphviz openssh-client python3-pip python-yaml unzip wget \
 && apt-get autoremove -y \
 && apt-get clean

ENV AWSCLI_VERSION=2.1.36

ENV TERRAFORM_VERSION=0.14.10

ENV TERRAGRUNT_VERSION=v0.28.20



COPY ./terraform ./home/amp
COPY ./terragrunt.hcl ./home/amp/

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && ./aws/install

# # Install terraform
RUN curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"  -o "terraform.zip"\
    && unzip 'terraform.zip' -d /usr/local/bin 

# Install terragrunt
RUN curl -o /usr/local/bin/terragrunt -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \ 
 && chmod +x /usr/local/bin/terragrunt

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]


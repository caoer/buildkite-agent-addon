FROM buildkite/agent:3.15.2-ubuntu
WORKDIR /setup

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y gnupg wget python python-pip unzip software-properties-common build-essential jq curl

# # aws-cli
# RUN curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip \
#     && unzip awscli-bundle.zip \
#     && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# # aws sam
# RUN pip install aws-sam-cli

# # aws-iam-authenticator
# RUN wget -O aws-iam-authenticator "https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator" \
#     && chmod +x ./aws-iam-authenticator \
#     && mv ./aws-iam-authenticator /usr/local/bin/

# # eksctl
# RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
#     && mv /tmp/eksctl /usr/local/bin

# helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# kops
RUN wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
    && chmod +x ./kops \
    && mv ./kops /usr/local/bin/


# yq (a command line yaml processor)
RUN add-apt-repository ppa:rmescandon/yq \
    && apt-get update \
    && apt install yq -y

# Golang!
RUN curl -s https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz -o go.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/root/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Protoc + a bunch of plugins
RUN apt-get install -y protobuf-compiler \
    && go get -u github.com/golang/protobuf/protoc-gen-go \
    && go get -u github.com/twitchtv/twirp/protoc-gen-twirp \
    && go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x -o install_node10x.sh \
    && chmod +x ./install_node10x.sh \
    && ./install_node10x.sh \
    && apt-get install -y nodejs
#!/bin/bash

if [ ! -f bin/terraform ]; then
  TERRAFORM_VERSION=0.9.8
  if [ $(uname) = "Darwin" ]; then
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_darwin_amd64.zip -O /tmp/terraform.zip
    unzip /tmp/terraform.zip
  else
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform.zip
    unzip /tmp/terraform.zip
  fi
fi

echo -n "aws_access_key_id: "
read aws_access_key_id

if [ -z "${aws_access_key_id}" ]; then
    echo "no aws_access_key_id"
    exit 1
fi

echo -n "aws_secret_access_key: "
read aws_secret_access_key

if [ -z "${aws_secret_access_key}" ]; then
    echo "no aws_secret_access_key"
    exit 1
fi

cat <<EOS > "$(dirname $0)/terraform.tfvars"
aws_access_key_id = "${aws_access_key_id}"
aws_secret_access_key = "${aws_secret_access_key}"
EOS


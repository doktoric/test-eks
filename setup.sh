#!/bin/bash

set -ex

: ${AWS_EKS_CLUSTER_NAME:? required}
: ${AWS_ROLE_NAME:? required}
: ${AWS_SUBNET_IDS:? required}
: ${AWS_SECURITY_GROUP_ID:? required}

aws eks create-cluster --name $EKS_CLUSTER_NAME --role-arn $AWS_ROLE_NAME --resources-vpc-config subnetIds=$AWS_SUBNET_IDS,securityGroupIds=$AWS_SECURITY_GROUP_ID
aws eks describe-cluster --name $EKS_CLUSTER_NAME --query cluster.status
aws eks describe-cluster --name $EKS_CLUSTER_NAME --query cluster.endpoint
aws eks describe-cluster --name $EKS_CLUSTER_NAME --query cluster.certificateAuthority.data

mkdir -p ~/.kube
export KUBECONFIG=$KUBECONFIG:~/.kube/config-$AWS_EKS_CLUSTER_NAME
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-$AWS_EKS_CLUSTER_NAME' >> ~/.bash_profile
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-$AWS_EKS_CLUSTER_NAME' >> ~/.bashrc
kubectl get all
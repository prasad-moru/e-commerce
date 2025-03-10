#!/bin/bash
# Step-by-step instructions to set up AWS Load Balancer Controller

# Prerequisites:
# 1. AWS CLI configured with admin access
# 2. kubectl installed and configured to your cluster
# 3. eksctl installed (for EKS clusters)

# Step 1: Create IAM policy
echo "Creating IAM policy for ALB controller..."
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json

# Step 2: Create IAM role and service account (for EKS)
# Replace with your actual values
CLUSTER_NAME="TFEKSWorkshop-cluster"
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

eksctl create iamserviceaccount \
  --cluster=${CLUSTER_NAME} \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

# Step 3: Install the TargetGroupBinding CRDs
echo "Installing TargetGroupBinding CRDs..."
kubectl apply -f alb-target-group-binding-crds.yaml

# Step 4: Update the Deployment manifest
echo "Please update alb-controller-deployment.yaml with your cluster name, VPC ID, and region before applying."
echo "  --cluster-name=${CLUSTER_NAME}"
echo "  --aws-vpc-id=<your-vpc-id>"
echo "  --aws-region=${AWS_REGION}"

# Step 5: Apply the controller manifests
echo "Applying AWS Load Balancer Controller manifests..."
kubectl apply -f alb-service-account.yaml
kubectl apply -f alb-cluster-role.yaml
kubectl apply -f alb-cluster-role-binding.yaml
kubectl apply -f alb-controller-deployment.yaml

# Step 6: Wait for the controller to start
echo "Waiting for AWS Load Balancer Controller to start..."
kubectl -n kube-system wait --for=condition=available --timeout=300s deployment/aws-load-balancer-controller

# Step 7: Apply the Ingress resource
echo "Applying ecommerce ingress resource..."
kubectl apply -f ecommerce-ingress.yaml

# Step 8: Get the ALB address
echo "Waiting for ALB to be provisioned (this may take a few minutes)..."
sleep 60
echo "Your ALB address should appear below (if provisioning is complete):"
kubectl get ingress -n e-commerce

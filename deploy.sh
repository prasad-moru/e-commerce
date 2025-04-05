#!/bin/bash

# Set environment - default to local if not specified
ENV=${1:-local}
echo "Deploying to $ENV environment..."

# Create namespaces first
echo "Creating namespaces..."
helm upgrade --install namespace-shared ./charts/namespace-shared -f ./values/$ENV/namespace-shared.yaml || true
helm upgrade --install namespace-ecommerce ./charts/namespace-ecommerce -f ./values/$ENV/namespace-ecommerce.yaml || true

# Deploy shared services
echo "Deploying shared services..."
helm upgrade --install mongodb ./charts/mongodb -f ./values/$ENV/mongodb.yaml
helm upgrade --install redis ./charts/redis -f ./values/$ENV/redis.yaml
helm upgrade --install elasticsearch ./charts/elasticsearch -f ./values/$ENV/elasticsearch.yaml

# Wait for shared services to be ready
echo "Waiting for shared services to be ready..."
kubectl wait --for=condition=ready pod -l app=mongo-deployment -n shared-services --timeout=120s
kubectl wait --for=condition=ready pod -l app=redis-deployment -n shared-services --timeout=120s
kubectl wait --for=condition=ready pod -l app=es-deployment -n shared-services --timeout=120s

# Deploy application services
echo "Deploying e-commerce services..."
helm upgrade --install products ./charts/products -f ./values/$ENV/products.yaml
helm upgrade --install cart ./charts/cart -f ./values/$ENV/cart.yaml
helm upgrade --install search ./charts/search -f ./values/$ENV/search.yaml
helm upgrade --install users ./charts/users -f ./values/$ENV/users.yaml
helm upgrade --install store-ui ./charts/store-ui -f ./values/$ENV/store-ui.yaml

echo "Deployment complete!"
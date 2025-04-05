#!/bin/bash

# Uninstall application services
echo "Removing e-commerce services..."
helm uninstall store-ui
helm uninstall users
helm uninstall search
helm uninstall cart
helm uninstall products

# Uninstall shared services
echo "Removing shared services..."
helm uninstall elasticsearch
helm uninstall redis
helm uninstall mongodb

# Remove namespaces
echo "Removing namespaces..."
helm uninstall namespace-ecommerce
helm uninstall namespace-shared

echo "Cleanup complete!"
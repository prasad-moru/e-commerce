# E-Commerce Kubernetes Deployment with Helm

This repository contains Helm charts for deploying an e-commerce microservices application to Kubernetes. It represents a migration from Kustomize-based deployment to standalone Helm charts for better flexibility and management.

## Architecture

The application consists of the following components:

### Shared Services (Namespace: `shared-services`)
- **MongoDB**: Database for product information
- **Redis**: Cache for cart service
- **Elasticsearch**: Search engine for product discovery

### Application Services (Namespace: `e-commerce`)
- **Products Service**: Manages product catalog and inventory
- **Cart Service**: Handles shopping cart functionality
- **Search Service**: Provides product search capabilities
- **Store UI**: Frontend web interface for customers
- **Users Service**: Manages user accounts and authentication

## Directory Structure

```
helm/
├── charts/
│   ├── namespace-shared/        # Chart to create shared-services namespace
│   ├── namespace-ecommerce/     # Chart to create e-commerce namespace
│   ├── mongodb/                 # Standalone MongoDB chart
│   ├── redis/                   # Standalone Redis chart
│   ├── elasticsearch/           # Standalone Elasticsearch chart
│   ├── products/                # Standalone Products service chart
│   ├── cart/                    # Standalone Cart service chart
│   ├── search/                  # Standalone Search service chart
│   ├── store-ui/                # Standalone Store UI chart
│   └── users/                   # Standalone Users service chart
├── values/                      # Environment-specific values
│   └── local/                   # Local environment values
│       ├── mongodb.yaml
│       ├── redis.yaml
│       └── ...
├── deploy.sh                    # Deployment script
└── cleanup.sh                   # Cleanup script
```

## Prerequisites

- Kubernetes cluster (Minikube for local development)
- Helm v3 installed
- kubectl configured to connect to your cluster

## Quick Start

### 1. Start Minikube (for local development)

On Windows:
```bash
minikube start --driver=hyperv
```

On macOS:
```bash
minikube start --driver=hyperkit
```

### 2. Deploy all services

Make the deployment script executable:
```bash
chmod +x deploy.sh
```

Deploy everything:
```bash
./deploy.sh local
```

### 3. Access the application

``` Summary: Migrating from Kustomize to Standalone Helm Charts
I've created individual Helm charts for each component of your e-commerce application. This approach gives you maximum flexibility to deploy, manage, and update services independently.
What's Been Created:

Independent Helm Charts for Each Service:

Shared Services: MongoDB, Redis, Elasticsearch
Application Services: Cart, Products, Search, Store UI, Users
Namespace Charts: For creating required namespaces


Well-Structured Templates:

Deployment templates with container specifications
Service templates with proper port configurations
ConfigMap templates for environment variables
Secret templates for sensitive data
Helper templates for reusable functions


Flexible Configuration:

Default values in each chart's values.yaml
Environment-specific overrides in separate files
Support for different service types (ClusterIP, NodePort)
Configurable resource requirements


Deployment Tools:

Shell script for deploying all components
Cleanup script for removing components
Documentation for manual deployment of individual charts



Key Benefits of This Approach:

Independent Service Lifecycle: Deploy, upgrade, or rollback any service independently
Service-Specific Configuration: Customize each service without affecting others
Simplified DevOps: Easier to integrate with CI/CD pipelines
Selective Deployment: Deploy only the services you need
More Maintainable: Clearly separated concerns for each component

How to Deploy:
The included deployment script makes it easy to deploy everything:
bashCopy./deploy.sh local
Or deploy individual components as needed:
bashCopyhelm install mongodb ./charts/mongodb -f ./values/local/mongodb.yaml
This approach gives you much more flexibility than the original Kustomize setup while preservingRetryClaude hit the max length for a message and has paused its response. You can write Continue to keep the chat going.BPContinue to keep chatEditThe approach I've suggested gives you much more flexibility than the original Kustomize setup while preserving all the original configuration and behavior. Let me finish explaining the benefits and provide some additional insights:
Additional Benefits of Standalone Helm Charts

Simplified Version Control:

Each service's chart can be versioned independently
You can track changes to individual services more easily
Allows for better release notes and change tracking


Enhanced Development Workflows:

Developers can test their service changes in isolation
Reduces conflicts when multiple teams work on different services
Makes it easier to experiment with new configurations


Better Resource Management:

Fine-grained control over each service's resources
Can scale individual components without redeploying everything
Easier to optimize resource allocation per service


Improved Troubleshooting:

Clearer separation makes it easier to debug issues
Can roll back just the problematic service
Better visibility into the configuration of each component


Production Readiness:

This structure scales better to production environments
Easier to implement different configurations per environment
More aligned with GitOps practices for Kubernetes



Next Steps and Best Practices

Chart Versioning:

Implement semantic versioning for each chart
Update the version field in Chart.yaml when making changes
Consider using an automated tool to manage chart versions


Documentation:

Add a README.md to each chart explaining its purpose and parameters
Document dependencies between services
Create a central documentation page for the entire application


CI/CD Integration:

Set up CI/CD pipelines to test and deploy chart changes
Implement automated testing for Helm charts
Consider using a Helm chart repository to store released versions


Advanced Configuration:

Implement health checks and readiness probes
Add support for horizontal pod autoscaling
Configure proper resource limits and requests for all containers


Security Enhancements:

Implement proper RBAC for service accounts
Consider using Helm's secrets management or integrate with Vault
Add network policies to control communication between services



Extending the Charts
The current charts cover the basic deployment needs, but you might want to extend them with:

Persistent Storage:

Add PersistentVolumeClaims for MongoDB and Elasticsearch
Configure proper backup and restore capabilities


Monitoring Integration:

Add Prometheus annotations for metrics scraping
Include default Grafana dashboards for each service


Logging:

Configure log collection and aggregation
Add standardized log formats across services


Ingress Configuration:

Add Ingress resources for external access
Configure TLS certificates for secure communication



Final Thoughts
This migration from Kustomize to standalone Helm charts represents a significant improvement in your Kubernetes deployment architecture. It maintains compatibility with your existing setup while providing much more flexibility and control.
The modular approach allows you to evolve each service independently, making it easier to adopt new technologies or patterns for individual components without disrupting the entire system.
Would you like me to explain any specific aspect of the migration in more detail or provide guidance on implementing any of the next steps I've suggested?

## Individual Chart Deployment

You can deploy each service independently:  ```

```bash
# Create namespaces first
helm install namespace-shared ./charts/namespace-shared
helm install namespace-ecommerce ./charts/namespace-ecommerce

# Deploy a shared service
helm install mongodb ./charts/mongodb -f ./values/local/mongodb.yaml

# Deploy an application service
helm install products ./charts/products -f ./values/local/products.yaml
```

## Configuration

Each chart includes default values in its `values.yaml` file. Environment-specific overrides are in the `values/<environment>/` directory.

### Example: Configuring MongoDB

Default values (`charts/mongodb/values.yaml`):
```yaml
image:
  repository: mongo
  tag: latest
  
service:
  type: ClusterIP
  port: 27017
```

Local overrides (`values/local/mongodb.yaml`):
```yaml
service:
  type: NodePort
  nodePort: 32017
```

## Service Dependencies

The application services depend on the shared services:

- **Products Service**: Requires MongoDB
- **Cart Service**: Requires Redis
- **Search Service**: Requires Elasticsearch

The deployment script handles the ordering to ensure dependencies are available.

## Ports

| Service | Internal Port | NodePort (Local) |
|---------|--------------|------------------|
| MongoDB | 27017 | 32017 |
| Redis | 6379 | 32379 |
| Elasticsearch (REST) | 9200 | 32200 |
| Elasticsearch (Inter-node) | 9300 | 32300 |
| Products Service | 5000 | - |
| Cart Service | 8080 | - |
| Search Service | 4000 | - |
| Store UI | 80 | 32080 |
| Users Service | 9090 | - |

## Migration from Kustomize

This Helm-based deployment replaces the previous Kustomize setup, offering several benefits:

1. **Independent Service Lifecycle**: Deploy, upgrade, or rollback any service independently
2. **Flexible Configuration**: More powerful templating and value overrides
3. **Simplified DevOps**: Better integration with CI/CD pipelines
4. **Improved Maintainability**: Clearer separation of concerns
5. **Enhanced Development Workflow**: Test changes to individual services in isolation

## Adding New Services

To add a new service:

1. Create a new directory in `charts/` for your service
2. Create the necessary templates (deployment.yaml, service.yaml, etc.)
3. Define default values in values.yaml
4. Add environment-specific overrides in `values/<environment>/`
5. Update the deployment script to include your new service

## Troubleshooting

### Check pod status
```bash
kubectl get pods -n shared-services
kubectl get pods -n e-commerce
```

### View logs for a specific service
```bash
kubectl logs -n e-commerce deployment/products-deployment
```

### Debug a specific chart
```bash
helm install --debug --dry-run my-test ./charts/products
```

## License

[MIT License](LICENSE)




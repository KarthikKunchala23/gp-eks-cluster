# gp-eks-cluster

# Terraform AWS EKS Cluster Module

A production-ready Terraform module for provisioning an Amazon EKS cluster on AWS with best practices for networking, security, Node Auto Scaling and Kubernetes add-ons.

This module creates an Amazon EKS cluster (Kubernetes **v1.34**) deployed into private subnets with configurable public and private API endpoint access. It also provisions managed node groups and Karpenter Node Auto Scaling, essential IAM roles, security groups, and EKS add-ons required for running production workloads.

Additional Kubernetes applications such as the AWS Load Balancer Controller, Secrets Store CSI Driver and Karpenter Controller are intentionally deployed through a separate Helm module to simplify dependency management and avoid provider initialization issues.

Kubernetes ec2nodeclass and nodepools along with testing manifest yaml are avialable at terraform/dev/karpenter_k8s/

---

## Features

- Amazon EKS Kubernetes **v1.34**
- Private worker nodes
- Managed Node Groups and Karpenter Managed Node Pools
- Configurable public/private API endpoint access
- IAM Roles for Service Accounts (IRSA)
- EKS Pod Identity support
- Amazon EBS CSI Driver add-on
- Amazon EKS Pod Identity Agent add-on
- Security Groups following AWS best practices
- Private subnet deployment
- Terraform remote state compatible
- Modular design

---

## Architecture

```
                    +----------------------+
                    |      Amazon VPC      |
                    +----------------------+
                              |
          -----------------------------------------
          |                                       |
  Public Subnets                          Private Subnets
          |                                       |
          |                               +----------------+
          |                               | EKS Control    |
          |                               | Plane          |
          |                               +----------------+
          |
          |                               +----------------+
          |                               | Managed Node   |
          |                               | Groups         |
          |                               +----------------+
          |
          |                                       |
          |                              EBS CSI Driver
          |                              Pod Identity Agent
          |
Internet
          |
Application Load Balancer
```

---

## Repository Structure

```
.
├── modules
│   ├── eks
│   ├── helm
│   └── vpc
└── terraform
    └── dev
```

| Module | Description |
|----------|-------------|
| `eks` | Creates the EKS cluster and managed node groups |
| `helm` | Deploys Kubernetes applications using Helm |
| `vpc` | Creates networking resources |

---

# Resources Created

The EKS module provisions the following resources.

### Amazon EKS

- EKS Cluster
- Managed Node Groups
- Cluster Security Group
- Node Security Group
- Launch Template
- EKS Access Entry

### IAM

- EKS Cluster IAM Role
- Node Group IAM Role
- IAM Roles for Service Accounts
- Pod Identity Associations
- Karpenter Node IAM Role with Managed Policies and Controller IAM Role

### EKS Add-ons

- Amazon EBS CSI Driver
- Amazon EKS Pod Identity Agent

---

# Helm Module

The Helm module is intentionally separated from the EKS module.

This design avoids Kubernetes and Helm provider initialization issues during cluster creation.

The Helm module retrieves cluster information using Terraform Remote State and deploys the following applications after the cluster is available.

- AWS Load Balancer Controller
- Secrets Store CSI Driver
- AWS Secrets & Configuration Provider (ASCP)
- Karpenter Controller

---

---

# Kubernetes Manifests

We have provided EC2NodeClass, Spot and On-demand NodePools along with Testing deployments of karpenter

- ec2nodeclass
- spot nodepool
- on-demand nodepool
- deployments for testing

---

---

# Karpenter Node Auto Scaling

This Project uses Karpenter for Scaling Nodes intelligently and cost savings.

This design avoids dependency on cluster auto scaling native to eks.

We use on-demand and spot nodepools with ec2 nodeclass.

Karpenter can handle the spot interuptions smartly using podDisruptionBudget where we can achieve zero down time.

Karpenter polls AWS SQS Queue for every 30s for any interuptions from AWS this events can be catched by Amazom Event Bridge Rules which triger to sqs queue.

- Karpenter
- PDB
- EC2NodeClass
- NodePools(Spot & On-demand)
- SQS & Event Bridge

Example logs from karpenter controller for polling message on SQS: 

{"level":"INFO","time":"2026-08-20T10:30:33.740Z","logger":"controller","message":"initiating delete from interruption message","commit":"f913f41","controller":"interruption","namespace":"","name":"","reconcileID":"f8de975e-1a21-4f9f-b95a-5d929eb92b05","queue":"gp-eks-dev-cluster-karpenter-interruption","messageKind":"spot_interrupted","NodeClaim":{"name":"spot-nodepool-5pff2"},"action":"CordonAndDrain","Node":{"name":"ip-10-0-5-103.ap-south-1.compute.internal"}}


---

## Example Usage

### Create the EKS Cluster

```terraform
module "eks" {
    source = "../../../modules/eks"
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    region = var.region
    kubernetes_version = var.cluster_version
    private_subnets = module.eks-vpc.private_subnet_ids
    encryption_config = {
        kms_key_arn = var.kms_key_arn
        resources = var.encryption_resources
    }
    env = var.env
    ami_type = var.ami_type
    node_instance_type = var.node_instance_type
    node_desired_size = var.node_desired_size
    node_max_size = var.node_max_size
    node_min_size = var.node_min_size
    disk_size = var.disk_size
    vpc_id = module.eks-vpc.vpc_id
    ebs_csi_driver_policy = var.ebs_csi_driver_policy   
    public_subnets = module.eks-vpc.public_subnet_ids
    depends_on = [ module.eks-vpc ]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_cidr             = var.public_cidr
    bootstrap_self_managed_addons = var.bootstrap_self_managed_addons
}
```

---

### Deploy Kubernetes Applications

After the EKS cluster is created.

```terraform
module "custom-addons-release" {
    source = "../../../modules/helm"
    vpc_id = data.terraform_remote_state.gp-eks-cluster.outputs.vpc_id
    cluster_name = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_name
    region = var.region
    aws_secrets_provider_name = var.aws_secrets_provider_name
    csi_secrets_store_name = var.csi_secrets_store_name
}
```

---

## Deployment Order

```
Terraform Apply

        │
        ▼

Create VPC

        │
        ▼

Create EKS Cluster

        │
        ▼

Create Managed Node Groups

        │
        ▼

Install EBS CSI Driver

        │
        ▼

Install Pod Identity Agent

        │
        ▼

Terraform Remote State

        │
        ▼

Deploy Helm Releases

        │
        ├──────── AWS Load Balancer Controller
        ├──────── Secrets Store CSI Driver
        └──────── AWS Secrets Configuration Provider
        └──────── Karpenter Controller
```

---

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.6 |
| AWS Provider | >= 6.0 |
| Helm Provider | >= 3.0 |
| Kubernetes Provider | >= 2.30 |

---

## Supported Kubernetes Version

| Kubernetes Version | Status |
|--------------------|--------|
| 1.34 | Supported |

---

## Inputs

Refer to the Terraform Registry Inputs section after publishing.

---

## Outputs

Refer to the Terraform Registry Outputs section after publishing.

---

## Best Practices

- Deploy worker nodes only in private subnets.
- Use private endpoint access whenever possible.
- Deploy Helm charts after cluster creation.
- Store Terraform state remotely using Amazon S3 and DynamoDB.
- Use IAM Roles for Service Accounts (IRSA) or EKS Pod Identity instead of static AWS credentials.
- Enable cluster logging for production environments.

---

## Future Enhancements

- Karpenter support ✅
- AWS VPC CNI customization ✅
- ExternalDNS ✅
- Metrics Server
- Cluster Autoscaler
- Argo CD
- Amazon Managed Prometheus
- Amazon Managed Grafana

---

## Contributing

Contributions are welcome.

Please open an issue to discuss major changes before submitting a pull request.

---

## License

This project is licensed under the MIT License.

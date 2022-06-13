# FRA-SSN-AWS - Deployment Pattern 1

Architecture details, documentation, and troubleshooting guidance about this deployment pattern can be found in the FRA-SSN-AWS [Wiki](https://github.com/hashicorp/fra-ssn-aws/wiki).

## Build this infrastructure

Before deploying apps/services we must build the infrastructure upon which they will run. We shall use `terraform` to create:

* 1x HCP Consul cluster
* 3x VPCs
* 2x EKS clusters
* 1x ECS cluster

NOTE: 20 - 25 mins build time

```sh
cd DEPLOYMENTS/deloyment1/infrastructure
terraform init
terraform plan
terraform apply
```

NOTE: To avoid name clashes, each deployment has a unique identifier. In this example, that unique ID is `y1g14o`, which you will see in the commands below. YOUR UNIQUE ID WILL BE DIFFERENT!

Once the `terraform apply` has successfully complete it shares output including, among other things, two `kubeconfig` files which contain information for executing `kubectl` commands which look something like:

```sh
kubeconfig_hcp-consul-y1g14o-eks-dev
kubeconfig_hcp-consul-y1g14o-eks-prod
```

---

## Deploying Services onto the EKS Prod environment

Verify communications with the k8s API:

```sh
export KUBECONFIG=kubeconfig_hcp-consul-y1g14o-eks-prod
kubectl get nodes
kubectl get pods
kubectl get services
```

### Install Consul
Installing Consul on the 'EKS Prod' cluster:

```sh
helm install consul hashicorp/consul --values consul_helm_chart_eks-prod.yaml --version 0.44.0 --debug --timeout 10m0s
```

### Verify Consul Install

```sh
kubectl get pods
kubectl get services
```
Everything should eventually reach the `Running` STATUS.

**NOTE:** You may see several pods in the `PodInitializing` STATUS. This is fine, keep running the `kubectl get pods` command.

**NOTE:** If you run into any issues, take a look at the Field Reference Architecture for Secure Service Networking on AWS [Wiki page for helm chart installs](https://github.com/hashicorp/fra-ssn-aws/wiki/Troubleshooting-EKS)

### Deploy Prod HashiCups

```sh
kubectl apply -f ../services/k8s-prod-app/manifests/
```

### Verify HashiCups Install

Assuming there was no install errors, you can now interact with the HashiCups application. `kubectl get pods` should now reveal something resembling:

```sh
NAME                                                    READY   STATUS    RESTARTS   AGE
consul-eks-prod-client-czvbk                            1/1     Running   0          7m10s
consul-eks-prod-client-mntx9                            1/1     Running   0          7m10s
consul-eks-prod-client-zdlsj                            1/1     Running   0          7m10s
consul-eks-prod-connect-injector-56f87d7fdb-8w875       1/1     Running   0          7m10s
consul-eks-prod-connect-injector-56f87d7fdb-z7qcn       1/1     Running   0          7m10s
consul-eks-prod-controller-7d49877ddf-ds2b6             1/1     Running   0          7m10s
consul-eks-prod-ingress-gateway-564c7784dc-nbl9q        2/2     Running   0          7m10s
consul-eks-prod-ingress-gateway-564c7784dc-p6gxf        2/2     Running   0          7m10s
consul-eks-prod-webhook-cert-manager-69f4746cbf-mckl4   1/1     Running   0          7m10s
frontend-d6c448596-7mnkc                                2/2     Running   0          105s
payments-67c89b9bc9-kg7c2                               2/2     Running   0          104s
postgres-8479965456-dlkv6                               2/2     Running   0          103s
product-api-dcf898744-bxjn2                             2/2     Running   0          102s
public-api-7f67d79fb6-jkf9z                             2/2     Running   0          102s
```

The output of `kubectl get services` should look like:

```sh
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)          AGE
consul-eks-prod-connect-injector     ClusterIP      172.20.215.131   <none>                                                                   443/TCP          6m51s
consul-eks-prod-controller-webhook   ClusterIP      172.20.141.65    <none>                                                                   443/TCP          6m51s
consul-eks-prod-dns                  ClusterIP      172.20.37.198    <none>                                                                   53/TCP,53/UDP    6m51s
consul-eks-prod-ingress-gateway      LoadBalancer   172.20.244.60    a7feccea756b54156a9e4d1dfa08c0db-786022078.us-west-2.elb.amazonaws.com   8080:32550/TCP   6m51s
frontend                             ClusterIP      172.20.13.177    <none>                                                                   80/TCP           87s
kubernetes                           ClusterIP      172.20.0.1       <none>                                                                   443/TCP          26m
payments                             ClusterIP      172.20.17.38     <none>                                                                   8080/TCP         85s
postgres                             ClusterIP      172.20.2.116     <none>                                                                   5432/TCP         85s
product-api                          ClusterIP      172.20.141.202   <none>                                                                   9090/TCP         84s
public-api                           ClusterIP      172.20.9.153     <none>                                                                   8080/TCP         83s
```

Pay particular attention to the `consul-eks-prod-ingress-gateway` service, and its `EXTERNAL-IP` and `PORT`

You should now be able to access HashiCups via:
`a7feccea756b54156a9e4d1dfa08c0db-786022078.us-west-2.elb.amazonaws.com:8080`


For a close inspection at service configurations you can use the `describe` commandm like so: `kubectl describe service consul-eks-prod-ingress-gateway`

If there were issues you would see them in the `Events:`.

---

## Deploying Services onto the EKS Dev environment

Lets get the development version of our demonstration app up and running. First:

```sh
export KUBECONFIG=kubeconfig_hcp-consul-y1g14o-eks-dev
kubectl get nodes
kubectl get pods
kubectl get services
```

### Install Consul

```sh
helm install consul hashicorp/consul --values consul_helm_chart_eks-dev.yaml --version 0.44.0 --debug --timeout 10m0s
```

### Verify Consul

The output of both `get services` and `get pods` should be very similar to the previoud **EKS Prod** deployment, however, with the addition of 'Consul Mesh Gateways', which will be used for communications with the ECS Cluster.

```sh
kubectl get pods 
kubectl get services 
```

### Install HashiCups

With comminication tested/established we are now ready to deploy:

```sh
kubectl apply -f ../services/k8s-dev-app/manifests/
```

When its finished, take a look at what's happened with the following commands:

```sh
kubectl get pods
kubectl describe pods consul-eks-dev-client-db7pv
kubectl get services
kubectl describe services consul-eks-dev-ingress-gateway
```
NOTE: You should now be able to use the `LoadBalancer Ingress:` address to reach the HashiCups application. 

NOTE: If the `Port` is anything other than `80` you will need to append it to the `LoadBalancer Ingress:` address.

If you want to programmatically fetch the Ingress Gateway's external hostname:
```sh
kubectl get services consul-eks-dev-ingress-gateway --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Communicating with multiple k8s clusters

Siwtching back and forth can be tedious. Try creating a kubectl alias for each cluster, e.g. after creating these two aliases:

```sh
alias kdev='KUBECONFIG=kubeconfig_hcp-consul-y1g14o-eks-dev kubectl'
alias kprod='KUBECONFIG=kubeconfig_hcp-consul-y1g14o-eks-prod kubectl'
```

I can now use `kprod get services` and `kdev get services` instead.

## Uninstalling the deployed service

`kubectl delete -f manifests/`

Review the deletion using `kubectl get services` 


More commands to experiment with can be found here:
https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources

## Removing the infrastructure:

```sh
cd ../../infrastructure 
terraform destroy
```

# Troubleshooting

NOTE: if you perform a `terraform destroy` (from within the `infrastructure/` directory) it will likely fail with a message as such:

```sh
module.hcp_vpc_eks_dev.module.vpc.aws_internet_gateway.this[0]: Still destroying... [id=igw-01c8895136322dcf0, 20m40s elapsed]
module.hcp_vpc_eks_dev.module.vpc.aws_internet_gateway.this[0]: Still destroying... [id=igw-01c8895136322dcf0, 20m50s elapsed]
module.hcp_vpc_eks_dev.module.vpc.aws_internet_gateway.this[0]: Still destroying... [id=igw-01c8895136322dcf0, 21m0s elapsed]
module.hcp_vpc_eks_dev.module.vpc.aws_internet_gateway.this[0]: Still destroying... [id=igw-01c8895136322dcf0, 21m10s elapsed]
╷
│ Error: error detaching EC2 Internet Gateway (igw-01c8895136322dcf0) from VPC (vpc-0a1d60da86c95ac61): DependencyViolation: Network vpc-0a1d60da86c95ac61 has some mapped public address(es). Please unmap those public address(es) before detaching the gateway.
│       status code: 400, request id: 6f75d13b-9e6f-480a-a9a8-6d5e9f4c954d
│ 
│ 
╵
╷
│ Error: uninstallation completed with 1 error(s): timed out waiting for the condition
```

This is because the application we deployed required for kubernetes to configure an external address associated with the infrastructure that was not generated by terraform and, therefore, not part of terraforms state file.

This is easily solved. Note in the error above that it is specifically referring to the resource that is causing the dependancy violation - its a 'network interface' attached to the Internet Gateway `igw-01c8895136322dcf0`. Delete this resource via the AWS Conole and re-run the `terraform destroy`

Navigate to here:
https://us-west-2.console.aws.amazon.com/ec2/home?region=us-west-2#NIC:

Select all, detach.

If terraform has times out, simply run the `terraform destroy` again.

NOTE: Occasionally one must manually delete the EKS security group in the VPC section also.






cp kubeconfig_hcp-consul-y1g14o-eks-dev ../services/k8s-dev-app
cp kubeconfig_hcp-consul-y1g14o-eks-prod ../services/k8s-prod-app
cd ../services/k8s-dev-app
export KUBECONFIG=kubeconfig_hcp-consul-y1g14o-eks-dev
kubectl get nodes
kubectl get pods

ls
kubectl apply -f manifests/



# Tested versions

This deployment pattern was tested with the following versions:

```sh
Terraform v1.1.9
on darwin_amd64
+ provider registry.terraform.io/gavinbunney/kubectl v1.14.0
+ provider registry.terraform.io/hashicorp/aws v3.75.1
+ provider registry.terraform.io/hashicorp/cloudinit v2.2.0
+ provider registry.terraform.io/hashicorp/consul v2.15.1
+ provider registry.terraform.io/hashicorp/hcp v0.26.0
+ provider registry.terraform.io/hashicorp/helm v2.5.1
+ provider registry.terraform.io/hashicorp/http v2.1.0
+ provider registry.terraform.io/hashicorp/kubernetes v2.11.0
+ provider registry.terraform.io/hashicorp/local v2.2.2
+ provider registry.terraform.io/hashicorp/random v3.1.3
+ provider registry.terraform.io/hashicorp/template v2.2.0
+ provider registry.terraform.io/hashicorp/tls v3.3.0
+ provider registry.terraform.io/terraform-aws-modules/http v2.4.1
```
# Troubleshooting Secure Service Networking on AWS

https://github.com/hashicorp/fra-ssn-aws/wiki

# Troubleshooting EC2

You will need the private key to establish an SSH session to the EC2 instance. 

After the ECS deployment, which uses an EC2 instance for its Mesh Gateway communication to services in the EKS Dev cluster, you should see the `tls_private_key = <sensitive>` in the terraform output. To access this data, execute:

`terraform output tls_private_key`

Copy the `private_key_pem` data including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`, but no more, to a local file name `key.pem`.

Mac, for secuity reasons:
`chmod 400 key.pem`

Add tcp port 22 access to the instance:

AWS Consul, Security groups. xxxxxxx  //TODO: document steps

Now you can access the EC2 instance using:

`ssh -i "key.pem" ubuntu@asdkjaksdjnaskjdnkas`

In the AWS Consul, navigate to EC2 instances. Select the instancte with the label consul-mgw
`ssh -i "deployer-one.pem" ubuntu@35.87.11.58`

//TODO: output the external IP of the EC2 instance 

## Troubleshooting Consul

If you installed consul via a package distribution system (recommended) the systemd unit should have been created for you.

You can verify the consul binary is operating using:

`systemctl status consul`

Output can be viewed:

`journalctl `


```sh
kubectl get pods
error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
```


## Troubleshooting Envoy

COMING SOON

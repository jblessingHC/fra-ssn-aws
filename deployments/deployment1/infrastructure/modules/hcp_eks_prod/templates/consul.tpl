global:
  enabled: false
  name: consul-${env_name}
  datacenter: ${consul_datacenter}
  image: "hashicorp/consul-enterprise:1.11.6-ent"
  imageEnvoy: "envoyproxy/envoy-alpine:v1.20.2"
  enableConsulNamespaces: true
  adminPartitions:
    enabled: true
    name: "${env_name}"
  acls:
    manageSystemACLs: true
    bootstrapToken:
      secretName: ${cluster_id}-hcp
      secretKey: bootstrapToken
  tls:
    enabled: true
    enableAutoEncrypt: true
    caCert:
      secretName: ${cluster_id}-hcp
      secretKey: caCert
  gossipEncryption:
    secretName: ${cluster_id}-hcp
    secretKey: gossipEncryptionKey
#  metrics:
#    enabled: true

externalServers:
  enabled: true
  hosts: ${consul_hosts}
  httpsPort: 443
  useSystemRoots: true
  k8sAuthMethodHost: ${k8s_api_endpoint}

server:
  enabled: false

client:
  enabled: true
  join: ${consul_hosts}
  nodeMeta:
    terraform-module: "hcp-eks-client"

connectInject:
  transparentProxy:
    defaultEnabled: true
  enabled: true
  default: true
#  metrics:
#    defaultEnableMerging: true

controller:
  enabled: true

ingressGateways:
  enabled: true
  gateways:
    - name: ingress-gateway
      service:
        type: LoadBalancer
        ports:
        - port: 80

dns:
  enabled: true
  enableRedirection: true

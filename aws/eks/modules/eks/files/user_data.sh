MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: "${cluster_name}"
    apiServerEndpoint: "${api_server_endpoint}"
    certificateAuthority: "${certificate_authority}"
    cidr: "${service_cidr}"
--BOUNDARY--
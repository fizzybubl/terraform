resource "aws_acm_certificate" "openvpn" {
  private_key       = file("${path.module}/files/certificates/server.io.key")
  certificate_body  = file("${path.module}/files/certificates/server.io.crt")
  certificate_chain = file("${path.module}/files/certificates/ca.crt")
}
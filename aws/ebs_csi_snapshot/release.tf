resource "helm_release" "csi_snapshot_lifecycle" {
  name   = "csi_snapshot_lifecycle"
  chart  = "${path.module}/csi_snapshot_lifecycle"
  values = [file("${path.module}/files/values.yaml")]
}
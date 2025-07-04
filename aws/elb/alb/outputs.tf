output "alb_id" {
  value = aws_lb.this.id
}

output "targets_to_listeners" {
  value = local.targets_to_listeners
}
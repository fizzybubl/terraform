output "instance_id" {
  value = try(aws_instance.this[0].id, "")
}


output "asg_id" {
  value = try(aws_autoscaling_group.this[0].id, "")
}


output "asg_name" {
  value = try(aws_autoscaling_group.this[0].name, "")
}


output "asg_arn" {
  value = try(aws_autoscaling_group.this[0].arn, "")
}
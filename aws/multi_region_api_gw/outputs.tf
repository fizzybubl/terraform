output "user" {
  value = {
    user_id    = data.aws_caller_identity.current_user.user_id
    account_id = data.aws_caller_identity.current_user.account_id
    id         = data.aws_caller_identity.current_user.id
  }
}


output "url" {
  value = aws_api_gateway_stage.name.invoke_url
}
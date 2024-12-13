resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = var.bucket_id

  dynamic "rule" {
    for_each = var.rules
    content {
      id = rule.key
      status = rule.value.status

      dynamic "filter" {
        for_each = rule.value.filter
        content {
          
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition
        content {
          storage_class = transition.value.storage_class
          days = transition.value.days
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration
       content {
          date = expiration.value.date
       }
      }
    }
  }
}
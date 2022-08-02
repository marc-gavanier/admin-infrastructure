locals {
  service_users = {
    for service_user in var.service_users : "${service_user.project}.${service_user.layer}.${service_user.service}" => {
      pgp_key_base_64 = service_user.pgp_key_base_64
      context = {
        context_project = service_user.project
        context_layer   = service_user.layer
        context_service = service_user.service
      }
    }
  }
}

resource "aws_iam_user" "service_users" {
  for_each      = local.service_users
  name          = each.key
  path          = "/service_users/"
  force_destroy = true
  tags          = merge(local.tags, each.value.context)
}

resource "aws_iam_access_key" "service_user_access_keys" {
  for_each   = local.service_users
  user       = each.key
  pgp_key    = each.value.pgp_key_base_64
  depends_on = [aws_iam_user.service_users]
}

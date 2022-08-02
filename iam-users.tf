locals {
  iam_users = merge(var.admin_users)
}

resource "aws_iam_user" "users" {
  for_each      = local.iam_users
  name          = each.key
  path          = "/users/"
  force_destroy = true
  tags          = local.tags
}

resource "aws_iam_user_login_profile" "user_login_profiles" {
  for_each   = local.iam_users
  user       = each.key
  pgp_key    = each.value.pgp_key_base_64
  depends_on = [aws_iam_user.users]
}

resource "aws_iam_access_key" "user_access_keys" {
  for_each   = local.iam_users
  user       = each.key
  pgp_key    = each.value.pgp_key_base_64
  depends_on = [aws_iam_user.users]
}

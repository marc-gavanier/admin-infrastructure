locals {
  full_access_administrator_group_name = "full-access.admin"
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group" "administrator_group" {
  name = local.full_access_administrator_group_name
  path = "/${split(".", local.full_access_administrator_group_name)[1]}/"
}

resource "aws_iam_group_policy_attachment" "full_access_administrator" {
  group      = aws_iam_group.administrator_group.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

resource "aws_iam_group_membership" "administrators_group" {
  name       = "${local.full_access_administrator_group_name}_group_membership"
  users      = keys(var.admin_users)
  group      = local.full_access_administrator_group_name
  depends_on = [aws_iam_user.users]
}

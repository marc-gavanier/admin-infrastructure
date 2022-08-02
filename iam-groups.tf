locals {
  policy_files = {
    for policy_file in fileset("${path.root}/assets/policies", "*") : trimsuffix(policy_file, ".json") => {
      name  = split(".", policy_file)[0]
      label = trimsuffix(split(".", policy_file)[1], ".json")
    }
  }
}

locals {
  iam_service_users_groups = {
    for iam_service_user in var.service_users : "${iam_service_user.project}.${iam_service_user.layer}.${iam_service_user.service}" => iam_service_user.groups
  }
}

resource "aws_iam_policy" "service_account_policies" {
  for_each    = local.policy_files
  name        = "${title(each.value.name)}${title(each.value.label)}"
  path        = "/${each.value.label}/"
  description = "IAM ${each.value.name} ${each.value.label} policy for ${each.value.name} ${each.value.label} group"
  policy      = file("assets/policies/${each.key}.json")
  tags        = local.tags
}

resource "aws_iam_group" "service_account_groups" {
  for_each = local.policy_files
  name     = each.key
  path     = "/${each.value.label}/"
}

resource "aws_iam_group_policy_attachment" "service_account_policy_attachements" {
  for_each   = local.policy_files
  group      = aws_iam_group.service_account_groups[each.key].name
  policy_arn = aws_iam_policy.service_account_policies[each.key].arn
}

resource "aws_iam_group_membership" "projects_group_memberships" {
  for_each   = transpose(local.iam_service_users_groups)
  name       = "${each.key}_group_membership"
  users      = each.value
  group      = each.key
  depends_on = [aws_iam_user.service_users, aws_iam_group.service_account_groups]
}

output "user_login_profiles_password" {
  value = tomap({
    for key, user_login_profile in aws_iam_user_login_profile.user_login_profiles : key => user_login_profile.encrypted_password
  })
}

output "user_access_keys_id" {
  value = tomap({
    for key, user_access_key in aws_iam_access_key.user_access_keys : key => user_access_key.id
  })
}

output "user_access_keys_id_secret" {
  value = tomap({
    for key, user_access_key in aws_iam_access_key.user_access_keys : key => user_access_key.encrypted_secret
  })
}

output "service_user_access_keys_id" {
  value = tomap({
    for key, iam_service_user_access_key in aws_iam_access_key.service_user_access_keys : key => iam_service_user_access_key.id
  })
}

output "service_user_access_keys_id_secret" {
  value = tomap({
    for key, iam_service_user_access_key in aws_iam_access_key.service_user_access_keys : key => iam_service_user_access_key.encrypted_secret
  })
}

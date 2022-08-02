data "aws_caller_identity" "current_iam" {}

locals {
  tags = {
    context_project                   = local.product_information.context.project
    context_layer                     = local.product_information.context.layer
    context_service                   = local.product_information.context.service
    context_start_date                = local.product_information.context.start_date
    context_end_date                  = local.product_information.context.end_date
    purpose_environment               = terraform.workspace
    purpose_disaster_recovery         = local.product_information.purpose.disaster_recovery
    purpose_service_class             = local.product_information.purpose.service_class
    organization_client               = local.product_information.organization.client
    stakeholders_business_owner       = local.product_information.stakeholders.business_owner
    stakeholders_technical_owner      = local.product_information.stakeholders.technical_owner
    stakeholders_approver             = local.product_information.stakeholders.approver
    stakeholders_creator              = local.product_information.stakeholders.creator
    stakeholders_team                 = local.product_information.stakeholders.team
    stakeholders_deployer_iam_account = data.aws_caller_identity.current_iam.account_id
  }
}

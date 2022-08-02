locals {
  product_information = {
    context : {
      project    = "marc-gavanier"
      layer      = "infrastructure"
      service    = "admin"
      start_date = "2022-08-02"
      end_date   = "unknown"
    }
    purpose : {
      disaster_recovery = "medium"
      service_class     = "bronze"
    }
    organization : {
      client = "personal-project"
    }
    stakeholders : {
      business_owner  = "marc.gavanier@gmail.com"
      technical_owner = "marc.gavanier@gmail.com"
      approver        = "marc.gavanier@gmail.com"
      creator         = "terraform"
      team            = "marc.gavanier"
    }
  }
}

locals {
  projectTitle = title(replace(local.product_information.context.project, "-", " "))
  layerTitle   = title(replace(local.product_information.context.layer, "-", " "))
  serviceTitle = title(replace(local.product_information.context.service, "-", " "))
}

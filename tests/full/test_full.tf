terraform {
  required_version = ">= 1.0.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = "=2.10.1"
    }
  }
}

module "main" {
  source = "../.."

  admin_state          = true
  response_threshold   = 8500
  top_slowest_requests = 5
  calculation_window   = 300
}

data "aci_rest_managed" "commApiRespTime" {
  dn = "uni/fabric/comm-default/apiResp"

  depends_on = [module.main]
}

resource "test_assertions" "commApiRespTime" {
  component = "commApiRespTime"

  equal "enableCalculation" {
    description = "enableCalculation"
    got         = data.aci_rest_managed.commApiRespTime.content.enableCalculation
    want        = "enabled"
  }

  equal "respTimeThreshold" {
    description = "respTimeThreshold"
    got         = data.aci_rest_managed.commApiRespTime.content.respTimeThreshold
    want        = "8500"
  }

  equal "topNRequests" {
    description = "topNRequests"
    got         = data.aci_rest_managed.commApiRespTime.content.topNRequests
    want        = "5"
  }
  equal "calcWindow" {
    description = "calcWindow"
    got         = data.aci_rest_managed.commApiRespTime.content.calcWindow
    want        = "300"
  }
}

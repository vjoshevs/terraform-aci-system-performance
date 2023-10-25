module "system_performance" {
  source  = "netascode/system_performance/aci"
  version = ">= 0.0.1"

  admin_state          = true
  response_threshold   = 8500
  top_slowest_requests = 5
  calculation_window   = 300
}
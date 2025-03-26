

variable "endpoint" {
  description = "A locator that corresponds to the subscription protocol - EMAIL, URL"
  type        = string

}

variable "protocol" {
  description = "The protocol used for the subscription. - CUSTOM HTTTPS, EMAIL, HTTPS, PAGERDUTY, ORACLE_FUNCTIONS, SLACK, SMS"
  type        = string

}


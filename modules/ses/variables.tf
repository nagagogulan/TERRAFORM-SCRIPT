variable "ses_domain" {
  description = "Domain Name"
  type        = string
}

variable "ses_zone_id" {
  description = "Zone Id Name"
  type        = string
}


variable "ses_email" {
  type        = list(string)
  description = "Email List"
}
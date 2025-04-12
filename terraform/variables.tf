variable "pm_api_url" { type = string }
variable "pm_user"    { type = string }
variable "pm_token_id"    { type = string }
variable "pm_password" {
  type = string
  sensitive = true
}
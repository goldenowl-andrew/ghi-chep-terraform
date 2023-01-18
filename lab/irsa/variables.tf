variable "tags" {
  type        = map(string)
  description = "Default tags attached to all resources."
}
variable "region" {
  type = string
  default = "us-west-2"
}
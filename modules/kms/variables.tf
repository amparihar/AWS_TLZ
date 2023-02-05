variable "multi_region" {
  type = bool
}

variable "cmk_alias_name" {
    type = string
    default = "Shared_CMK"
}

variable "cmk_description" {
  type = string
  default = "Shared CMK"
}
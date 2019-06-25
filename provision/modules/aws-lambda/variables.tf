variable "function_name" {
  type = "string"
}

variable "description" {
  type = "string"
}

variable "memory_size" {
  type = "string"
  default = 1024
}

variable "timeout" {
  type = "string"
  default = "3"
}

variable "runtime" {
  type = "string"
}

variable "handler" {
  type = "string"
}

variable "code_version" {
  type = "string"
}

variable "package_name" {
  type = "string"
  default = "Lambda-Deployment.zip"
}

variable "code_bucket" {
  type = "string"
}

variable "environment_variables" {
  type = "map"

  default = {
    "default_variable" = "default_value"
  }
}
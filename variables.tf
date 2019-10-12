variable "loc" {
  description = "Default Azure Region"
  default = "Southeastasia"
}

variable "tags" {
  default = {
      source = "citadel"
      env = "trainings"
  }
}


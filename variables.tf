variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-2"
}

provider "aws" { 
	access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}


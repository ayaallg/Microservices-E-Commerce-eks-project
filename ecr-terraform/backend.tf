terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }

  # Ce bloc doit impérativement rester vide {}. 
  # Jenkins injectera les valeurs (bucket, key, region) lors du "terraform init".
  backend "s3" {}

  required_version = ">= 1.6.3"
}

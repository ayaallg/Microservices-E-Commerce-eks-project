terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
environment {
    // Remplace par ton vrai bucket qui finit par 73c66080
    TF_BACKEND_BUCKET = "ml-terraform-state-73c66080" 
    TF_REGION         = "us-east-1"
    TERRAFORM_DIR     = "ecr-terraform"
}

  required_version = ">= 1.6.3"
}


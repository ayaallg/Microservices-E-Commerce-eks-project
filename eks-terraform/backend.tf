terraform {
  backend "s3" {
    bucket = "ml-terraform-state-73c66080"  # <--- REMPLACE ICI par ton ID
    key    = "k8/terraform.tfstate"
    region = "us-east-1"
  }
}

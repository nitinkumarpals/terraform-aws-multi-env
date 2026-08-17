terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-nitin-2026-aug"
    use_lockfile = true
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }
}

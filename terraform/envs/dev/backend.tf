terraform {
  backend "s3" {
    bucket         = "my-terraform-state-532150070616"   
    key            = "envs/dev/terraform.tfstate"       
    region         = "us-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}


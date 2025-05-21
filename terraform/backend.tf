terraform {
  backend "s3" {
    bucket         = "node-app-bucket-gaurav-2025"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"            
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-dungla-s3-backend"
    key            = "eks-demo/ecr.tfstate"
    region         = "us-west-2"
    encrypt        = true
    role_arn       = "arn:aws:iam::949715427887:role/Terraform-DunglaS3BackendRole"
    dynamodb_table = "terraform-dungla-s3-backend"
  }
}
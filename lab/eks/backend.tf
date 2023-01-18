/* terraform {
  backend "s3" {
    bucket         = <bucket-name>
    key            = <path>
    region         = <region>
    encrypt        = true
    role_arn       = <arn-role>
    dynamodb_table = <dynamodb-table-name>
  }
} */

terraform {
  backend "s3" {
    bucket         = "terraform-dungla-s3-backend"
    key            = "eks-demo/eks.tfstate"
    region         = "us-west-2"
    encrypt        = true
    role_arn       = "arn:aws:iam::949715427887:role/Terraform-DunglaS3BackendRole"
    dynamodb_table = "terraform-dungla-s3-backend"
  }
}
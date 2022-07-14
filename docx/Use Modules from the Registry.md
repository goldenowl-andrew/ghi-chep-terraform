# Prerequisites
- AWS account
- Terraform CLI

# Create Terraform configuration
- In this tutorial, you will use modules to create an example AWS environment using a Virtual Private Cloud (VPC) and two EC2 instances.
- Clone the GitHub repository.
```
git clone https://github.com/hashicorp/learn-terraform-modules-use.git
```
- Change into the directory in your terminal
```
cd learn-terraform-modules-use
```
- Open `main.tf` and find the following configuration.
```
# Terraform configuration

provider "aws" {
  region = "us-west-2"
  access_key                  = "anaccesskey"
  secret_key                  = "asecretkey"
  
  default_tags {
    tags = {
      hashicorp-learn = "module-use"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"
  count   = 2

  name = "my-ec2-cluster"

  ami                    = "ami-0c5204531f799e0c6"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

```
- Set values for module input variables
  - Để sử dụng module, bạn cần pass input variables cho module configuration. Phần cấu hình mà call tới module sẽ chịu trách nhiệm cho việc setting input variable, các giá trị này sẽ pass argument vào trong module block. 
  - Ngoài `source` và `version`, hầu hết các đối số cho module block sẽ set variable values.
  - On the Terraform registry page for the AWS VPC module, you will see an Inputs tab that describes all of the input variables that module supports.
  - Some input variables are required, meaning that the module doesn't provide a default value — an explicit value must be provided in order for Terraform to run correctly.
- Define root input variables
```
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "example-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```
- Provision infrastructure
```
#terraform init
```
# Understand how modules work
- Khi sử dụng một module mới cho lần đầu tiên, bạn cần phải run `terraform init` hoặc `terraform get` để install module. Khi một trong hai command này được run, Terraform sẽ install các module bên trong thư mục `.terrafrom/modules` trong thư mục làm việc của bạn. Với local module, terraform sẽ tạo symlink tới thư mục của module. Chính vì điều này, bất kỳ thay đôi nào với local module sẽ có ảnh hường ngay lập tức mà không cần run `terraform get`
- After following this tutorial, your .terraform/modules directory will look something like this:
```
.terraform/modules/
├── ec2_instances
├── modules.json
└── vpc
```
# Clean up your infrastructure
`terraform destroy`

# Tham khảo
- https://learn.hashicorp.com/tutorials/terraform/module-use?in=terraform/modules
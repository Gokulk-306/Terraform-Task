variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Path to your private key"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "sg_name" {
  type    = string
  default = "task_sg"
}

variable "ami_id_us_east_1" {
  description = "AMI ID for us-east-1 region"
  type        = string
}

variable "ami_id_us_east_2" {
  description = "AMI ID for us-east-2 region"
  type        = string
}

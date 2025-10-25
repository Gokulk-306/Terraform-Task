terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
}

data "aws_vpc" "default_us_east_1" {
  provider = aws.us-east-1
  default  = true
}

data "aws_vpc" "default_us_east_2" {
  provider = aws.us-east-2
  default  = true
}

data "aws_subnets" "us_east_1" {
  provider = aws.us-east-1
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_us_east_1.id]
  }
}

data "aws_subnets" "us_east_2" {
  provider = aws.us-east-2
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_us_east_2.id]
  }
}

resource "aws_security_group" "task_sg_us_east_1" {
  provider = aws.us-east-1
  name        = "task-sg-us-east-1"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default_us_east_1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "task_sg_us_east_2" {
  provider = aws.us-east-2
  name        = "task-sg-us-east-2"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default_us_east_2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in us-east-1
resource "aws_instance" "web_us_east_1" {
  provider                    = aws.us-east-1
  ami                         = var.ami_id_us_east_1
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.us_east_1.ids[0]
  vpc_security_group_ids      = [aws_security_group.task_sg_us_east_1.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              echo "<h1>Hello from US-East-1</h1>" | sudo tee /var/www/html/index.html
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "Web-Server-us-east-1"
    Env  = "Dev"
  }
}

# EC2 Instance in us-east-2
resource "aws_instance" "web_us_east_2" {
  provider                    = aws.us-east-2
  ami                         = var.ami_id_us_east_2
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.us_east_2.ids[0]
  vpc_security_group_ids      = [aws_security_group.task_sg_us_east_2.id]

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install nginx1 -y
            sudo systemctl enable nginx
            sudo systemctl start nginx
            echo "<h1>Hello from US-East-2</h1>" | sudo tee /usr/share/nginx/html/index.html
            EOF


  tags = {
    Name = "Web-Server-us-east-2"
    Env  = "Dev"
  }
}

output "web_us_east_1_public_ip" {
  value = aws_instance.web_us_east_1.public_ip
}

output "web_us_east_2_public_ip" {
  value = aws_instance.web_us_east_2.public_ip
}
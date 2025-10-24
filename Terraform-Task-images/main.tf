provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
}

resource "aws_instance" "us_east_1_instance" {
  provider      = aws.us-east-1
  ami           = "ami-0341d95f75f311023"
  instance_type = "t3.micro"
  tags = {
    Name = "EC2-US-EAST-1"
  }
}

resource "aws_instance" "us_east_2_instance" {
  provider      = aws.us-east-2
  ami           = "ami-0199d4b5b8b4fde0e"
  instance_type = "t3.micro"
  tags = {
    Name = "EC2-US-EAST-2"
  }
}
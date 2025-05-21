provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name
  force_destroy = true  

  tags = {
    Name        = "MyAppBucket"
    Environment = "dev"
  }
}


resource "aws_security_group" "gaurav_sg" {
  name        = "gaurav-sg"
  description = "Allow SSH and HTTPS inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "gaurav_instance" {
  ami           = "ami-0953476d60561c955"  
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.gaurav_sg.id]

  key_name = "gaurav-key" 

  tags = {
    Owner = "Gaurav Sharma"
  }
}

resource "aws_ecr_repository" "node_app" {
  name = "node-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "NodeAppRepo"
    Environment = "dev"
  }
}



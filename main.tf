terraform {
  backend "s3" {
    bucket = "eli-bucket-github"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
}
provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg_"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_sg"
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance_sg.name]

  tags = {
    Name = "MyDockerInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              echo "${var.docker_password}" | sudo docker login -u "${var.docker_username}" --password-stdin
              sudo docker run ${var.image_name}:${var.image_tag}
              EOF
    }

variable "image_name" {
  description = "The name of the Docker image"
  type        = string
  default     = "eliseror/new_repo"
}

variable "image_tag" {
  description = "The tag of the Docker image"
  type        = string
  default     = "githup_project"
}


variable "docker_username" {
  description = "Docker registry username"
  type        = string
}

variable "docker_password" {
  description = "Docker registry password"
  type        = string
  sensitive   = true
}



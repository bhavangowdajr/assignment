provider "aws" {
  region = "us-east-1" 
}

resource "aws_security_group" "allow_ports" {
  name = "allow_ports"
  vpc_id = module.module-1.movpc
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }   
}

resource "aws_instance" "instance" {
  ami = "ami-0b54e0dcc926ae5ce"
  instance_type = "t2.micro"
  key_name = "bhavan.pem"
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  user_data = <<-EOF
    #!/bin/bash
    yum install httpd -y
    EOF
  subnet_id = module.module-1.movpc
}

resource "aws_lb" "my_load_balancer" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_security_group.id]
  subnets            = module.module-1.movpc
}

resource "aws_db_instance" "my_database" {
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  allocated_storage = 10
  identifier        = "mydb-instance"
  username          = "admin"
  password          = "admin_password"
  publicly_accessible = false
  multi_az           = false

  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_group_name     = "mydb-subnet-group"
}

module "module-1" {
  source = "./Network_module/main.tf"
}

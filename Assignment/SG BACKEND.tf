resource "aws_security_group" "backend" {
  name        = "SG backend"
  description = "Allow HTTP backend"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                   #backend
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2 backend Security Group"
  }
} 

resource "aws_launch_configuration" "backend" {
  name_prefix = "backend-"

  image_id = "ami-02f3416038bdb17fb"              
  instance_type = "t2.micro"
  key_name = "AWS_RAPID"

  security_groups = [ aws_security_group.backend.id ]
  # associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "allow_http" {
  name        = "SG presentation"
  description = "Allow HTTP & ssh p"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 22
    to_port     = 22                               #presentation tier
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2 presenataion Security Group"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = "ami-02f3416038bdb17fb"              
  instance_type = "t2.micro"
  key_name = "AWS_RAPID"

  security_groups = [ aws_security_group.allow_http.id ]
  associate_public_ip_address = true

  user_data = "${file("data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

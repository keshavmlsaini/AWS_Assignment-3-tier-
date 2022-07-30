resource "aws_security_group" "rds-sg"  {
  name        = "SG DB"
  description = "MYSQL"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "DATABASE_SG"
  }
}

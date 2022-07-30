resource "aws_db_instance" "my_test_mysql" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.20"
  instance_class              = "db.t2.micro"
  db_name                     = "myrdstestmysql"
  username                    = var.username
  password                    = var.password
  db_subnet_group_name        = "${aws_db_subnet_group.test.name}"
  vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]
  publicly_accessible         = true
  skip_final_snapshot         = true
}

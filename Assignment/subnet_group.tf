resource "aws_db_subnet_group" "test" {
  name        = "db_subnet_group "
  description = "Private subnets for RDS instance"
  subnet_ids  = ["${aws_subnet.private_us_east_2b.id}", "${aws_subnet.private_us_east_2a.id}"]
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "MenuSelection"
  engine               = "maridb"
  engine_version       = "10.11.6"
  instance_class       = "db.m5.large"
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds-subnet
  vpc_security_group_ids = [aws_db_subnet_group.rds-subnet]

}



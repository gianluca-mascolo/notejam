resource "aws_db_instance" "default" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  multi_az             = false
  name                 = "notejam"
  username             = "notejamusr"
  password             = "12345test"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = false
  apply_immediately    = true
  vpc_security_group_ids = ["${aws_security_group.db_communication.id}"]
}

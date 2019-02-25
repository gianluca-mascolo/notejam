resource "aws_security_group" "http_in" {
  name        = "http_in"
  description = "Allow HTTP Traffic"
  vpc_id      = "vpc-57393d3c"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_communication" {
  name        = "db_communication"
  description = "Allow Traffic inside this sg"
  vpc_id      = "vpc-57393d3c"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

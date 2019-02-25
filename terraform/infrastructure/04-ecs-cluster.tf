resource "aws_ecs_cluster" "cluster" {
  name = "toptal-ecs-cluster"
}


data "aws_ami" "ecs-optimized-ami" {
  most_recent      = true
  owners = ["591542846629"]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

resource "aws_key_pair" "terraform-ec2-ssh-key" {
  key_name = "terraform-ec2-ssh-key"
  public_key = "${file("terraform-ec2-ssh-key.pub")}"
}
resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = "${data.aws_ami.ecs-optimized-ami.id}"
    instance_type               = "t2.micro"
    security_groups = ["${aws_security_group.http_in.id}","${aws_security_group.db_communication.id}"]
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"
    root_block_device {
      volume_type = "standard"
      volume_size = 25
      delete_on_termination = true
    }
    associate_public_ip_address = "true"
    key_name                    = "terraform-ec2-ssh-key"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} > /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg"
  availability_zones   = ["${aws_db_instance.default.availability_zone}"]
  vpc_zone_identifier  = ["subnet-0644a86c"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  depends_on = ["aws_launch_configuration.ecs-launch-configuration"]
}

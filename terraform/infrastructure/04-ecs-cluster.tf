resource "aws_ecs_cluster" "cluster" {
  name = "toptal-ecs-cluster"
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = "ami-07ba9ca2923346c0c"
    instance_type               = "t2.micro"
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"
    root_block_device {
      volume_type = "standard"
      volume_size = 25
      delete_on_termination = true
    }

    associate_public_ip_address = "true"
    key_name                    = "GianlucaKeypair"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} > /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg"
  availability_zones   = ["eu-central-1a"]
  vpc_zone_identifier  = ["subnet-0644a86c"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  /* @todo - variablize */
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
}

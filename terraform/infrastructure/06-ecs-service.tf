data "aws_ecs_task_definition" "notejam" {
  task_definition = "${aws_ecs_task_definition.notejam.family}"
}

resource "aws_ecs_service" "notejam" {
  name          = "notejam"
  cluster       = "${aws_ecs_cluster.cluster.id}"
  desired_count = 1
  launch_type = "EC2"
  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.notejam.family}:${max("${aws_ecs_task_definition.notejam.revision}", "${data.aws_ecs_task_definition.notejam.revision}")}"
}


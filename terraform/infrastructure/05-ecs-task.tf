resource "aws_ecs_task_definition" "notejam" {
  family = "toptal_notejam"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${aws_iam_service_linked_role.ecs.arn}"
  task_role_arn            = "${aws_iam_service_linked_role.ecs.arn}"
  container_definitions = "${file("container.json")}"
}

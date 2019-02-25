provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "aws-gmx"
}

resource "aws_ecr_repository" "notejam" {
  name = "notejam"
}

output "ECR" {
  value = "${aws_ecr_repository.notejam.repository_url}"
}

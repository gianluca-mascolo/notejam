provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "aws-gmx"
}

resource "aws_ecr_repository" "toptal_repo" {
  name = "toptal_repo"
}

output "ECR" {
  value = "${aws_ecr_repository.toptal_repo.repository_url}"
}

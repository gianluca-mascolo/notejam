#!/bin/bash

#terraform apply -auto-approve

source setup_env.sh
`aws ecr get-login --no-include-email`
DOCKER_REPOSITORY="$1"
DOCKER_TAG="$2"
docker tag notejam "notejam:${DOCKER_TAG}"
docker tag notejam "${DOCKER_REPOSITORY}:${DOCKER_TAG}"
docker push "${DOCKER_REPOSITORY}:${DOCKER_TAG}"

#!/bin/bash

deploy_backend() {
  echo "Finding release information..."
  RELEASE=$(curl -s https://api.github.com/repos/VinnieApps/photos/releases/latest)
  BACKEND_VERSION=$(echo $RELEASE | jq -r '.tag_name[1:]')

  TAG_NAME=$(echo $RELEASE | jq -r '.tag_name')
  TAG=$(curl -s https://api.github.com/repos/VinnieApps/photos/git/ref/tags/$TAG_NAME)
  GIT_SHA=$(echo $TAG | jq -r '.object.sha')

  JOBS_DOCKER_IMAGE=gcr.io/$GCP_PROJECT_ID/photos-jobs:$BACKEND_VERSION
  SERVICE_DOCKER_IMAGE=gcr.io/$GCP_PROJECT_ID/photos-service:$BACKEND_VERSION

  echo "------------- Backend ----------------------"
  echo "  Version is: $BACKEND_VERSION"
  echo "  Git Commit: $GIT_SHA"
  echo "  Jobs Docker image: $JOBS_DOCKER_IMAGE"
  echo "  Service Docker image: $SERVICE_DOCKER_IMAGE"
  echo "--------------------------------------------"

  sed s/GIT_SHA/$GIT_SHA/ templates/photos-job-deployment.yml \
    | sed "s|DOCKER_IMAGE|$JOBS_DOCKER_IMAGE|" \
    | kubectl apply -f -

  sed s/GIT_SHA/$GIT_SHA/ templates/photos-service-deployment.yml \
    | sed "s|DOCKER_IMAGE|$SERVICE_DOCKER_IMAGE|" \
    | kubectl apply -f -
}

main() {
  GCP_PROJECT_ID=$1
  kubectl apply -f 001-photos-http-proxy.yml

  deploy_backend
}

usage() {
    echo "Usage:"
    echo "   ./release.sh {GCP_PROJECT_ID}"
    echo
    echo "  GCP_PROJECT_ID      Google Cloud Project to release to."
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

main $1

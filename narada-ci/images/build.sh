#!/bin/sh

set -euo pipefail

REGISTRY="ghcr.io/dojimanetwork/helm_charts"

docker login -u "${CI_REGISTRY_USER}" -p "${CI_REGISTRY_PASSWORD}" "${CI_REGISTRY}"

find narada-ci/images/ -name version -printf '%h\n' | xargs basename -a | while read -r image; do
  version=$(cat "narada-ci/images/$image/version")

  # check to see if image version is already published
  if docker manifest inspect "$REGISTRY:${image}-${version}" > /dev/null 2>&1; then
    echo "Image ${image}:${version} already published."
  else
    echo "Building image $image:$version..."
    docker build -t "$REGISTRY:$image-$version" "narada-ci/images/$image"
    if [ "$CI_COMMIT_BRANCH" = "master" ]; then
      docker push "$REGISTRY:$image-$version"
    fi
  fi

done

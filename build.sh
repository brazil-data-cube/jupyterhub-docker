#!/bin/bash
#
# This file is part of BDC JupyterHub.
# Copyright (C) 2021 INPE.
#
# BDC JupyterHub is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -eou pipefail

#
# Build configurations
#
BUILD_MODE=""

#
# Image Tags
#
TAG_PREFIX="bdc"
TAG_VERSION="1.0.0"

PYTHON_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-pygeo:${TAG_VERSION}"

R_GEOSPATIAL_BASE1_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-rgeo-base1:${TAG_VERSION}"
R_GEOSPATIAL_BASE2_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-rgeo-base2:${TAG_VERSION}"
R_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-rgeo:${TAG_VERSION}"

SITS_BASE_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-sits-base:${TAG_VERSION}"
SITS_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-sits:${TAG_VERSION}"


#
# Build Geospatial Python image with all the package dependencies already installed
#
echo "Building Python Geospatial image..."

cd docker/pygeo

docker build ${BUILD_MODE} \
       -t ${PYTHON_GEOSPATIAL_IMAGE_TAG} \
       --file Dockerfile  .

cd ../../


#
# Build Geospatial R image with all the package dependencies already installed
#
echo "Building R Geospatial image..."
echo "\t=>base image 1..."

cd sits-docker/docker/ubuntu

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=jupyter/minimal-notebook:177037d09156 \
       -t ${R_GEOSPATIAL_BASE1_IMAGE_TAG} \
       --file Dockerfile .

echo "\t=>base image 2..."

cd ../R

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=${R_GEOSPATIAL_BASE1_IMAGE_TAG} \
       --build-arg SITS_TAG_VERSION=v0.9.8 \
       --build-arg SITS_ENVIRONMENT_TYPE=full \
       -t ${R_GEOSPATIAL_BASE2_IMAGE_TAG} \
       --file Dockerfile  .

cd ../../../docker/rgeo

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=${R_GEOSPATIAL_BASE2_IMAGE_TAG} \
       -t ${R_GEOSPATIAL_IMAGE_TAG} \
       --file Dockerfile  .


#
# Build SITS R image with all the package dependencies already installed
#
#cd ../sits
#
#docker build ${BUILD_MODE} \
#       --build-arg BASE_IMAGE=${R_GEOSPATIAL_IMAGE_TAG} \
#       -t ${SITS_BASE_IMAGE_TAG} \
#       --file Dockerfile  .
#
#cd ../../../docker/sits
#
#docker build ${BUILD_MODE} \
#       --build-arg BASE_IMAGE=${SITS_BASE_IMAGE_TAG} \
#       -t ${SITS_IMAGE_TAG} \
#       --file Dockerfile  .
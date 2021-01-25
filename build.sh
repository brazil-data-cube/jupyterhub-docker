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

ODC_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-odc:${TAG_VERSION}"
ODCSTATS_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-odc-stats:${TAG_VERSION}"

PYTHON_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-pygeo:${TAG_VERSION}"

R_GEOSPATIAL_BASE1_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-rgeo-base1:${TAG_VERSION}"
R_GEOSPATIAL_BASE2_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-rgeo-base2:${TAG_VERSION}"
R_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-rgeo:${TAG_VERSION}"

SITS_BASE_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-sits-base:${TAG_VERSION}"
SITS_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-sits:${TAG_VERSION}"

JUPYTERHUB_IMAGE_TAG="${TAG_PREFIX}/jupyterhub:${TAG_VERSION}"

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
       --build-arg BASE_IMAGE=jupyter/minimal-notebook \
       --build-arg ROOT_USER=root \
       --build-arg BASE_USER=jovyan \
       -t ${R_GEOSPATIAL_BASE1_IMAGE_TAG} \
       --file Dockerfile .

echo "\t=>base image 2..."

cd ../R

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=${R_GEOSPATIAL_BASE1_IMAGE_TAG} \
       --build-arg ROOT_USER=root \
       --build-arg BASE_USER=jovyan \
       --build-arg SITS_TAG_VERSION=v0.9.8 \
       --build-arg SITS_ENVIRONMENT_TYPE=full \
       -t ${R_GEOSPATIAL_BASE2_IMAGE_TAG} \
       --file Dockerfile  .

cd ../../../docker/rgeo

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=${R_GEOSPATIAL_BASE2_IMAGE_TAG} \
       -t ${R_GEOSPATIAL_IMAGE_TAG} \
       --file Dockerfile  .

cd ../../


#
# Build SITS R image with all the package dependencies already installed
#
echo "Building SITS image..."
echo "\t=>sits base image..."

cd sits-docker/docker/sits


docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=${R_GEOSPATIAL_BASE2_IMAGE_TAG} \
       -t ${SITS_BASE_IMAGE_TAG} \
       --file Dockerfile  .

echo "\t=>final image..."

cd ../../../docker/sits

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=${SITS_BASE_IMAGE_TAG} \
       -t ${SITS_IMAGE_TAG} \
       --file Dockerfile  .

cd ../../


#
# Build ODC image
#
echo "Building ODC image..."

# copy datacube-db config file
cp config/odc-datacube.conf-example odc-docker/docker/odc/.datacube.conf
cd odc-docker/docker/odc

docker build ${BUILD_MODE} \
             -t ${ODC_IMAGE_TAG} \
             --file Dockerfile .


#
# Build ODC-Stats image
#
echo "Building ODC-Stats image..."

cd ../odc-stats

docker build ${BUILD_MODE} \
             --build-arg BASE_IMAGE=${ODC_IMAGE_TAG} \
             -t ${ODCSTATS_IMAGE_TAG} \
             --file Dockerfile .

cd ../../

#
# Build JupyterHub Image
#
echo "Building JupyterHub image..."

cp config/jupyterhub-images.json docker/jupyterhub/images.json
cp config/jupyterhub-users.json docker/jupyterhub/users.json
cd docker/jupyterhub/

docker build ${BUILD_MODE} \
             --build-arg BASE_IMAGE=jupyterhub/jupyterhub:1.3.0 \
             -t ${JUPYTERHUB_IMAGE_TAG} \
             --file Dockerfile .

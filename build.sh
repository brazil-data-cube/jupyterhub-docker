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
# ODC: Allow jovyan to install o.s and conda packages
#
ODC_IMAGE_JOVYAN_AS_ROOT=0
ODC_IMAGE_USE_DEVELOPMENT_MODE=0

#
# Image Tags
#
TAG_PREFIX="bdc"
TAG_VERSION="1.0.0"

ODC_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-odc:${TAG_VERSION}"

PYTHON_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/jupyterhub-pygeo:${TAG_VERSION}"
PYTHON_GEOSPATIAL_SNAPPY_IMAGE_TAG="${TAG_PREFIX}/sentinel-toolboxes:${TAG_VERSION}"

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

cd ../

#
# Build Geospatial Python image with ESA snappy package library
#
echo "Building Python Geospatial image (with ESA snappy package)..."

cd sentinel-toolboxes/

docker build \
       --build-arg BASE_IMAGE=${PYTHON_GEOSPATIAL_IMAGE_TAG} \
       -t ${PYTHON_GEOSPATIAL_SNAPPY_IMAGE_TAG} \
       --file Dockerfile  .

cd ../../

#
# Build Geospatial R image with all the package dependencies already installed
#
echo "Building R Geospatial image..."
echo "\t=>base image 1..."

cd sits-docker/docker/ubuntu

docker build ${BUILD_MODE} \
       --build-arg BASE_IMAGE=jupyter/minimal-notebook@sha256:5c51e1d8b979afad8b95d231aea3da231cfd9e85884aeef89bf44dadb55369a3 \
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
cp config/datacube.conf odc-docker/docker/odc/.datacube.conf
cd odc-docker/docker/odc

docker build ${BUILD_MODE} \
             -t ${ODC_IMAGE_TAG} \
             --build-arg JOVYAN_AS_ROOT=${ODC_IMAGE_JOVYAN_AS_ROOT} \
             --build-arg BUILD_DEVELOPMENT_MODE=${ODC_IMAGE_USE_DEVELOPMENT_MODE} \
             --file Dockerfile .

cd ../../../

#
# Build JupyterHub Image
#
echo "Building JupyterHub image..."

cp config/images.json docker/jupyterhub/images.json
cp config/users.json docker/jupyterhub/users.json
cd docker/jupyterhub/

docker build ${BUILD_MODE} \
             --build-arg BASE_IMAGE=jupyterhub/jupyterhub:1.3.0 \
             -t ${JUPYTERHUB_IMAGE_TAG} \
             --file Dockerfile .

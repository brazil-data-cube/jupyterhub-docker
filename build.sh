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

PYTHON_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/pygeo:${TAG_VERSION}"
R_GEOSPATIAL_IMAGE_TAG="${TAG_PREFIX}/rgeo:${TAG_VERSION}"


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
#echo "Building R Geospatial image..."
#
#cd docker/rgeo
#
#docker build ${BUILD_MODE} \
#       -t ${R_GEOSPATIAL_IMAGE_TAG} \
#       --file Dockerfile  .
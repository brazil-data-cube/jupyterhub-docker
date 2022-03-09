# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

ARG BASE_IMAGE=jupyterhub/jupyterhub:1.4.2
FROM ${BASE_IMAGE}

RUN apt-get update -y \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip setuptools wheel \
    && pip install \
        dockerspawner==0.11.1 \
        oauthenticator==14.0.0 \
        jupyterhub-idle-culler \
        dynaconf==3.1.7 \
        git+https://github.com/brazil-data-cube/bdc-jupyterhub-oauth

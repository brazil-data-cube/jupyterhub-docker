# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

ARG BASE_IMAGE=jupyterhub/jupyterhub:1.4.2
FROM ${BASE_IMAGE}

RUN pip install --upgrade \
    pip setuptools wheel \
    && pip install \
        dockerspawner==0.11.1 \
        oauthenticator==0.12.3 \
        jupyterhub-idle-culler \
        dynaconf==3.1.7

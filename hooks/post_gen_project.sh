#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

echo ""
echo "Cookiecutter pos-processing..."
echo ""

# Base env config
mv config/jupyterhub/config-env .env

# Base users directory
mkdir users-home

# Looking for the NGINX usage
{% if cookiecutter.use_nginx == "no" %}
rm docker-compose.full.yml

rm -rf config/nginx
{% endif %}

echo "Done!"

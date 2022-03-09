#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

{% if cookiecutter.use_nginx == "no" %}
docker-compose -f docker-compose.yml up -d
{% else %}
docker-compose -f docker-compose.yml -f docker-compose.full.yml up -d
{% endif %}

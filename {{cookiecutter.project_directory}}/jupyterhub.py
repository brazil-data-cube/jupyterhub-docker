# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import sys
sys.path.append("/srv/jupyterhub/")

from dynaconf import Dynaconf

import buttler.auth as jupyter_oauth
from buttler.hooks import create_dir_hook
from buttler.services import idle_culler_service
from buttler.config import monkeypatch_jupyterhub_config


settings = Dynaconf(
    load_dotenv=True,  # read a .env file
    envvar_prefix="JUPYTERHUB",
    settings_files=["config/jupyterhub/settings.toml"],
)

#
# JupyterHub
#

# JupyterLab application entrypoint
c.Spawner.default_url = "/lab"

# JupyterLab Hub IP (Docker Network)
c.JupyterHub.hub_ip = settings.jupyterhub.hub_ip

# Base path
c.JupyterHub.base_url = settings.jupyterhub.base_url

# Bind
c.JupyterHub.bind_url = f"http://:8000{settings.jupyterhub.base_url}"


#
# JupyterHub Behavior
#
c.JupyterHub.shutdown_on_logout = True

#
# JupyterHub OAuth 2.0
#

# Client ID
c.Authenticator.client_id = settings.jupyterhub.oauth.client_id

# Client Secret
c.Authenticator.client_secret = settings.jupyterhub.oauth.client_secret

# OAuth callback
c.Authenticator.oauth_callback_url = settings.jupyterhub.oauth.oauth_callback_url

# OAuth Authenticator
{%- if cookiecutter.oauthenticator == "brazil-data-cube" %}
jupyter_oauth.configure_bdc_oauthenticator(c, settings)
{% else %}
jupyter_oauth.configure_google_oauthenticator(c, settings)
{% endif %}

#
# JupyterHub services
#
c.JupyterHub.services = [idle_culler_service()]

#
# CORS
#
c.NotebookApp.allow_origin = "*"

#
# User data persistence
#

# User data persistence base dir (Source - Local machine)
base_user_dir_source = settings.BASE_DIR_SOURCE

# User data persistence base dir (Target - Spawned Container)
base_user_dir_target = settings.BASE_DIR_TARGET

# User data persistence (Notebook directory into the Swapned Container)
c.DockerSpawner.notebook_dir = settings.jupyterhub.spawner.notebook_dir

#
# Docker Spawner
#
c.JupyterHub.spawner_class = "dockerspawner.DockerSpawner"

# Docker Network
c.DockerSpawner.network_name = settings.jupyterhub.spawner.docker_network_name

# Docker Images
c.DockerSpawner.image_whitelist = settings.jupyterhub.spawner.images

# Docker volumes
c.DockerSpawner.volumes = settings.jupyterhub.spawner.volumes

# Spawner Hook
c.Spawner.pre_spawn_hook = create_dir_hook(
    base_user_dir_source,
    base_user_dir_target,
)

#
# Server resource
#
monkeypatch_jupyterhub_config(c.Spawner, settings.jupyterhub.spawner.resources)

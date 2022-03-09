..
    This file is part of Brazil Data Cube Cookiecutter.
    Copyright (C) 2020 INPE.

    Brazil Data Cube Cookiecutter is free software; you can redistribute it and/or modify it
    under the terms of the MIT License; see LICENSE file for more details.


==========
JupyterHub
==========


.. image:: https://img.shields.io/badge/license-MIT-green
        :target: https://github.com//brazil-data-cube/jupyterhub-docker/blob/master/LICENSE
        :alt: Software License


.. image:: https://img.shields.io/badge/lifecycle-maturing-blue.svg
        :target: https://www.tidyverse.org/lifecycle/#maturing
        :alt: Software Life Cycle


.. image:: https://img.shields.io/github/tag/brazil-data-cube/jupyterhub-docker.svg
        :target: https://github.com/brazil-data-cube/jupyterhub-docker/releases
        :alt: Release


.. image:: https://img.shields.io/discord/689541907621085198?logo=discord&logoColor=ffffff&color=7389D8
        :target: https://discord.com/channels/689541907621085198#
        :alt: Join us at Discord


About
=====


This `Cookiecutter template <https://github.com/cookiecutter/cookiecutter>`_ is designed to help you to bootstrap a project to run a JupyterHub computational environment as a Docker container.


Using the Template
==================


**1.** Install the latest version of `Cookiecutter <https://cookiecutter.readthedocs.io/en/latest/installation.html>`_ if you haven't installed it yet::

    pip install cookiecutter


**2.** Open your terminal and go to the directory where you would like to create the the JupyterHub configuration files.


**3.** At the command line, run the ``cookiecutter`` command, passing in the link to this template::

    cookiecutter https://github.com/brazil-data-cube/jupyterhub-docker

    or,

    cookiecutter gh:brazil-data-cube/jupyterhub-docker


.. note::

    If you have used this template before, then you will be prompted to update your local copy of the template::

        You've downloaded /home/user-name/.cookiecutters/jupyterhub-docker before. Is it okay to delete and re-download it? [yes]:


    Just type 'yes' and confirm the update.


.. note::

    The ``jupyterhub-docker`` template will be cloned into ``~/.cookiecutters/`` (or an equivalent folder on Windows).


**4.** You will be prompted for some information regarding your new package:

- **project_name:**  a name for the JupyterHub computational environment project (example: ``bdc-jupyterhub``).

- **project_directory:** The name of the directory to store the project files (example: ``bdc-jupyterhub``).

- **oauthenticator:** The OAuth2 authenticator used to identify users.

- **use_nginx:** If selected, a Docker image fo NGINX will be included in the poject files.


Some of the information above can be filled with default values::

    project_name [bdc-jupyterhub]: sdc-jupyterhub
    project_directory [bdc-jupyterhub]: sdc-jupyterhub
    Select oauthenticator:
    1 - brazil-data-cube
    2 - google
    Choose from 1, 2 [1]:
    use_nginx [y]:


**5.** The project will be created under the folder indicated by the ``project_directory`` entry. In the above example, the ``sdc-jupyterhub`` directory will contain the following files and subfolders::

    buttler
    config
    docker
    docker-compose.yml
    .dockerignore
    .env
    jupyterhub.py
    run.sh
    users-home


Configuring the JupyterHub Environment
======================================


In the project folder, under the ``config/jupyterhub`` directory, you will locate a file named ``settings.toml``. You can edit it and provide your configuration. As an example, the example below shows how to fill the Google Authentication entries and set some host volumes that should be mounted in the spwaned containers::

    # -*- coding: utf-8 -*-
    #
    # Copyright (C) 2021 National Institute for Space Research.
    #
    # BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
    # under the terms of the MIT License; see LICENSE file for more details.

    [jupyterhub]
    #
    # Base JupyterHub configurations
    #

    hub_ip = "jupyterhub"
    base_url = "/jupyter"

    [jupyterhub.oauth]
    #
    # Base OAuth configuration.
    #

    client_id = ""
    client_secret = ""
    oauth_callback_url = ""


    [jupyterhub.oauth.google]
    #
    # Google OAuth client options
    #

    whitelist = ["user-1@mail.com"]
    admin_users = ["user-2@email.com", "user-3@mail.com"][jupyterhub.spawner]
    #
    # Docker spawner options.
    #

    notebook_dir = "/home/jovyan/work"
    docker_network_name = "bdc-net"

    [jupyterhub.spawner.volumes]
    #
    # Docker spawner data volumes.
    #

    # "./data" = { "bind" = "/data", "mode" = "rw" }
    # "./examples" = { "bind" = "/home/jovyan/work/examples", "mode" = "ro" }

    [jupyterhub.spawner.images]
    #
    # Docker spawner available images.
    #

    "Jupyter (Minimal Notebook)" = "jupyter/minimal-notebook:lab-3.2.8"
    "Jupyter (R Notebook)" = "jupyter/r-notebook:r-4.1.2"

    [jupyterhub.spawner.resources]
    #
    # Docker spawner resource options.
    #

    remove = true
    cpu_limit = 1
    mem_limit = "2G"


In the section ``jupyterhub.spawner.images`` you can inform all the Docker images that the JupyterHub should spawn.


Building and Running JupyterHub
===============================


The script ``run.sh`` can be used to build and run the JupyterHub container:

```shell
./run.sh
```

The above command will create an image:

```shell
docker image ls | grep jupyterhub
```

```
brazildatacube/jupyterhub    1.0.0       869f70880050   2 hours ago     2.3GB
```

**TODO**

# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.


def monkeypatch_jupyterhub_config(jupyterhub_config_obj, dynaconf_obj):
    """Configure the ``JupyterHub`` object.

    Patch the ``JupyterHub`` configuration object using
    the keys available in the ``Dynaconf`` object.

    Args:
        jupyterhub_config_obj: JupyterHub configuration object.

        dynaconf_obj: Dynaconf configuration object.
    """

    for key in dynaconf_obj.keys():
        setattr(jupyterhub_config_obj, key, dynaconf_obj.get(key))

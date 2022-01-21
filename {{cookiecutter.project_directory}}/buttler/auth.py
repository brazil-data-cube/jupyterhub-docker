# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

from oauthenticator.google import LocalGoogleOAuthenticator

from bdc_jupyterhub_oauth import BrazilDataCubeOAuthenticator


def configure_google_oauthenticator(jupyterhub_config_obj, dynaconf_obj):
    """Configure the Google OAuthenticator in the ``JupyterHub`` configuration object.

    Args:
        jupyterhub_config_obj: JupyterHub configuration object.

        dynaconf_obj: Dynaconf configuration object.
    """

    class NormalizedNameLocalGoogleOAuthenticator(LocalGoogleOAuthenticator):
        """Local Google OAuthenticator with name normalization."""

        def normalize_username(self, username):
            return username.replace("@", "_at_")

    # Configuring the JupyterHub OAuthenticator
    jupyterhub_config_obj.JupyterHub.authenticator_class = (
        NormalizedNameLocalGoogleOAuthenticator
    )

    # ACL
    jupyterhub_config_obj.LocalGoogleOAuthenticator.create_system_users = True

    # White/Admin user list
    jupyterhub_config_obj.Authenticator.whitelist = (
        dynaconf_obj.jupyterhub.oauth.google.whitelist
    )
    jupyterhub_config_obj.Authenticator.admin_users = (
        dynaconf_obj.jupyterhub.oauth.google.admin_users
    )

    jupyterhub_config_obj.Authenticator.add_user_cmd = [
        "adduser",
        "-q",
        "--gecos",
        '""',
        "--disabled-password",
        "--force-badname",
    ]


def configure_bdc_oauthenticator(jupyterhub_config_obj, dynaconf_obj):
    """Configure the Brazil Data Cube OAuthenticator in the ``JupyterHub`` configuration object.

    Args:
        jupyterhub_config_obj: JupyterHub configuration object.

        dynaconf_obj: Dynaconf configuration object.
    """

    jupyterhub_config_obj.JupyterHub.authenticator_class = BrazilDataCubeOAuthenticator

    # OAuth 2.0 application name
    jupyterhub_config_obj.BrazilDataCubeOAuthenticator.oauth_application_name = (
        dynaconf_obj.jupyterhub.oauth.oauth_application_name
    )

    # ACL
    jupyterhub_config_obj.BrazilDataCubeOAuthenticator.admin_roles = (
        dynaconf_obj.jupyterhub.oauth.bdc.admin_roles
    )
    jupyterhub_config_obj.BrazilDataCubeOAuthenticator.allowed_roles = (
        dynaconf_obj.jupyterhub.oauth.bdc.allowed_roles
    )
    jupyterhub_config_obj.BrazilDataCubeOAuthenticator.allowed_groups = (
        dynaconf_obj.jupyterhub.oauth.bdc.allowed_groups
    )

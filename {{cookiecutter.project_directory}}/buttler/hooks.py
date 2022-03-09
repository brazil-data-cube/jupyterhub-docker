# -*- coding: utf-8 -*-
#
# Copyright (C) 2021 National Institute for Space Research.
#
# BDC JupyterHub Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

import os
from pathlib import Path
from typing import Union


def create_dir_hook(
    base_user_dir_source: Union[str, Path], base_user_dir_target: Union[str, Path]
):
    """Hook function to create user directory.

    Args:
        base_user_dir_source (Union[str, Path]): User Directory in the local machine.

        base_user_dir_target (Union[str, Path]): User Directory in the Docker Container.

    Returns:
        Callable: Hook wrapper function.
    """

    base_user_dir_source = Path(base_user_dir_source)
    base_user_dir_target = Path(base_user_dir_target)

    def create_dir_hook_wrapper(spawner):
        username = spawner.user.name  # get the username

        # checking if the directory path already exists.
        volume_path = base_user_dir_target / username

        if not volume_path.exists():
            volume_path.mkdir(mode=0o755)

        # change volume permission
        os.chown(volume_path, 1000, 100)

        # create a new volume entry.
        spawner.volumes[str(base_user_dir_source / username)] = {
            "bind": "/home/jovyan/work"
        }

    return create_dir_hook_wrapper

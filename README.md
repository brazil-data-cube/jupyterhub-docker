# JupyterHub Docker Images

[![Software License](https://img.shields.io/badge/license-MIT-green)](https://github.com//brazil-data-cube/sits-docker/blob/master/LICENSE) [![Drone build status](https://drone.dpi.inpe.br/api/badges/brazil-data-cube/jupyterhub-docker/status.svg)](https://drone.dpi.inpe.br/api/badges/brazil-data-cube/jupyterhub-docker) [![Software Life
Cycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) [![Release](https://img.shields.io/github/tag/brazil-data-cube/jupyterhub-docker.svg)](https://github.com/brazil-data-cube/jupyterhub-docker/releases) [![Join us at
Discord](https://img.shields.io/discord/689541907621085198?logo=discord&logoColor=ffffff&color=7389D8)](https://discord.com/channels/689541907621085198#)

This is the official repository of Docker images for the JupyterHub support in Brazil Data Cube.


## Building the Docker Image

To build the images with the Dockerfiles contained in this repository, it is possible to use the `build.sh` utility script:

```shell
./build.sh
```

The above command will create the following images:

```shell
docker image ls | grep jupyterhub
```

```
bdc/jupyterhub-rgeo-base1             1.0.0       869f70880050   2 hours ago     2.3GB
```


### Running Containers

After the build of the images, they are ready to be used. Below is an example of the use of each of the defined images. Note that depending on the way the images were created, the commands below may undergo minor changes.


#### Python Geospatial

This command launches a container with JupyterLab prepared with several geospatial libraries for Python 3:

```shell
docker run --rm \
           --name my-jupyter-geospatial \
           --publish 127.0.0.1:8888:8888 \
           --env JUPYTER_ENABLE_LAB=yes \
           --volume ${PWD}/data:/data \
           --volume ${PWD}/scripts:/scripts \
           bdc/jupyterhub-pygeo:1.0.0
```

The terminal will present an output similar to:

```
Executing the command: jupyter lab
[I 13:22:42.923 LabApp] Writing notebook server cookie secret to ...
...
[I 13:22:43.561 LabApp]  or http://127.0.0.1:8888/?token=c572d8caa0761a68f75b9fe7efd98226bff236ae248938fa
[I 13:22:43.561 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
...
```

You can open the URL with the generated token in a web browser:

```shell
firefox http://127.0.0.1:8888/?token=c572d8caa0761a68f75b9fe7efd98226bff236ae248938fa
```

This will presents you with the JupyterLab user interface.

If you want to shutdown the JupyterLab, you can do it from the browser or in the terminal by pressing `CTRL+C`. Notice that we used the option ``--rm`` to create the container andthus it will be removed when the JupyterLab shutdowns. 
   

#### R Geospatial

This command launches a container with JupyterLab prepared with several geospatial libraries for R 4:

```shell
docker run --rm \
           --name my-jupyter-r \
           --publish 127.0.0.1:8888:8888 \
           --env JUPYTER_ENABLE_LAB=yes \
           --volume ${PWD}/data:/data \
           --volume ${PWD}/scripts:/scripts \
           bdc/jupyterhub-rgeo:1.0.0
```

The terminal will present an output similar to:

```
Executing the command: jupyter lab
[I 13:22:42.923 LabApp] Writing notebook server cookie secret to ...
...
[I 13:22:43.561 LabApp]  or http://127.0.0.1:8888/?token=c572d8caa0761a68f75b9fe7efd98226bff236ae248938fa
[I 13:22:43.561 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
...
```

You can open the URL with the generated token in a web browser:

```shell
firefox http://127.0.0.1:8888/?token=c572d8caa0761a68f75b9fe7efd98226bff236ae248938fa
```

This will presents you with the JupyterLab user interface.

If you want to shutdown the JupyterLab, you can do it from the browser or in the terminal by pressing `CTRL+C`. Notice that we used the option ``--rm`` to create the container andthus it will be removed when the JupyterLab shutdowns. 


## Tips

### Clone the Repository

```shell
git clone --recurse-submodules https://github.com/brazil-data-cube/jupyterhub-docker
```

### Update submodule

```shell
git submodule update --recursive --remote
```
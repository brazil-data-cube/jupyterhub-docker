ARG BASE_IMAGE=bdc/jupyterhub-rgeo-base2:1.0.0
FROM ${BASE_IMAGE}

RUN install2.r --error IRkernel

RUN echo "IRkernel::installspec(name = 'rgeo', displayname = 'R-Geo')" | R --no-save && chown -R $NB_UID:$NB_UID /home/jovyan/.local/

USER $NB_UID
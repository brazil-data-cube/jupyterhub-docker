ARG BASE_IMAGE=bdc/jupyterhub-sits-base:1.0.0
FROM ${BASE_IMAGE}

RUN install2.r --error IRkernel

RUN echo "IRkernel::installspec(name = 'sits', displayname = 'SITS')" | R --no-save && chown -R $NB_UID:$NB_UID /home/jovyan/.local/

USER $NB_UID
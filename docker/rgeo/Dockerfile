ARG BASE_IMAGE=bdc/jupyterhub-rgeo-base2:1.0.0
FROM ${BASE_IMAGE}

#
# Install ipyleaflet in base conda environment
#
RUN conda install --yes \
                  --channel conda-forge \
                  ipyleaflet


#
# Install JupyterLab extensions
#
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install jupyter-leaflet
RUN jupyter nbextension enable --py --sys-prefix ipyleaflet
RUN jupyter labextension install @jupyterlab/debugger
RUN jupyter labextension install @jupyterlab/geojson-extension
RUN jupyter labextension install @jupyterlab/vega3-extension
RUN jupyter labextension install @jupyterlab/mathjax3-extension
RUN jupyter labextension install @jupyterlab/github
RUN jupyter labextension install @jupyterlab/latex
RUN jupyter nbextension enable --py widgetsnbextension


#
# Install R as a Jupyter Kernel
#
RUN install2.r --error IRkernel

USER $NB_UID

RUN echo "IRkernel::installspec(name = 'rgeo', displayname = 'R-Geo')" | R --no-save

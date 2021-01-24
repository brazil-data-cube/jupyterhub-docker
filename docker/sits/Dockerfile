ARG BASE_IMAGE=bdc/jupyterhub-sits-base:1.0.0
FROM ${BASE_IMAGE}


#
# Install JupyterLab extensions
#
RUN conda install --yes ipyleaflet \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    && jupyter labextension install jupyter-leaflet \
    && jupyter nbextension enable --py --sys-prefix ipyleaflet \
    && jupyter labextension install @jupyterlab/debugger \
    && jupyter labextension install @jupyterlab/geojson-extension \
    && jupyter labextension install @jupyterlab/vega3-extension \
    && jupyter labextension install @jupyterlab/mathjax3-extension \
    && jupyter labextension install @jupyterlab/github \
    && jupyter labextension install @jupyterlab/latex \
    && jupyter nbextension enable --py widgetsnbextension


#
# Install R as a Jupyter Kernel
#
RUN install2.r --error IRkernel

USER $NB_UID

RUN echo "IRkernel::installspec(name = 'sits', displayname = 'SITS')" | R --no-save
FROM jupyter/datascience-notebook@sha256:ed6c44b7b513783e541e251fa057ced63e91887179c16ae5c535fe103c86c3f4

#
# Change user to root in order to add global packages
#
USER root


#
# Install ipyleaflet in base conda environment
#
RUN conda install --yes \
                  --channel conda-forge \
                  ipyleaflet


#
# Install JupyterLab extension in base conda environment
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
RUN jupyter labextension install @pyviz/jupyterlab_pyviz
RUN jupyter nbextension enable --py widgetsnbextension


#
# Create a new conda environment named geospatial to allow easy installation of
#
RUN conda create --name geospatial \
                 --yes \
                 --channel conda-forge \
                 python=3.7 \
                 bokeh \
                 cartopy \
                 dask descartes \
                 fiona \
                 gdal geopandas geoalchemy2 \
                 ipykernel ipyleaflet ipywidgets \
                 matplotlib mapclassify \
                 numpy \
                 pandas psycopg2 pygeos pyproj pysal \
                 rasterio rtree \
                 scipy seaborn shapely sqlalchemy \
                 xarray

RUN source activate geospatial \
     && python -m ipykernel install --name geospatial \
                                    --display-name "Python (Geospatial)"

# RUN source activate geospatial \
#     && conda install --yes \
#                      --channel pyviz \
#                      pyviz holoviz


#
# Change user to jovyan, upgrade pip and setuptools in
# base and geospatial environments.
# Install stac.py and wtss.py in geospatial environment.
#
USER $NB_UID

RUN pip3 install --upgrade pip \
    && pip3 install --upgrade setuptools

RUN source activate geospatial \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade setuptools \
    && pip3 install wtss stac.py
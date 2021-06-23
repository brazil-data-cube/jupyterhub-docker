ARG BASE_IMAGE
FROM ${BASE_IMAGE}


#
# Define SNAP version
#
ARG BDC_SNAP_VERSION=8


#
# Change user to root in order to add global packages
#
USER root


#
# Install some additional 
#
RUN source activate geospatial && \
    conda install --yes \
                  --channel conda-forge \
                  opencv \ 
                  scikit-image scikit-plot


#
# Install SNAP
#
#COPY esa-snap_all_unix_8_0.sh /tmp/
COPY response.varfile /tmp/
COPY install-snap.sh /tmp/

RUN cd /tmp/ && \
    source activate geospatial && \
    ./install-snap.sh && \
    rm install-snap.sh

RUN mkdir -p /home/$NB_USER/.snap/ \
	&& chown -R $NB_USER /home/$NB_USER/.snap/

#
# Change user to jovyan
#
USER $NB_UID

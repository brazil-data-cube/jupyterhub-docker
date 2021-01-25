ARG BASE_IMAGE=jupyterhub/jupyterhub:1.3.0
FROM ${BASE_IMAGE}

RUN pip install \
    dockerspawner==0.11.1 \
    oauthenticator==0.12.3 \
    jupyterhub-idle-culler

COPY users.json .
COPY images.json .
COPY jupyterhub_config.py .

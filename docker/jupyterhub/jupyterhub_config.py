# JupyterHub configuration
# based on: https://github.com/defeo/jupyterhub-docker
#           https://github.com/jupyterhub/jupyterhub-deploy-docker
import os
import sys

## Authenticator
# https://oauthenticator.readthedocs.io/en/latest/getting-started.html#gitlab-setup
# http://tljh.jupyter.org/en/latest/howto/auth/google.html
from oauthenticator.google import LocalGoogleOAuthenticator

# Create a new oauthenticator just to normalize the username
class BDCLocalGoogleOAuthenticator(LocalGoogleOAuthenticator):
    def normalize_username(self, username):
        return username.replace("@", "_at_")


def create_dir_hook(spawner):
    username = spawner.user.name  # get the username
    volume_path = os.path.join(users_base_dir_target, username)
    if not os.path.exists(volume_path):
        os.mkdir(volume_path, 0o755)
    os.chown(volume_path, 1000, 100)
    spawner.volumes[os.path.join(users_base_dir_source, username)] = { "bind": '/home/jovyan/work'}


def read_json(definition_file):
    import json
    with open(definition_file, 'r') as f:
        return json.load(f)

# CORS
c.NotebookApp.allow_origin = '*'
c.JupyterHub.authenticator_class = BDCLocalGoogleOAuthenticator

c.LocalGoogleOAuthenticator.client_id = os.environ['GOOGLE_CLIENTID']
c.LocalGoogleOAuthenticator.client_secret = os.environ['GOOGLE_CLIENT_SECRET']
c.LocalGoogleOAuthenticator.oauth_callback_url = os.environ['GOOGLE_OAUTH_CALLBACK_URL']

## Docker spawner
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.DockerSpawner.network_name = os.environ['DOCKER_NETWORK_NAME']
c.DockerSpawner.allowed_images = read_json("images.json")

# See https://github.com/jupyterhub/dockerspawner/blob/master/examples/oauth/jupyterhub_config.py
c.JupyterHub.hub_ip = os.environ['HUB_IP']

# Enable jupyterlab
## See: https://jupyterhub.readthedocs.io/en/stable/api/spawner.html#jupyterhub.spawner.Spawner.default_url
c.Spawner.default_url = '/lab'

## user data persistence
## see https://github.com/jupyterhub/dockerspawner#data-persistence-and-dockerspawner
notebook_dir = os.environ.get('DOCKER_NOTEBOOK_DIR') or '/home/jovyan'
users_base_dir_source = os.environ.get('USERS_BASE_DIR_SOURCE')
users_base_dir_target = os.environ.get('USERS_BASE_DIR_TARGET')

c.DockerSpawner.notebook_dir = notebook_dir

data_source= os.environ.get('DATA_SOURCE')
data_target= os.environ.get('DATA_TARGET')
examples_source= os.environ.get('EXAMPLES_SOURCE')
examples_target= os.environ.get('EXAMPLES_TARGET')

c.DockerSpawner.volumes = {
    examples_source : {"bind": examples_target, "mode": "ro"},
    data_source: {"bind": data_target, "mode": "ro"}
}

# attach the hook function to the spawner
c.Spawner.pre_spawn_hook = create_dir_hook

# Server usage and governance
c.Spawner.remove = True
c.Spawner.cpu_limit = 1
c.Spawner.mem_limit = '2G'

# Services
c.JupyterHub.services = [
    {
        'name': 'idle-culler',
        'admin': True,
        'command': [
            sys.executable,
            '-m', 'jupyterhub_idle_culler',
            '--timeout=3600'
        ],
    },
]

# ACL
c.LocalGoogleOAuthenticator.create_system_users = True

## Reading user's definition file
users_definition_file = read_json('/srv/jupyterhub/users.json')

c.Authenticator.admin_users = set(users_definition_file['adminlist'])
c.Authenticator.whitelist = set(users_definition_file['whitelist'])

c.Authenticator.add_user_cmd = ['adduser', '-q', '--gecos', '""', '--disabled-password', '--force-badname']

# URL config
baseurl = os.environ.get('BASE_URL')
c.JupyterHub.base_url=f"/{baseurl}"
c.JupyterHub.bind_url=f"http://:8000/{baseurl}"
c.JupyterHub.shutdown_on_logout = True

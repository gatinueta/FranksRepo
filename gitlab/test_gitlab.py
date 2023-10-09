import os
import getpass
import argparse

from lib.gitlab import *
from lib.settings import *
from lib import fetch_repositories_to_patch, get_access_token
from requests import HTTPError, JSONDecodeError


config = PatchingSettings()
access_token = get_access_token()
gitlab = GitLab(config, access_token)

oceanic_gitops_id = 1706
project = gitlab.get_request(f'/projects/{oceanic_gitops_id}')

print(f'emails_enabled: {project["emails_enabled"]}')

branches = gitlab.get_request(f'/projects/{oceanic_gitops_id}/repository/branches')

print(f"branches: {[ b['name'] for b in branches]}")

gitlab.delete_branch(project)

print(f"branches: {[ b['name'] for b in branches]}")

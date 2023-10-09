import requests
import json
from urllib.parse import quote, quote_plus
import os

class GitLabApi:
  def __init__(self) -> None:
    self.init('https://git.bsiag.com/api/v4/', os.getenv("GITLAB_ACCESS_TOKEN"))
 
  def init(self, gitlab_base_url: str, access_token: str) -> None:
    self.gitlab_base_url = gitlab_base_url
    self.access_token = access_token

  def get_request(self, request_path: str):
    r = self._do_request(path=request_path)
    r.raise_for_status()

    return r.json()

  def _do_request(self, request_type="GET", path="", **kwargs):
    url = self.gitlab_base_url + path
    headers = { "PRIVATE-TOKEN": self.access_token }
    return requests.request(request_type, url, headers=headers, **kwargs)

  def do_request(self, request_type="GET", path="", **kwargs):
    r = self._do_request(request_type, path, **kwargs)
    r.raise_for_status()

    return r.json()


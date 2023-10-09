from gitlab_api import GitLabApi
import json
from urllib.parse import quote_plus

api = GitLabApi()

group = 'devops/mpi-internal/gitops-project-repos'

branch = "features/fam/530_application_lifecycle_3_1_15"

for page in range(1,100):
    r = api.do_request(path=f'groups/{quote_plus(group)}/projects', params={ "include_subgroups": "true", "page": page})
    if len(r) == 0:
        break

    branches_paths = [ f"projects/{proj['id']}/repository/branches/{quote_plus(branch)}" for proj in r ]
    for p in branches_paths:
        b = api._do_request(path=p)
        if b.status_code == 200:
            print(json.dumps(b.json(), indent=4))
            print('del: ', api._do_request(request_type='DELETE', path=p))




from gitlab_api import GitLabApi
import json

api = GitLabApi()

r = api.do_request(path='merge_requests', params= { "reviewer_id": "1592", "state": "opened" })
labels = [ mr['labels'] for mr in r ]
print(json.dumps(r, indent=4))
print(json.dumps(labels, indent=4))

paths = [ f"projects/{mr['project_id']}/merge_requests/{mr['iid']}" for mr in r ]

print(json.dumps(paths, indent=4))

for path in paths:
	print(api._do_request(request_type='DELETE', path=path))


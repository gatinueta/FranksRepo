#!/bin/bash

# https://git.bsiag.com/devops/mpi-internal/gitops-project-repos

source ~/git/devops/tools/kpscript/devops.sh
source ~/git/devops/tools/kpscript/local.sh

gitlab_url=git.bsiag.com
access_token=$(kpscript_local_getPW adm-fam-gitlab-accesstoken)
group_name=devops%2Fmpi-internal
tl_group_name=devops%2Fmpi-internal%2Fgitops-project-repos
# group_name=2326

#echo good
#curl -s -H  "Authorization: Bearer $access_token" "https://$gitlab_url/api/v4/groups/4035/projects?per_page=100" | jq '[.[].ssh_url_to_repo][0]'
#echo bad
#curl -s -H  "Authorization: Bearer $access_token" "https://$gitlab_url/api/v4/groups/4035/projects?per_page=100" | jq '[.[].ssh_url_to_repo][1]'

for page in 1 2 3; do
	groups_page=$(
		curl -s -H  "Authorization: Bearer $access_token" "https://$gitlab_url/api/v4/groups/$tl_group_name/subgroups?page=$page&per_page=100" | jq -r '.[].full_path' 
	)
	groups="$groups $groups_page"
done

for group_name in $groups; do
	echo "# $group_name:"
        encoded_group_name=$(echo $group_name | sed -E 's/\//%2f/g') 
	url=$(curl -s -H  "Authorization: Bearer $access_token" "https://$gitlab_url/api/v4/groups/$encoded_group_name/projects?per_page=100" | jq '[.[].ssh_url_to_repo][0]')
	echo "git clone $url $group_name/inventories" 
done

#for page in $(seq 10); do
#	curl -s -H "Authorization: Bearer $access_token" "https://$gitlab_url/api/v4/groups/devops%2Fmpi-internal/subgroups?page=$page" | jq '.'
#done


#curl "https://$gitlab_url/api/v4/projects" | jq '.'

#curl -s -H "Authorization: Bearer $access_token" \
#     -H "Content-Type:application/json" \
#     -d '{ 
#          "query": "{ group(fullPath: \"'$group_name'\") { { projects {nodes { name description httpUrlToRepo nameWithNamespace starCount}}}}"
#      }' "https://$gitlab_url/api/graphql" | jq '.'


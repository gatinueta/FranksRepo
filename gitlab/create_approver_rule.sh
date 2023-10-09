curl -s --request POST  -H  "Authorization: Bearer $access_token" "https://$gitlab_url/api/v4/projects/1706/approval_rules"  --header 'Content-Type: application/json' --data '{"name": "4eyes", "rule_type": "any_approver", "approvals_required": 1}'


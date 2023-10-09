mkdir ~/inventory_patching
mkdir ~/inventory_patching/patch_log

cd ~/git/space/tools/patching

./get_devops_app_list.py > ~/inventory_patching/argocd_devops_apps.json

cd gitlab
vi patching_settings.yaml

export GITLAB_ACCESS_TOKEN=$(kpscript_local_getPW adm-fam-gitlab-accesstoken)

./manage-gitops.py --list -f ~/inventory_patching/argocd_devops_apps_oceanic_only.json  ~/inventory_patching/gitops-repos
./manage-gitops.py --disable-emails -f ~/inventory_patching/argocd_devops_apps_oceanic_only.json  ~/inventory_patching/gitops-repos
./setup-merge-requests.py -o ~/inventory_patching/patching-mrs.txt ~/inventory_patching/argocd_devops_apps_oceanic_only.json 
./manage-gitops.py --clone -f ~/inventory_patching/argocd_devops_apps_oceanic_only.json  ~/inventory_patching/gitops-repos
pushd ../../../inventory_generator
export ALL_VAULT_PW=$(kpscript_devops_getPW 28785F7179E4104CB0208D620435E075)
source env/bin/activate
./generate_inventory.py patch -i  ~/inventory_patching/gitops-repos/ -l ~/inventory_patching/patch_log/ --kubeconfig ~/.kube/config_se_prod
deactivate

popd
./manage-gitops.py --commit -f ~/inventory_patching/argocd_devops_apps_oceanic_only.json  ~/inventory_patching/gitops-repos
./manage-gitops.py --push -f ~/inventory_patching/argocd_devops_apps_oceanic_only.json  ~/inventory_patching/gitops-repos

GITLAB_ACCESS_TOKEN=$(kpscript_local_getPW fam-gitlab-accesstoken)

./review-merge-requests.py --approve
./review-merge-requests.py --merge

export GITLAB_ACCESS_TOKEN=$(kpscript_local_getPW adm-fam-gitlab-accesstoken)
./manage-gitops.py --enable-emails -f ~/inventory_patching/argocd_devops_apps_oceanic_only.json  ~/inventory_patching/gitops-repos


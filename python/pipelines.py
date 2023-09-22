from urllib.parse import quote
import yaml

pars_tmp = {
  'LIB_VAR_JOB_TYPE': 'appcontrol',
  'LIB_VAR_ENV': 'nightly',
  'LIB_VAR_LIBRARY_BRANCH': 'features/fam/argocd_terminate_op',
  'LIB_VAR_INCLUDED_APPLICATIONS': 'all',
  'LIB_VAR_APPCONTROL_MODE': 'start',
  'LIB_VAR_VERBOSE': 'true'
}

with open('pipelines.yaml', 'r') as file:
  pipelines = yaml.safe_load(file)

for name, pars in pipelines.items():
  prefix = 'https://git.bsiag.com/oceanic/oceaniccrm/-/pipelines/new?ref=oceanic%2Freleases%2F22.0&'
  parameter_list = [ f'var[{key}]={quote(str(value))}' for (key,value) in pars.items() ]
  parameters = '&'.join(parameter_list)

  url = f'{prefix}&{parameters}'
  print(f'{name}: {url}')


#!/usr/bin/python3
from urllib.parse import quote
import yaml
import os
import sys
import getopt

script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))

branch = 'oceanic/releases/22.0'

opts, args = getopt.getopt(sys.argv[1:],"b:")

print(opts)

for opt, arg in opts:
  if opt == '-b':
    branch = arg
    
with open(f'{script_directory}/pipelines.yaml', 'r') as file:
  pipelines = yaml.safe_load(file)

prefix = f'https://git.bsiag.com/oceanic/oceaniccrm/-/pipelines/new?ref={branch}'

for name, pars in pipelines.items():
  if not name.startswith('_'):
    parameter_list = [ f'var[{key}]={quote(str(value))}' for (key,value) in pars.items() ]
    parameters = '&'.join(parameter_list)

    url = f'{prefix}&{parameters}'
    print(f'{name}: {url}')


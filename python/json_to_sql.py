import json

jsontext = '''
[
	{
		"name": "God",
		"power": 27
	},
	{
		"name": "me",
		"lastname": "Ammeter",
		"power": 0
	},
	{
		"name": "you",
		"power": 1
	}
]
'''

def sqlvalue(a):
	if a is None:
		return 'null'
	if isinstance(a, str):
		return "'{}'".format(a)
	return str(a)

ATTRS = ['name', 'lastname', 'power']

objarr = json.loads(jsontext)

for obj in objarr:
	objattrs = [ sqlvalue(obj.get(a)) for a in ATTRS ]
	insertstr = 'insert into personnel ({}) values ({})'.format(
		', '.join(ATTRS), ', '.join(objattrs))
	print(insertstr)
	



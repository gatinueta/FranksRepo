import json

jsontext = '''
[
	{
		"name": "God",
		"power": 27
	},
	{
		"name": "me",
		"power": 0
	}
]
'''

obj = json.loads(jsontext)

print(obj)



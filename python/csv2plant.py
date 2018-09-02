import sys
import csv
import re

umlstart = '''
@startuml

[*] --> State1
State1 --> [*]
State1 : this is a string
State1 : this is another string

State1 -> State2
State2 --> [*]

@enduml
'''

lane = { 'TX': -1, 'UOW': 0, 'DAY': 1, 'DAY / UOW / TX' : 0 }
arrows = { -2 : '-doubleleft->', -1 : '-left->', 0 : '-down->', 1: '-right->', 2: '-doubleright->' }

print('@startuml')

states = []
desc = []
names = []
lanes = []
with open(sys.argv[1], 'r') as csvfile:
	spamreader = csv.reader(csvfile, delimiter='\t')
	for row in spamreader:
		col = row[2];
		name = '.'.join(row[0:3])
		id = re.sub('\W+', '_', name)
		states.append(id)
		names.append(name)
		desc.append(row[3]);
		lanes.append(lane[row[2]])
		
for i in range(1, len(states)):
	arrow = arrows[lanes[i]-lanes[i-1]]
	print ('{} {} {}'.format(states[i-1], arrow, states[i]))
	print ('{} : {}'.format(states[i-1], desc[i-1]))
	print ('state "{}" as {}'.format(names[i-1], states[i-1]))
print('@enduml')

	
	


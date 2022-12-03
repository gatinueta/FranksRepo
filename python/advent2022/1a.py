import fileinput

calories = 0
max = 0

for line in fileinput.input():
	line = line.strip()
	if line.isdigit():
		calories += int(line)
	else:
		print(calories)	
		if calories > max:
			max = calories
		calories = 0

print(calories)
if calories > max:
	max = calories

print(f'max = {max}')



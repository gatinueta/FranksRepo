import fileinput

calories = 0
l = []

for line in fileinput.input():
	line = line.strip()
	if line.isdigit():
		calories += int(line)
	else:
		l.append(calories)
		calories = 0

print(calories)
l.append(calories)

l.sort(reverse=True)

print(l[0] + l[1] + l[2])



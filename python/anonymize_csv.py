from faker import Faker
import csv
import sys

fake = Faker('de_AT')

print(fake.name())
print(fake.street_name())

filename = sys.argv[1]
tofilename = filename + '_anonymous.csv'

with open(filename, newline='') as infile, open(tofilename, 'w', newline='') as outfile:
    csvreader = csv.reader(infile, delimiter=';', quotechar='"')
    csvwriter = csv.writer(outfile, delimiter=';', quotechar='"')
    for row in csvreader:
    	csvwriter.writerow(row)
    



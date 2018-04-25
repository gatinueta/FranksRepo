import fileinput

filename = ''
filelineno = 0
for line in fileinput.input():
    if fileinput.filename() != filename:
        print("we were in file {} on line {}".format(filename, filelineno))
    (filename, filelineno) = fileinput.filename(), fileinput.filelineno()


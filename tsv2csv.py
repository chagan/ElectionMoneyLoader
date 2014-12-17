import csv, sys, argparse
from glob import glob

def convert_file():

	parser = argparse.ArgumentParser()
	parser.add_argument("-i", nargs='*')
	parser.add_argument("-o")
	args = parser.parse_args()

	if args.i:
		inputfile = args.i
	else:
		raise Exception("Must provide an infile")

	if args.o:
		outputfile = args.o

	# use 'with' if the program isn't going to immediately terminate
	# so you don't leave files open
	# the 'b' is necessary on Windows
	# it prevents \x1a, Ctrl-z, from ending the stream prematurely
	# and also stops Python converting to / from different line terminators
	# On other platforms, it has no effect

	for filename in inputfile:
		print "converting %s to csv" % filename
		in_txt = csv.reader(open(filename, "rb"), delimiter = '\t')
		out_csv = csv.writer(open(filename.split('.')[0] + ".csv", 'wb'))

		out_csv.writerows(in_txt)


if __name__ == "__main__":
    convert_file()
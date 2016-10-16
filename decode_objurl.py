#!/usr/bin/python

import sys

encoded_str1 = "_z2C$q"
encoded_str2 = "_z&e3B"
encoded_str3 = "AzdH3F"

HASHTABLE = {
	encoded_str1 : ":",
	encoded_str2 : ".",
	encoded_str3 : "/",
	"w" : "a",
	"k" : "b",
	"v" : "c",
	"1" : "d",
	"j" : "e",
	"u" : "f",
	"2" : "g",
	"i" : "h",
	"t" : "i",
	"3" : "j",
	"h" : "k",
	"s" : "l",
	"4" : "m",
	"g" : "n",
	"5" : "o",
	"r" : "p",
	"q" : "q",
	"6" : "r",
	"f" : "s",
	"p" : "t",
	"7" : "u",
	"e" : "v",
	"o" : "w",
	"8" : "1",
	"d" : "2",
	"n" : "3",
	"9" : "4",
	"c" : "5",
	"m" : "6",
	"0" : "7",
	"b" : "8",
	"l" : "9",
	"a" : "0",
}

def DecodeObjUrl(objURL):
	i = 0;
	decoded_url = "";
	while i < len(objURL):
		if (objURL[i] == "_" and
				objURL.find(encoded_str1, i, i + len(encoded_str1)) != -1):
			decoded_url += HASHTABLE[encoded_str1]
			i += len(encoded_str1)
		elif (objURL[i] == "_" and
					objURL.find(encoded_str2, i, i + len(encoded_str2)) != -1):
			decoded_url += HASHTABLE[encoded_str2]
			i += len(encoded_str2)
		elif (objURL[i] == "A" and
		 			objURL.find(encoded_str3, i, i + len(encoded_str3)) != -1):
			decoded_url += HASHTABLE[encoded_str3]
			i += len(encoded_str3)
		elif objURL[i] in HASHTABLE:
			decoded_url += HASHTABLE[objURL[i]]
			i += 1
		else:
			decoded_url += objURL[i]
			i += 1
	#	print "decoded_url = ", decoded_url
	return decoded_url

def ProcessRawObjUrlFile(in_f, out_f):
	with open(in_f, 'r') as infile:
		with open(out_f, 'w') as outfile:
			for objURL in infile:
				decoded_url = DecodeObjUrl(objURL)
				outfile.write(decoded_url);

if __name__ == '__main__':
	if len(sys.argv) != 3:
		print "Usage: ./decode.py <raw_objURL_file> <decoded_objURL_file>"
		sys.exit(1)
	infile = sys.argv[1]
	outfile = sys.argv[2]
	ProcessRawObjUrlFile(infile, outfile)

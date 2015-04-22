#!/usr/bin/python
#-*- coding=utf8 -*-

import sys
import subprocess
import re

if len( sys.argv ) != 3:
	print "Incorrect amount of parameters, eg. ./osiris_gen.py SMALL img_list_hq_orig.txt"
	exit()

regExp 	= {'ERROR':re.compile("Error|error|ERROR|SIGKILL"),
					 'WARNING':re.compile("Warning|warning|WARNING")}

configType		= sys.argv[1]
fileListName	= sys.argv[2]

processedFile = open( "./osiris.proc.list", "a" )
currentImage	= open( "osiris_current_img.txt", "r+" )
currentImage.truncate( )

imageList = open( fileListName, "r" )
print "Converting images in list: " + fileListName
for image in imageList.readlines( ):
	image = image.rstrip( "\n\0\r\t" )[25:]
	currentImage.seek(  0 )
	currentImage.write( image )
	
	if configType == "SMALL":
		cmd = ["./osiris", "/development/iris_qa/osiris.conf_sm"]
	elif configType == "LARGE": 
		cmd = ["./osiris", "/development/iris_qa/osiris.conf_lg"]
	else:
		cmd = ["./osiris", "/development/iris_qa/osiris.conf"]

	print str( image ) + " - " + str( configType ),
	
	ERROR					= ""
	osirisResult	= "SUCCESS"
	try:
		osirisOutput = subprocess.check_output(cmd, stderr=subprocess.STDOUT)
		for line in osirisOutput.split("\n"):
			if regExp['ERROR'].search( line ) is not None:
				ERROR = "\n\tERROR: " + str(line) + ERROR
				osirisResult = "FAILURE (REGULAR)"
			elif regExp['WARNING'].search( line ) is not None:
				ERROR = "\tWARNING: " + str(line) + ERROR
	except subprocess.CalledProcessError as e:
		osirisResult = "FAILURE (SEVERE)"

	processedFile.write(	str( image ) 			+ ";" + 
												str( configType ) + ";" + 
												str( osirisResult + "\n" )
											)
	currentImage.truncate( )
	print "- " + osirisResult

currentImage.close(  )
processedFile.close( )


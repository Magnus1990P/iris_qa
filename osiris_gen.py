#!/usr/bin/python
#-*- coding: utf8 -*-

import sys
import subprocess
import re

if len( sys.argv ) != 2:
	print "Incorrect amount of parameters, eg. ./osiris_gen.py img_list_hq_orig.txt"
	exit()

scriptPath = "/home/jollyjackson/Desktop/iris_qa/"
orgImgPath = "/home/jollyjackson/Development/iris_img_db/"

scriptPath = "/development/iris_qa/"
orgImgPath = "/development/iris_img_db/"

regExp 	= {'ERROR':re.compile("Segmentation|Error|error|ERROR|SIGKILL|cannot|Cannot|Can not|can not"),
					 'WARNING':re.compile("Warning|warning|WARNING")}

fileListName	= sys.argv[1]
configType		= "SMALL"
imageCounter	= 0
imageFails		= 0

processedFile = open( "./osiris.proc.list", "a" )
currentImage	= open( "./osiris_current_img.txt", "r+" )
currentImage.truncate( )

imageList = open( fileListName, "r" )
print "Converting images in list: " + fileListName

for image in imageList.readlines( ):
	imageCounter	= imageCounter + 1
	image = image.rstrip( "\n\0\r\t" )[len(orgImgPath):]
	currentImage.seek(  0 )
	currentImage.write( image )
	
	configNumber	= 0
	osirisResult	= ""
	ERROR					= ""
	
	while configNumber < 3 and osirisResult != "SUCCESS":
		osirisResult = "SUCCESS"
		if configNumber == 0:
			configType	= "NORMAL"
			cmd 				= ["./osiris", scriptPath + "osiris.dev.conf"]
		elif configNumber == 1:
			configType	= "SMALL"
			cmd 				= ["./osiris", scriptPath + "osiris.dev.conf_sm"]
		elif configNumber == 2:
			configType	= "LARGE"
			cmd 				= ["./osiris", scriptPath + "osiris.dev.conf_lg"]

		try:
			osirisOutput = subprocess.check_output(cmd, stderr=subprocess.STDOUT)
			for line in osirisOutput.split("\n"):
				if regExp['ERROR'].search( line ) is not None:
					osirisResult = "FAILED"
		except subprocess.CalledProcessError as e:
			osirisResult = "FAILED"
		
		configNumber = configNumber + 1; 

		
	if osirisResult == "FAILED":
		imageFails = imageFails + 1
	processedFile.write	(	str( image ) 			+ ";" + 
												str( configType ) + ";" + 
												str( osirisResult + "\n" )
											)
	currentImage.truncate( )
	print str(imageCounter) + "\t" + str(image) + " - " + str(configNumber) + "/" + str(configType) + " - " + osirisResult


######### LOOP STOPPED ########
currentImage.close(  )
processedFile.close( )

print
print
print "STATUS: " + str(imageCounter - imageFails)  + "/" +  str(imageCounter)
print
print


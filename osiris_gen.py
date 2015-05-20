#!/usr/bin/python
#-*- coding: utf8 -*-

import sys
import subprocess
import re
import os.path

if len( sys.argv ) != 2:
	print "Incorrect amount of parameters, eg. ./osiris_gen.py img_list_hq_orig.txt"
	exit()

scriptPath = "/home/jollyjackson/Desktop/iris_qa/"
orgImgPath = "/home/jollyjackson/Development/iris_img_db/"

scriptPath = "/development/iris_qa/"
orgImgPath = "/development/iris_img_db/"

regExp 	= {'ERROR':re.compile("Segmentation|fault|Error|error|ERROR|SIGKILL|" +
															"cannot|Cannot"),
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

## Loop through the image list
for image in imageList.readlines( ):
	osirisOutput 	= ""
	configNumber	= 0
	imageCounter	= imageCounter + 1
	image 				= image.rstrip( "\n\0\r\t" )[len(orgImgPath):]
	storedImage 	= "imgdb_processed/"+str(image[image.rfind("/")+1 : image.rfind(".")]) + "_para.txt"
	currentImage.seek(  0 )
	currentImage.write( image )

	osirisResult	= "FAIL"
	while configNumber < 3 and osirisResult == "FAIL":
		if configNumber == 0:
			cmd 				= ["./osiris", scriptPath + "osiris.dev.conf"]
		elif configNumber == 1:
			cmd 				= ["./osiris", scriptPath + "osiris.dev.conf_sm"]
		elif configNumber == 2:
			cmd 				= ["./osiris", scriptPath + "osiris.dev.conf_lg"]

		try:
			osirisOutput = subprocess.check_output(cmd, stderr=subprocess.STDOUT)
		except subprocess.CalledProcessError as e:
			osirisResult	= "FAIL"
		
		if regExp['ERROR'].search( osirisOutput ) is None:
			osirisResult = "SUCCESS"

		configNumber = configNumber + 1; 
	#LOOP END

	#Count fails
	if osirisResult == "FAIL":
		imageFails = imageFails + 1

	#Write result to file
	processedFile.write( str( image ) + "\n" )
	currentImage.truncate( )
	#print str(imageCounter) + "\t" + str(image) + " - " + str(configNumber) + "/" + str(configType) + " - " + osirisResult
	
	if imageCounter % 20 == 0:
		print "Fails: " + str(imageFails) + "/" + str(imageCounter)

######### LOOP STOPPED ########
currentImage.close(  )
processedFile.close( )

print
print
print "STATUS: " + str(imageCounter - imageFails)  + "/" +  str(imageCounter)
print
print


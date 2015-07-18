#!/usr/bin/python
#-*- coding: utf8 -*-
#Generates the image database file for lq and hq images
from 		os.path			import isfile
import 	sys

if len( sys.argv ) != 4:
	print "Incorrect amount of parameters, eg. ./gen_imgdb.py filelist base_dir output"
	exit()

FNAME	= sys.argv[1]										#Store filename to read from
BDIR	= sys.argv[2]										#Base dir to images
OUTPUT=	sys.argv[3]

DB		= 0;														#DB counter
CL		= 0;														#Current Length of read string

WF = open( OUTPUT, 'w' )	#Open write file
WF.seek( 0 )													#	Go to start of file
WF.truncate()													#	Delete its content
WF.write ( 'hq_img = [\n' );					#	Write start of file

RF = open( FNAME, 'r' )								#Open read file
IL = RF.read().split("\n")						#Read entire file into memory and split
RF.close()														#close file

for line in IL:												#For each line in image list file 
	if CL != len( line ) :							#If change in string length
		DB = DB + 1												#Increment DB counter
		if DB == 2:												#If changed to 2 LQ images is starting
			WF.write( '];\n\n' )						#	Write stop to previous list
			WF.write( 'lq_img = [\n' )			#	Start new listing
		CL = len( line )									#Update current string length

	if len( line ) == 0 and DB >= 2:		#If length = 0 (last line) and DB is 2 or
		WF.write( '];\n\n' )							#	more, finish the writing
	else:																#If not last line
																			#Create skeleton name
		SN = "imgdb_processed/" + line[ line.rfind('/')+1 : line.rfind('.')]
																			#Check if file exists
		if	isfile( SN+'_segm.bmp' ) 	is True and \
				isfile( SN+'_mask.bmp' ) 	is True and \
				isfile( SN+'_para.txt' ) 	is True and \
				isfile( BDIR+line ) 			is True:
			WF.write( "\t'" + str(line) + "';\n" )	#Write to file
		else:
			print "NOT FOUND: " + str(line)

WF.close()														#Close write file


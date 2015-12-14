%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Testing file for testing correct iteration of databases
%%		Takse the parameter of number of databses to be run
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja NISlab
%%	Last rev:			
%%	Comment:			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dbRunTest( num_dbs )
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%	FILENAME VARIABLES
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	NUMDB				= num_dbs;															%number of databases
	count				= 0; 																		%counter
	pathSkip		= [42,44,45];														%Const pathskip for paths
	endSkip			= [4,4,5];															%Extension skip
	dbBasePath  = '/development/dbIris/db_periocular/';	
	dbSavePath  = '/development/dbIris/img_processed/';
	extension   = [ '_segm.bmp'; 		...
	                '_mask.bmp'; 		...
	                '_para.txt';];
	imgDB;																							%Load imgDB.m

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Load databases of images
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	for j=1:1:NUMDB																%Go through databases
  	if j==1       												      %Set and select HQ database
  	  db = imgList_1;    												%High Quality Image Set
	    disp('GUC database');
		elseif j==2																	%Set and select LQ database
  	  db = imgList_2;      											%Low Quality Image Set
	    disp('Miche databse');										%
		elseif j==3
  	  db = imgList_3;      											%Low Quality Image Set
	    disp('UBIRIS databse');										%
		end																					%end database load
		SKIP	= pathSkip(j);												%Set std var to req skip
		EXT		= endSkip(j);
  
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  	%% Retrieve assessment data for images
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  	for fileIndex=1:1:size(db,1)                    	%For all in current set
    	count = count + 1;															%Counter
			disp( db(fileIndex, SKIP:end) );
		end
end 

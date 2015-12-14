%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Calculate the Collective average of the image database focus
%%		The result is outputted to the "focusList.mat" file which contains 
%%			the assessed focus for each image in the databse.
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja NISlab
%%	Last rev:			
%%	Comment:			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function collective_focus_average( num_dbs )
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%	FILENAME VARIABLES
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	NUMDB				= num_dbs;															%number of databases
	count				= 0; 																		%counter
  avg_focus   = 0;        									          %average focus
	pathSkip		= [42,44,45];														%Const pathskip for paths
	endSkip			= [4,4,5];															%Extension skip
	dbBasePath  = '/development/dbIris/db_periocular/';	
	dbSavePath  = '/development/dbIris/img_processed/';
	extension   = [ '_segm.bmp'; 		...
	                '_mask.bmp'; 		...
	                '_para.txt';];
  focusList   = zeros(0,2);														%Focus of each image
	imgDB;																							%Load imgDB.m
  

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Load databases of images
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  disp('STARTING FOCUS ASSESSMENT');
	for j=1:1:NUMDB															%Go through databases
  	if j==1       												     %Set and select HQ database
  	  db = imgList_1;    											%High Quality Image Set
	    disp('GUC database');
		elseif j==2																%Set and select LQ database
  	  db = imgList_2;      										%Low Quality Image Set
	    disp('Miche databse');									%
		elseif j==3
  	  db = imgList_3;      										%Low Quality Image Set
	    disp('UBIRIS databse');									%
		end																				%end database load
		
		SKIP	= pathSkip(j);											%Set std var to req skip
		EXT		= endSkip(j);												%Set std var to req skip
  
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the focus value of each image
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for fileIndex = 1:1:size(db,1)            		%For entries in database
      count		= count + 1;               					%increment counter
      fname 	= db( fileIndex, : );               %grab filename
     	mask		= strcat( dbSavePath, 							...
												fname( SKIP:end-EXT ),		...
												extension(2,:) 	); 				%get filename

      f   			= focus(fname, mask);			  		  %Perform focus assessment
      focusList = [focusList; f, 0];     	  			%append to the list

			disp( fname );															%Display info
      clear fname mask f;
    end                                       		%End of files in database
    disp('FINISHED DATABASE');
		clear	db;																			%
  end                                         		%End of database selection
  
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Calculate average and relative focuses
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  avg_focus 			= mean( focusList(:,1) );				%Calc the focus score
	focusList(:,2)	= focusList(:,1) ./ avg_focus;	%Calc focus assessment
  save focusList.mat focusList;                 	%Save matrix to file

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% CLEAR UP MEMORY
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  clear avg_focus, focusList;                     %clear up the memory
  disp('FINISHED FOCUS ASSESSMENT');

end

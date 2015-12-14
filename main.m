%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Main program file for iris_qa
%%		This Performs the Quality Assessment of the images in the databases
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja, NISlab
%%	Last rev:			
%%	Version:			
%%	Based on:			[PAPER INFORMATION]
%%	Paper:				[PAPER INFORMATION]
%%	Web address:	
%%	Comment:			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main( num_dbs )
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%	FILENAME VARIABLES
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	pathSkip		= [42,44,45];														%Const pathskip for paths
	endSkip			= [4,4,5];															%Extension skip
	dbBasePath  = '/development/dbIris/db_periocular/';	%Org image path
	dbSavePath  = '/development/dbIris/img_processed/';	%Processed image path
	extension   = [ '_segm.bmp'; 		...
	                '_mask.bmp'; 		...
	                '_para.txt';  ];										%Extensions

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%	VARIABLES
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	NUMDB				= num_dbs;										%number of databases
	count				= 0; 													%counter
	RED					=	[255, 0, 0];        			  %Grab the red color
	WHT					=	[255];            			   	%Dictate white color
	FOCUSLIST   = 0;    			               	%List of FOCUS assessment variables
	RESULT			= zeros(0,12);								%Result matrix
	imgDB;																		%Load imgDB.m

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Try to load the focus assessment or generate 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	try																						%If exists, load it
		disp('Loading focus Assessment data');			%Print
  	load( 'focusList.mat' );										%Load focus matrix
 	catch ERR                         						%IF not exists, generate it
   	disp('Load failed, running CFA-program');
   	collective_focus_average( NUMDB );					%Run focus assessment
   	disp('Data created');											
   	load( 'focusList.mat' );										%Load focus assessment list
 	end

	FOCUSLIST = focusList;												%Set global variable
	clear focusList;															%clear temporary value	
	disp('Loading successfull');									%Print message


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

			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%%	Generate filenames, and load noise & signal image
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	    oName = db( fileIndex, : );            						%Original filename
			disp(['#', num2str(count), ' - ', oName]);				%Print msg
    	sName = strcat(dbSavePath, oName(SKIP:end-EXT));	%Skeleton filename
  
			
	    fileNames = [ strcat( sName, extension(1,:) ); ... %Get filenames of
  	                strcat( sName, extension(2,:) ); ... %	processed images
    	              strcat( sName, extension(3,:) ); ];

	    imgNoise  = imread( fileNames(1,:) );              %Load noise mask
  	  imgSignal = imread( fileNames(2,:) );              %Load signal mask

			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Calculate the area of the iris image
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	    % params:   mask yielding the noise & mask yielding the noise-free iris
  	  % returns:  mask of the iris area, 
    	%           mask of the noisy pixel area,
    	%           mask of pixels considered noise free,
    	%           mask of pixels considered pupil,
    	%           mask of pixels making up iris and pupil
    	[ tIris, nIris, sIris, tPupil, tAll] = area( imgNoise, imgSignal ); 
    	clear imgNoise imgSignal                              			%clean up mem
		
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Calculate the motion blur assessment
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	% params:   entire eye mask, iris noise-free mask, org file name
    	% returns:  scaled motion blur amplitude, angle of motion blur
    	[Am, Amt]   = motion( tAll, sIris, oName );   
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Calculate the angular offset assessment and area
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	% params:   list of coordinates and the original filename
    	% returns:  iris ang. in degr., theta val. of iris ang., area of iris
    	%           pupil ang. in degr., theta val. of iris ang., area of pupil
    	[Ia, It, I_AREA, Pa, Pt, P_AREA] = borderBox( fileNames(3,:), oName );
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Collect the quality values
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	    Ab = -1;                                        %Iris pigmentation n/a.
 	   	Ao = nnz( nIris ) / nnz( tIris   );             %Occlusion assessment
  	  Ac = nnz( sIris   );                            %Iris Area assessment
    	Aa = Ia;                                        %Off-angle assessment
	    Ta = It;                                        %Off-angle assessment
  	  Ap = P_AREA / I_AREA;                           %Pupil dialation as
    	Af = FOCUSLIST(count, 2);                       %Focus assessment

  	  RESULT(count,:) = [j, fileIndex, count,		...		%Append to result matrix
												 Ac, Aa, Ta, Af, Am,  	...
												 Amt, Ab, Ap, -1];
    
 	   	disp( strcat( 'Success:  ', sName ) );					%Print information
			disp( RESULT( count, : ) );											%Print reasult
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Clean up the environment
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	clear fileNames sName oName 
    	clear imgNoise imgSignal
    	clear Ia It I_AREA Pa Pt P_AREA totIris 
    	clear irisNoise irisSignal Pupil Total
  	end																						%End current database
 		disp('Done with image database');

	end																							%End looping through databases
	disp('FINISHED PROCESSING');
	disp('SAVING RESULT MATRIX TO FILE');
	save results.mat RESULT;                 				%Save results to results.mat

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	%% Clean up the envioronment
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	clear RED extension fileIndex hq_img lq_img WHT

end	%End main

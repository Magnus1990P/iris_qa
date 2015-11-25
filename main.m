%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main program file for iris_qa
%%	This Performs the Quality Assessment of the images in the databases
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja NISlab
%%	Date:					XXXX
%%	Based on:			[PAPER INFORMATION]
%%	Paper:				[PAPER INFORMATION]
%%	Web address:	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%	FILENAME VARIABLES
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% dbBasePath  = '../iris_img_db/';  %Path to original images on laptop
                                   		%Path to original images on server
	dbBasePath  = '/home/jollyjackson/Desktop/image_db/iris_img_db/';
	dbSavePath  = 'imgdb_processed/';  	%Path to where the osiris has stored pics
	extension   = [ '_segm.bmp'; ...   	%Extensions to stored images
	                '_mask.bmp'; ...   	%
	                '_para.txt';];     	%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%	VARIABLES
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	OS_SIZE			=	 4;                   			%
	RED					=	[255, 0, 0];        			  %Grab the red color
	WHT					=	[255];            			   	%Dictate white color
	wStart      = 0;          			         	%wordOffset for database set
	FOCUSLIST   = 0;    			               	%List of FOCUS assessment variables
	count       = 0;		    	               	%counter variable
	RESULT      = zeros((size(hq_img,1)+size(lq_img,1)), 12); %
	image_database_srvr;               				%Image database


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Try to load the focus assessment or generate 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	try																						%If exists, load it
		disp('Loading focus Assessment data');
  	load( 'focusList.mat' );        
 	catch ERR                         						%IF not exists, generate it
   	disp('Loading failed, creating list from scratch');
   	collective_focus_average( hq_img,  lq_img, 		...
															dbBasePath, dbSavePath);
   	disp('data created');
   	load( 'focusList.mat' );
 	end

	FOCUSLIST = focusList;												%Set global variable
	clear focusList;															%clear temporary value	
	disp('Loading successfull');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Load databases of images
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	for j=1:1:2 												          %Go through databases
  	if j==1       												      %Set and select HQ database
  	  db = hq_img;    													%High Quality Image Set
    	wStart = 12;      												%Offset for file name
	    disp('HQ Image Database');
	  else                												%Set and select LQ database
  	  db = lq_img;      												%Low Quality Image Set
    	wStart = 53;     													%Offset for file name
	    disp('LQ Image Database');
		end																					%end database load
  
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  	%% Retrieve assessment data for images
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  	for fileIndex=1:1:size(db,1)                    	%For all in current set
    	count = count + 1;															%Counter
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%%	Generate filenames, and load noise & signal image
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	    fileName = db( fileIndex, : );            			%Grab full filename
  	  orgName  = strcat(dbBasePath, fileName ); 			%Grab org pic name
    	skelName = strcat(dbSavePath, 						...		%Get skeleton name
												fileName(wStart:end-4));
    
	    fileNames = [ strcat( skelName, extension(1,:) ); ... %Get proc. names
  	                strcat( skelName, extension(2,:) ); ...
    	              strcat( skelName, extension(3,:) ); ];

	    imgNoise  = imread( fileNames(1,:) );                 %Load noise mask
  	  imgSignal = imread( fileNames(2,:) );                 %Load signal mask

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
    	[Am, Amt]       = motion( tAll, sIris, orgName );   %
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Calculate the angular offset assessment and area
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	% params:   list of coordinates and the original filename
    	% returns:  iris ang. in degr., theta val. of iris ang., area of iris
    	%           pupil ang. in degr., theta val. of iris ang., area of pupil
    	[Ia, It, I_AREA, Pa, Pt, P_AREA] = borderBox( fileNames(3,:), orgName );
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Collect the quality values
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	   	Ao = nnz( nIris ) / nnz( tIris   );             %Occlusion assessment
  	  Ac = nnz( sIris   );                            %Iris Area assessment
    	Aa = Ia;                                        %Off-angle assessment
	    Ta = It;                                        %Off-angle assessment
  	  Ap = P_AREA / I_AREA;                           %Pupil dialation as
    	Af = FOCUSLIST(count, 3);                       %Focus assessment
    
	    Ab = -1;                                        %Iris pigmentation n/a.

  	  RESULT(count,:) = [j, fileIndex, count,		...		%Append to result matrix
												 Ac, Aa, Ta, Af, Am,  	...
												 Amt, Ab, Ap, -1];
    
 	   	disp( strcat( 'Success:  ', skelName ) );				%Print information
			RESULT( count, : )															%
    
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	%% Clean up the environment
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    	clear fileNames skelName orgName fileName 
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
	clear RED extension fileIndex hq_img lq_img OS_SIZE WHT

end	%End main


OS_SIZE     = 4;                   %
RED=[255, 0, 0];                   %Grab the red color
WHT=[255];                         %Dictate white color
image_database_srvr;               %Image database
% dbBasePath  = '../iris_img_db/';  %Path to original images on laptop
                                   %Path to original images on server
dbBasePath  = '/home/jollyjackson/Desktop/image_db/iris_img_db/';
dbSavePath  = 'imgdb_processed/';  %Path to where the osiris has stored photos
extension   = [ '_segm.bmp'; ...   %Extensions to stored images
                '_mask.bmp'; ...   %
                '_para.txt';];     %
wStart      = 0;                   %
FOCUSLIST   = 0;                   %
count       = 0;                   %
RESULT      = zeros( ( size(hq_img,1) + size(lq_img,1) ) , 12 ); %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Try to load the focus assessment or generate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 try
   'Loading focus Assessment data'
   load( 'focusList.mat' );        %If exist it is loaded
 catch ERR                         %IF it doesn't exist create and load it
   'Loading failed, creating list from scratch'
   collective_focus_average(hq_img, lq_img, dbBasePath, dbSavePath);
   'data created'
   load( 'focusList.mat' );
 end
 FOCUSLIST = focusList;
 clear focusList;
 'Loading successfull'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load databases of images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:2           %Go through databases
    
  if j==1             %Set and select HQ database
    db = hq_img;      %High Quality Image Set
    wStart = 12;      %Offset for file name
    'HQ Image Database'
    
  else                %Set and select LQ database
    db = lq_img;      %Low Quality Image Set
    wStart = 53;      %Offset for file name
    'LQ Image Database'
    
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Retrieve assessment data for images
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for fileIndex=1:1:size(db,1)                    %For all in current set
    count = count + 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fileName = db( fileIndex, : );                    %Grab filename
    
    orgName  = strcat(dbBasePath, fileName );             %Grab org. name
    skelName = strcat(dbSavePath, fileName(wStart:end-4));%get skel. name
    
    fileNames = [ strcat( skelName, extension(1,:) ); ... %Get proc. names
                  strcat( skelName, extension(2,:) ); ...
                  strcat( skelName, extension(3,:) ); ];

    imgNoise  = imread( fileNames(1,:) );                 %Load noise mask
    imgSignal = imread( fileNames(2,:) );                 %Load signal mask

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the area of the iris image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % params:   mask yielding the noise & mask yielding the noise-free iris
    % returns:  mask of the iris area, 
    %           mask of the noisy pixel area,
    %           mask of pixels considered noise free,
    %           mask of pixels considered pupil,
    %           mask of pixels making up iris and pupil
    [ tIris, nIris, sIris, tPupil, tAll] = area( imgNoise, imgSignal ); 
    clear imgNoise imgSignal                              %clean up mem
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the motion blur assessment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % params:   entire eye mask, iris noise-free mask, org file name
    % returns:  scaled motion blur amplitude, angle of motion blur
    [Am, Amt]       = motion( tAll, sIris, orgName );   %
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the angular offset assessment and area
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % params:   list of coordinates and the original filename
    % returns:  iris ang. in degr., theta val. of iris ang., area of iris
    %           pupil ang. in degr., theta val. of iris ang., area of pupil
    [Ia, It, I_AREA, Pa, Pt, P_AREA] = borderBox( fileNames(3,:), orgName );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%e%%%%%
    %% Collect the quality values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ao = nnz( nIris ) / nnz( tIris   );             %Occlusion assessment
    Ac = nnz( sIris   );                            %Iris Area assessment
    Aa = Ia;                                        %Off-angle assessment
    Ta = It;                                        %Off-angle assessment
    Ap = P_AREA / I_AREA;                           %Pupil dialation as
    Af = FOCUSLIST(count, 3);                       %Focus assessment
    
    Ab = -1;                                        %Iris pigmentation as.
                                                    %Store results in files
    RESULT(count,:) = [j, fileIndex, count, Ac, Aa, Ta, Af, Am, Amt, Ab, Ap, -1];
    
    strcat( 'Success:  ', skelName )
    RESULT(count,:)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Clean up the environment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear fileNames skelName orgName fileName 
    clear imgNoise imgSignal
    clear Ia It I_AREA Pa Pt P_AREA totIris 
    clear irisNoise irisSignal Pupil Total
    
  end
  'Done with image database'
 
end
'FINISHED PROCESSING'
'SAVING RESULT MATRIX TO FILE'
save results.mat RESULT;                 %Save matrix to file results.mat

clear RED extension fileIndex hq_img lq_img OS_SIZE WHT
'Done saving, exiting'


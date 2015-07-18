OS_SIZE = 4;                      %
RED=[255, 0, 0];                  %Grab the red color
WHT=[255];                        %Dictate white color
image_database_new;               %Image database
%dbBasePath  = '../iris_img_db/';  %Path to original images on laptop
                                  %Path to original images on server
dbBasePath  = '/home/jollyjackson/Desktop/image_db/iris_img_db/';
dbSavePath  = 'imgdb_processed/'; %Path to where the osiris has stored photos
extension   = [ '_segm.bmp'; ...  %Extensions to stored images
                '_mask.bmp'; ...  %
                '_para.txt';];    %
wStart      = 0;                  %
FOCUSLIST   = 0;                  %
count       = 0;                  %

RESULT      = zeros(1, 10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Try to load the focus assessment or generate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 try
   FOCUSLIST = load( 'focusList.mat' );  %If exist it is loaded
 catch ERR                           %IF it doesn't exist create and load it
   collective_focus_average(hq_img, lq_img, dbBasePath, dbSavePath);
   FOCUSLIST = load( 'focusList.mat' ); 
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load databases of images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:1           %For all image databases
  if j==1             %Set and select HQ database
    db = hq_img;      
    wStart = 12;      %Offset
    'HQ Image Database'
  else                %Set and select LQ database
    db = lq_img;      
    wStart = 53;      %Offset
    'LQ Image Database'
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Retrieve assessment data for images
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for fileIndex = 1:1:size(db,1) %For all in current set
    count = count + 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fileName = hq_img( fileIndex, : );                    %Grab filename
    
    orgName  = strcat( dbBasePath, fileName );            %Grab original name
    skelName = strcat( dbSavePath, fileName( 12:end-4 ) );%get skeleton name
    
    fileNames = [ strcat( skelName, extension(1,:) ); ... %Get processed names
                  strcat( skelName, extension(2,:) ); ...
                  strcat( skelName, extension(3,:) ); ];

    imgNoise  = imread( fileNames(1,:) );                 %Load noise mask
    imgSignal = imread( fileNames(2,:) );                 %Load signal mask

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the area of the iris image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % params:   mask yielding the noise and mask yielding the noise-free iris
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
    [Am, Amt]       = motion( tAll, sIris, orgName );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the angular offset assessment and area
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % params:   list of coordinates and the original filename
    % returns:  iris angle in degrees, theta value of iris angle, area of iris
    %           pupil angle in degrees, theta value of iris angle, area of pupil
    [Ia, It, I_AREA, Pa, Pt, P_AREA] = borderBox( fileNames(3,:), orgName );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%e%%%%%
    %% Collect the quality values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ao = nnz( nIris ) / nnz( tIris   );             %Occlusion assessment
    Ac = nnz( sIris   );                            %Iris Area assessment
    Aa = Ia;                                        %Off-angle assessment
    Ta = It;                                        %Off-angle assessment
    Ap = P_AREA / I_AREA;                           %Pupil dialation assessment
    Af = FOCUSLIST(count, 3);                       %Focus assessment
    
    Ab = -1;                                        %Iris pigmentation assessment

    RESULT(count,:) = [j, Ac, Aa, Ta, Af, Am, Amt, Ab, Ap];
    RESULT(count,:)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Clean up the environment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear fileNames skelName orgName fileName imgNoise imgSignal
    clear Ia It I_AREA Pa Pt P_AREA totIris irisNoise irisSignal Pupil Total
    
  end
  'Done with image database'
end
'FINISHED PROCESSING'
'SAVING RESULT MATRIX TO FILE'
save results.mat RESULT;                 %Save matrix to file results.mat

clear RED extension fileIndex hq_img lq_img OS_SIZE WHT
'Done saving, exiting'


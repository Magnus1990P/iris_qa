OS_SIZE = 4;                      %
RED=[255, 0, 0];                  %Grab the red color
WHT=[255];                        %Dictate white color
image_database_new;               %Image database
dbBasePath  = '../iris_img_db/';  %Path to original images
dbSavePath  = 'imgdb_processed/'; %Path to where the osiris has stored photos
extension   = [ '_segm.bmp'; ...  %Extensions to stored images
                '_mask.bmp'; ...  %
                '_para.txt';];    %
wStart      = 0;                  %
AVG_FOCUS   = 0;                  %
count       = 0;                  %

if AVG_FOCUS == 0
  AVG_FOCUS = collective_focus_average(hq_img, lq_img, dbBasePath, dbSavePath);
                                %MUST BE LOADED PRIOR TO INITIATING
  'Ahlo, Ahlo'
end

for j=1:1:2           %For all image databases
  if j==1             %Set and select HQ database
    db = hq_img;      
    wStart = 12;      %Offset
  else                %Set and select LQ database
    db = lq_img;      
    wStart = 53;      %Offset
  end
  
  for fileIndex = 1:1:OS_SIZE %size(db,1) %For all in current set
    fileName = hq_img( fileIndex, : );    %Grab filename
    
    orgName  = strcat( dbBasePath, fileName );  %Grab original name
    skelName = strcat( dbSavePath, fileName( 12:end-4 ) );  %get skeleton name
    
    fileNames = [ strcat( skelName, extension(1,:) ); ...   %Get processed names
                  strcat( skelName, extension(2,:) ); ...
                  strcat( skelName, extension(3,:) ); ];

    imgNoise  = imread( fileNames(1,:) );                   %Load noise mask
    imgSignal = imread( fileNames(2,:) );                   %Load signal mask

    [ tIris, nIris,   ...
      sIris, tPupil,  ...
      tAll]             = area( imgNoise, imgSignal );      %
    clear imgNoise imgSignal %CLEAN UP ENVIRONMENT, a copy is returned by area()

    %returns: irisAngle,  irisTheta,  iris area
    %         pupilAngle, pupilTheta, pupil area
    [Ia, It, I_AREA, Pa, Pt, P_AREA] = borderBox( fileNames(3,:), orgName );
    
    Ao = nnz( nIris ) / nnz( tIris   );   %Occlusion assessment
    Ac = nnz( sIris   );                  %Iris Area assessment
    Aa = Ia;                              %Off-angle assessment
    Ta = It;                              %Off-angle assessment
    Ap = P_AREA / I_AREA;                 %Pupil dialation assessment
    Af = focus(orgName, sIris)/AVG_FOCUS; %Focus assessment
    Am = -1;                              %Motion assessment
    Ab = -1;                              %Iris pigmentation assessment

    clear fileNames skelName orgName fileName imgNoise imgSignal
    clear Ia It I_AREA Pa Pt P_AREA totIris irisNoise irisSignal Pupil Total
  end
end

clear RED extension fileIndex hq_img lq_img OS_SIZE WHT

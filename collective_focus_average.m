OS_SIZE = 4;                      %
RED=[255, 0, 0];                  %Grab the red color
WHT=[255];                        %Dictate white color
image_database;                   %Image database
dbBasePath  = '../iris_img_db/';  %Path to original images
dbSavePath  = 'imgdb_processed/'; %Path to where the osiris has stored photos
wStart      = 0;                  %
Af          = 0;                  %
count       = 0;                  %

for j=1:1:2
  if j==1
    db = hq_img;
    wStart = 12;
  else
    db = lq_img;
    wStart = 53;
  end

  for fileIndex = 1:1:4%size(db,1)
      fileName  = db( fileIndex, : );
      orgName   = strcat( dbBasePath, fileName );
      skelName  = strcat( dbSavePath, fileName( wStart:end-4 ) );
      fileName  = strcat( skelName, '_mask.bmp' );
      
      imgSignal = imread( fileName );
      f         = focus(orgName, imgSignal);           %Focus assessment
      Af        = Af + f;
      count     = count + 1;
      
      clear fileNames skelName orgName fileName imgNoise imgSignal irisSignal
  end
end

Af = (Af/count);

clear RED extension fileIndex hq_img lq_img OS_SIZE WHT

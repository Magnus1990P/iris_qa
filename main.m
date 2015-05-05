
OS_SIZE = 4;
RED=[255, 0, 0];            %Grab the red color
WHT=[255];                  %Dictate white color
image_database;             %Image database

extension = ['_segm.bmp'; '_mask.bmp'; '_para.txt';];

for fileIndex = 4:1:4%size(hq_img,1)
  fileName = hq_img( fileIndex, : );
  orgName  = strcat( '../iris_img_db/', fileName );
  skelName = strcat('imgdb_processed/', fileName( 12:end-4 ) );
  fileNames = [ strcat( skelName, extension(1,:) ); ...
                strcat( skelName, extension(2,:) ); ...
                strcat( skelName, extension(3,:) ); ...
              ];
  
  imgNoise  = imread( fileNames(1,:) );
  imgSignal = imread( fileNames(2,:) );
  [total, noise, signal, pupil] = area( imgNoise, imgSignal );
  
  [a, b, P_AREA, I_AREA] = borderBox( fileNames(3,:) );
  %[a, b] 
  P_AREA
  I_AREA
end

function [avg_focus] = collective_focus_average()
  image_database;                   %Image database
  dbBasePath  = '../iris_img_db/';  %Path to original images
  dbSavePath  = 'imgdb_processed/'; %Path to where the osiris has stored photos
  wStart      = 0;                  %Start of filenames
  avg_focus   = 0;                  %average focus
  count       = 0;                  %Counter for number of images to divide by

  for j=1:1:2         %For each database HQ and LQ
    if j==1           %Start with HQ
      db = hq_img;
      wStart = 12;    %offset to start of filename
    else              %End with LQ
      db = lq_img;
      wStart = 53;    %Offset to start of filename
    end

    for fileIndex = 1:1:size(db,1)                    %For entries in database
        fileName  = db( fileIndex, : );               %grab filename
        orgName   = strcat( dbBasePath, fileName );   %prepend base path
        skelName  = strcat( dbSavePath, fileName( wStart:end-4 ) );%get filename
        fileName  = strcat( skelName, '_mask.bmp' );  %append fileending

        imgSignal = imread( fileName );               %Load the irisMask
        f         = focus(orgName, imgSignal);  %Perform focus assessment
        avg_focus = avg_focus + f;                    %Add to to focus
        count     = count + 1;                        %increment counter

        clear fileNames skelName orgName fileName imgNoise imgSignal irisSignal
    end                                               %End of files in database
  end                                                 %End of database selection
  avg_focus
  count
  avg_focus = avg_focus / count;                      %Calculate the focus score
  avg_focus
  
  clear hq_img lq_img
return

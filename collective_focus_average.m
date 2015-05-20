function [avg_focus] = collective_focus_average( hq, lq, bp, sp )
  wStart      = 0;                  %Start of filenames
  avg_focus   = 0;                  %average focus
  count       = 0;                  %Counter for number of images to divide by
  focusList   = zeros( size(hq,1)+size(lq,1), 3);
  
  for j=1:1:2         %For each database HQ and LQ
    if j==1           %Start with HQ
      db = hq;
      wStart = 12;    %offset to start of filename
    else              %End with LQ
      db = lq;
      wStart = 53;    %Offset to start of filename
    end

    for fileIndex = 1:1:3%size(db,1)              %For entries in database
        fn  = db( fileIndex, : );               %grab filename
        on  = strcat( bp, fn );                 %prepend base path
        sn  = strcat( sp, fn( wStart:end-4 ) ); %get filename
        fn  = strcat( sn, '_mask.bmp' );        %append fileending

        imgSignal = imread( fn );               %Load the irisMask
        [f, f2]   = focus(on, imgSignal);       %Perform focus assessment
        avg_focus = avg_focus + f;              %Add to to focus
        count     = count + 1;                  %increment counter
        
        focusList(count, 1:2) = [f, f2];        %Create the list
        
        clear fn sn on imgSignal f
    end                                               %End of files in database
  end                                                 %End of database selection
  
  avg_focus
  count
  avg_focus = avg_focus / count;                      %Calculate the focus score
  avg_focus
  
  
  save focusList.mat focusList ;
  
  clear hq lq bp sp count
return

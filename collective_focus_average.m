function collective_focus_average( hq, lq, bp, sp )
  wStart      = 0;                  %Start of filenames
  avg_focus   = 0;                  %average focus
  count       = 0;                  %Counter for number of images to divide by
  focusList   = zeros( size(hq,1) + size(lq,1), 3);
  
  for j=1:1:2         %For each database HQ and LQ
    
    if j==1           %Start with HQ
      db = hq;
      wStart = 12;    %offset to start of filename
    else              %End with LQ
      db = lq;
      wStart = 53;    %Offset to start of filename
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate the focus value of each image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for fileIndex = 1:1:size(db,1)              %For entries in database
        count     = count + 1;                  %increment counter
        fn  = db( fileIndex, : );               %grab filename
        on  = strcat( bp, fn );                 %prepend base path
        sn  = strcat( sp, fn( wStart:end-4 ) ); %get filename
        fn  = strcat( sn, '_mask.bmp' );        %append fileending

        imgSignal = imread( fn );               %Load the irisMask
        [f, f2]   = focus(on, imgSignal);       %Perform focus assessment
        [f, f2]
        focusList(count, 1:2) = [f, f2];        %append to the list
        
        clear fn sn on imgSignal f f2;          %Clear up the memory
    end                                         %End of files in database
  end                                           %End of database selection
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Calculate average and relative focuses
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  avg_focus = sum( focusList(:,1) ) / count;    %Calculate the focus score
  focusList(:,3) = focusList(:,1) ./ avg_focus; %Calculate focus assessment file
  save focusList.mat focusList;                 %Save matrix to file
  
  clear hq lq bp sp count                       %clear up the memory
return

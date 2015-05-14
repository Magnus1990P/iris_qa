function [totIris, irisNoise, irisSignal, Pupil, Total] = area(imgNoise, imgSignal)
  RED   = [255,0,0];
  WHT   = [255];
  CTRL  = 0;
    
    %Generate background images of X,Y size
  nsMask = true(  size(imgNoise,1), size(imgNoise,2) ); %Noisy pixels
  imPup  = false( size(imgNoise,1), size(imgNoise,2) ); %Pupil pixels
  imTot  = false( size(imgNoise,1), size(imgNoise,2) ); %Total iris area pixels
  
    %Generate noise mask by binarising the RED areas of the image to 1
  for i=1:3
    nsMask = and(nsMask, imgNoise(:,:,i)==RED(i) );    %Bin noise img
  end;
  
    %Total area of the iris, except the pupil
    %OR the noise and signal img
  imTot  = or(    nsMask, imgSignal(:,:,1)==WHT );
  
        %Calulate area of the pupil
  for i=1:1:size(imTot,1)
    if nnz( imTot( i, :) ) > 1          %Check if row contains more than 1 pixel
      for j=1:1:size(imTot,2)           %For each pixel in row
        if  CTRL==0             &&  ... %if not found any white pixel (0)
            imTot(i,j) == 1             % and current pixel is white
          CTRL = 1;                     %set ctrl to 1
        elseif  CTRL>=1         && ...  %If control is 1 or more 
                imTot(i,j) == 0 && ...  % and current pixel is blatck
                nnz(imTot(i,j:size(imTot,2))) ~= 0  %and still white pixels left
          imPup(i,j) = WHT;             %set pixel to white in the new picture
          CTRL = 2;                     %set state to 2
        elseif CTRL==2          && ...  %if state is 2 and ther is 0 or more
                nnz(imTot(i,j:size(imTot,2))) >= 0%white pixels left
          CTRL = 0;                     %reset stats
        end
      end
      CTRL = 0;                         %Reset state variable to 0
    end                                 %
  end                                   %End of for each row

  totIris    = imTot;     %%Tot num of pixels in the iris, W/O the pupil
  irisNoise  = nsMask;    %%Num of iris pixels considered noise
  irisSignal = imgSignal; %%Num of iris pixels considered noise-free
  Pupil      = imPup;     %%Num of pupil pixels
  Total      = or( totIris, Pupil );     %%Absolute max num of pixels
  
  clear imgNoise RED WHT CTRL start
end

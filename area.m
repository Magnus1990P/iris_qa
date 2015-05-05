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
    if nnz( imTot( i, :) ) > 1
      for j=1:1:size(imTot,2)
        if CTRL==0     &&  imTot(i,j) == 1
          CTRL = 1;
        elseif CTRL>=1 && imTot(i,j) == 0 && nnz(imTot(i,j:size(imTot,2))) ~= 0
          imPup(i,j) = WHT;
          CTRL = 2;
        elseif CTRL==2 && nnz(imTot(i,j:size(imTot,2))) >= 0
          CTRL = 0;
        end
      end
      CTRL = 0;
    end
  end
  
%  figure; imshow( imTotal );    title( 'IRIS + PUPIL' );
%  figure; imshow( imPup );      title( 'PUPIL AREA' );
%  figure; imshow( imTot );      title( 'IRIS AREA' );
%  figure; imshow( nsMask );     title( 'NOISY IRIS AREA' );
%  figure; imshow( imgSignal );  title( 'NOISE FREE IRIS AREA'  );

  totIris    = imTot;     %%Tot num of pixels in the iris, W/O the pupil
  irisNoise  = nsMask;    %%Num of iris pixels considered noise
  irisSignal = imgSignal; %%Num of iris pixels considered noise-free
  Pupil      = imPup;     %%Num of pupil pixels
  Total      = or( totIris, Pupil );     %%Absolute max num of pixels
  
  clear imgNoise RED WHT CTRL start
end

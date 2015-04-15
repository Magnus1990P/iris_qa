function [total, noise, signal, pupil] = area(imgNoise, imgSignal)

  RED = [255,0,0];
  WHT = [255];

  nsMask    = true(size(imgNoise,1), size(imgNoise,2)); %Noise img
  for i=1:3
    nsMask  = and(nsMask, imgNoise(:,:,i)==RED(i) );    %Bin noise img
  end;
  
  imTot  = false( size(imgNoise,1), ...    %Total area
                  size(imgNoise,2));
  imTot  = or( nsMask,           ...       %Total area of iris - pupil
               imgSignal(:,:,1)==WHT );
  
  total  = nnz( imTot     );
  noise  = nnz( nsMask    );
  signal = nnz( imgSignal );
  
  start = 0;
  pupil = 0;
  for i=1:1:size(imTot,1)
      
    if nnz( imTot( i, :) ) > 1
      
      for j=1:1:size(imTot,2)
        
        if start==0      &&  imTot(i,j) == 1
          start = 1;
        elseif start==1  &&  imTot(i,j) == 0
          pupil = pupil + 1;
          start = 2;
        elseif start==2  &&  imTot(i,j) == 1
          start = 0;
        end
        
      end
      
    end
    
  end
  
  imshow( imgSignal )
  imshow( nsMask )
  %imshow( imTot )
  
  clear imTot nsMask imgSignal RED WHT imgNoise
  
end
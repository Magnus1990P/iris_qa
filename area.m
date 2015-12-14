%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Feature for main.m
%%	This calculates the different areas to be used for assessment
%%		totIris:		The total number of pixels in the iris
%%		irisNoise:	Number of pixels in the iris, considered noise
%%		irisSignal:	Number of pixels in the iris, considered noise-free
%%		Pupil:			Number of pixels in the pupil
%%		Total:			The maximum number of pixels
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja NISlab
%%	Last rev:			
%%	Comment:			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [totIris, irisNoise, irisSignal, Pupil, Total] = area(imgNoise, imgSignal)
  RED   = [255,0,0];								%Define red pixels in RGB
  WHT   = [255];										%Define white pixels in grayscale
  CTRL  = 0;												%Control value
    
    %Generate background images of X,Y size
  nsMask = true(  size(imgNoise,1), size(imgNoise,2) ); %Noisy pixels
  imPup  = false( size(imgNoise,1), size(imgNoise,2) ); %Pupil pixels
  imTot  = false( size(imgNoise,1), size(imgNoise,2) ); %Total iris area pixels
  
    %Generate noise mask by binarising the RED areas of the image to 1
  for i=1:3
    nsMask = and(nsMask, imgNoise(:,:,i)==RED(i) );    %Bin noise img
  end;
  
    %Total area of the iris, except the pupil
  imTot  = or( nsMask, imgSignal(:,:,1)==WHT ); %tot = noise U signal
  
																	        %Calulate area of the pupil
  for i=1:1:size(imTot,1)									%For each row in image
    if nnz( imTot( i, :) ) > 1          	%Check if row has more than 1 pixel
      for j=1:1:size(imTot,2)           	%For each pixel in row
        if  CTRL==0             &&  ... 	%if not found any white pixel (0)
            imTot(i,j) == 1             	% and current pixel is white
          CTRL = 1;                     	%set ctrl to 1
        elseif  CTRL>=1         && ...  	%If control is 1 or more 
                imTot(i,j) == 0 && ...  	% and current pixel is blatck
                nnz(imTot(i,j:size(imTot,2))) ~= 0  %and still white pixels left
          imPup(i,j) = WHT;             	%set pixel to white in the new picture
          CTRL = 2;                     	%set state to 2
        elseif CTRL==2          && ...  	%if state is 2 and ther is 0 or more
                nnz(imTot(i,j:size(imTot,2))) >= 0%white pixels left
          CTRL = 0;                     	%reset stats
				end																%end of if checks
			end																	%end of pixel row
      CTRL = 0;                         	%Reset state variable to 0
		end                                 	%end of check for pixels in row
  end                                   	%End of row loop

  totIris    = imTot;     						%Num of pixels in the iris, W/O the pupil
  irisNoise  = nsMask;    						%Num of iris pixels considered noise
  irisSignal = imgSignal; 						%Num of iris pixels considered noise-free
  Pupil      = imPup;     						%Num of pupil pixels
  Total      = or( totIris, Pupil );  %Absolute max num of pixels
 	
																			%Clear the memory
  clear imTot nsMask imSignal imPup imgNoise RED WHT CTRL start;
end

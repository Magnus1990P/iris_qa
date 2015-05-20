function [focus, focus2] = focus(IMGORG, SIRIS)
  BLK     = [0,0,0];
  focus   = -1;
  img     = rgb2gray( imread( IMGORG ) );
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%  Remove unvanted data from focus assessment using the mask   %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:1:size(SIRIS,1)       %Black out unvanted parts of the orignal
    for j=1:1:size(SIRIS,2)     %image as according to
      if SIRIS(i,j) == [0]      %the iris' signal mask (SIRIS)
        img(i,j,:) = [0];       %Make it black
      end                       %
    end                         %
  end                           %
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%  CREATE HIGHPASS IMAGE   %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %Code gathered from: http://www.cs.uregina.ca/Links/class-info/425/Lab5/
  %Lab 5 - section 3.2
  %GENERATE FILTER LOW and Highpass gaussian filter
  PQ    = paddedsize( size( img ) );                    %Add padding to image
  DO    = 0.05*PQ( 1 );                                 %Select with of 5%
  
  HPF   = hpfilter('gaussian', PQ(1), PQ(2), DO );      %Create hp filter
  DFT   = fft2( double(img), size(HPF,1), size(HPF,2) );%create fourier of img
  DFTH  = (HPF .* DFT);                                 %convolute the images
  SHPF  = real( ifft2( DFTH ) );                        %Gen img from convolut.
  SHPF  = SHPF( 1:size( img , 1 ), 1:size( img, 2 ) );  %Remove padding
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%  Calculate focus score of High-Pass (Sharp) image  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  F     = fft2( SHPF );             %Fourier transform
  FS    = abs( fftshift( F(:) ) );  %Absolute value of the shifted fourier
  FS    = FS .^ 2;                  %Shifted fourier squared
  
  focus2= sum( FS );                %Total sum of it
  focus = sum( FS ) / 10^10;        %Summize the values into a single value
                                    % scale the value down by e+10, usual value
                                    % is around e+12, much more manageable value
return 

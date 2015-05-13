function [focus] = focus(IMGORG, SIRIS)
  BLK     = [0,0,0];
  focus   = -1;
  img     = rgb2gray( imread( IMGORG ) );
  
  for i=1:1:size(SIRIS,1)
    for j=1:1:size(SIRIS,2)
      if SIRIS(i,j) == [0]
        img(i,j,:) = [0];
      end
    end
  end
  
  %Code gathered from: http://www.cs.uregina.ca/Links/class-info/425/Lab5/
  %Lab 5 - section 3.2
  %GENERATE FILTER LOW and Highpass gaussian filter
  PQ    = paddedsize( size( img ) );
  DO    = 0.05*PQ( 1 );
  
  %%HIGHPASS
  HPF   = hpfilter('gaussian', PQ(1), PQ(2), DO );
  DFT   = fft2( double(img), size(HPF,1), size(HPF,2) );
  DFTH  = (HPF .* DFT);
  SHPF  = real( ifft2( DFTH ) );
  SHPF  = SHPF( 1:size( img , 1 ), 1:size( img, 2 ) );
  
  F   = fft2( SHPF );
  FS  = abs( fftshift( F(:) ) ) .^ 2;
  
  focus = sum( FS );
return 

  %subtract low-pass filter from the image
  % imfilter function
  %Use gaussian kernel for highpass filtering
  %powerspectrum gives the final value
  
  %High-pass filter creation and use
  %cs.uregina.ca/Links/class-info/4425/Lab5
  
  %Power spectrum density
  %(Image - LowPassImage)^2 = HighPassImg
  %Function( highPassImg )7

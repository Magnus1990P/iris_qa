function [focus] = focus(IMGORG, SIRIS)
  BLK = [0,0,0];
  focus = -1;
  img = imread( IMGORG );
  img2    = rgb2gray( img );
  subImg  = rgb2gray( img );
  
%   for i=1:1:size(SIRIS,1)
%     for j=1:1:size(SIRIS,2)
%       if SIRIS(i,j) == [0]
%         img2(i,j,:) = [0];
%       end
%     end
%   end
%   
%   X=0;
%   Y=0;
%   W=0;
%   H=0;
%   YY = size(SIRIS,1);
%   
%   for i=1:1:size(SIRIS,1)
%     if Y==0 && nnz( SIRIS(i,:) ) > 0
%       Y = i;
%     end
%     if H == 0 && nnz(SIRIS(YY-i+1,:)) > 1 
%       H = YY-i+1;
%     end
%   end
%   
%   for i=1:1:size(SIRIS,2)
%     if X==0 && nnz( SIRIS(:,i) ) > 0
%       X = i;
%       W = 0;
%     elseif X ~= 0 && W == 0 && nnz( SIRIS(:,i) ) == 0
%       W = i;
%     end
%   end
%   
%     %Select subimage of iris
%   subImg = img2( Y-10:H+10, X-10:W+10 );
  
  %Code gathered from: http://www.cs.uregina.ca/Links/class-info/425/Lab5/
  %Lab 5 - section 3.2
  %GENERATE FILTER LOW and Highpass gaussian filter
  PQ    = paddedsize( size( subImg ) );
  DO    = 0.05*PQ( 1 );
  
  %%HIGHPASS
  HPF   = hpfilter('gaussian', PQ(1), PQ(2), DO );
  DFT   = fft2( double(subImg), size(HPF,1), size(HPF,2) );
  DFTH  = (HPF .* DFT);
  SHPF  = real( ifft2( DFTH ) );
  SHPF  = SHPF( 1:size( subImg , 1 ), 1:size( subImg, 2 ) );
  
%   %%LOWPASS
%   LPF   = lpfilter('gaussian', PQ(1), PQ(2), DO );
%   DFT   = fft2( double(subImg), size(LPF,1), size(LPF,2) );
%   DFTL  = (LPF .* DFT);
%   SLPF  = real( ifft2( DFTL ) );
%   SLPF  = SLPF( 1:size( subImg , 1 ), 1:size( subImg, 2 ) );
%   

  fft2im    = fft2( double( SHPF ) );
  fft2im    = log(  1 + ( abs( fft2im ) ) );
  figure, plot( fft2im ), title('FFt');
  
  spectrum  = fftshift( fft2im );
  maximum   = max( max( spectrum ) );
  figure, plot( spectrum ), title('Spectrum fftshift');
  
  spectrum  = 255 * spectrum / maximum;
  spectrum  = uint8( spectrum );
  figure, plot( spectrum ), title('Spectrum, resized');
  
  figure, imshow( spectrum ), title('Spectrum');
  
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

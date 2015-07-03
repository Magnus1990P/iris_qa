function [af] = motion ( img )
  img = rgb2gray( imread( img ) );
  
  filter  = zeros(  floor(size(img,1)/10), ...
                    floor(size(img,2)/10) );
  
  dy      = size(filter, 1) / 2;
  dx      = size(filter, 2) / 2;
  sx      = floor( dx * 0.85 );
  
  filter( dy-4:dy+4 , dx-sx:dx+sx) = 255; 
  
  %figure, imshow( filter )
  af=1;
  imgF  = fft2( double( img ) );
  
  c=0;
  res = zeros( 36, 2 );
  for ang = 0 : (180/36) : 179
    ang=45;
    c = c + 1;
    filter2 = imrotate( filter, ang, 'crop' );
    filter3 = zeros( size(img) );
    filter4 = repmat( filter2, 10 );
    filter3(1:size(filter4,1),1:size(filter4,2)) = filter4;
    clear filter2 filter4
    
    filterF = fft2( filter3 );
      
    CONV    = filterF .* imgF;
    
    RESIMG  = ifft2( abs( log( 1+ abs( CONV ) ) ) .^ 2 );
    
    F = fft2( RESIMG );
    
    res( c, : ) = [ ang, sum( F ) ];
  end

  res   = zeros( 37, 2 );
  PSPEC = abs( log( 1 + abs( fft2( img ) ) ) ) .^ 2;
  
  
  c=0;
  for a = 0:(2*pi)/36:2*pi
    c=c+1;
    %res(c,:) = ;
  end
  


%   Cep{g(x,y)} = invFT{log(FT(g(x,y)))}
% 
%   The matlab code to do this will be:
% 
%   %Converting to fourier domain
%   gxy = fft2(gxy);
% 
%   %Performing log transform
%   lggxy = abs(log(1 + abs(gxy)));
% 
%   %Calculating the power spectrum of the blurred image
%   plggxy = lggxy.^2;
%   cgxy = ifft2(plggxy);
  
  
  
%   
%   m=1;
%   M=1;
%   for i=2:1:size(res,1)
%     if res(m,2) >= res(i,2)
%       m = i;
%     end
%     if res(M,2) <= res(i,2)
%       M = i;
%     end
%   end
  
  
  %res([m,M],:)
  %figure, plot( res(:,1), res(:,2) ), grid on;
%   at  = res(M, 1);
  %res(M,2) - res(m,2)
  
  %af = max(res(:,2) ) - min(res(:,2) );
  %af
  
return

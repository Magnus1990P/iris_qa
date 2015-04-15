function [focus] = focus(img, mask)

  imgGray = rgb2gray( img );
  hist = zeros(1,257);

  F = fft2( img );
  F = abs(  F   );
  F = log(  F+1 );
  F = mat2gray(F);
  
  for a=1:1:size(mask, 1)
    for b=1:1:size(mask, 2)
      if mask(a, b) > 0
        hist(1,img(a,b)+1) = hist(1,img(a,b)+1) + 1;
      end
    end
  end
  
  %imshow( F, [] );
  %imshow(mask);

end
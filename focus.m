function [focus] = focus(img, mask)

  imgGray = rgb2gray( img );
  
  im_fft = fft2( imgGray );
  % power
  im_Pfft = abs(im_fft.^2);
  % log of power, avoid log of zeros
  im_logPfft = log(im_Pfft+eps);
  figure(2); clf
  imagesc(im_logPfft), axis image;
  colorbar
  title('Log of power spectrum')
  
  %imagesc( fftshift( im_logPfft ) ), axis image;
  %colormap(jet(256))
  %colorbar
  %title('log of centered power spectrum')
  
  %for a=1:1:size(mask, 1)
  %  for b=1:1:size(mask, 2)
  %    if mask(a, b) > 0
  %      hist(1,img(a,b)+1) = hist(1,img(a,b)+1) + 1;
  %    end
  %  end
  %end
  
  %imshow( F, [] );
  %imshow(mask);

end
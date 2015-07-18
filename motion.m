function [A, T, R] = motion ( all, sig, org  )
  iOrg = rgb2gray( imread( org ) );
  focus=zeros(91,2);
  
  count=0;
  for ang=0:2:180
    count = count + 1;

    rAll = imrotate( all,  ang, 'nearest', 'crop' );
    iSig = imrotate( iOrg, ang, 'nearest', 'crop' );
    
    iSig = imgradientxy( iSig );
    iSig = ( iSig - min( iSig(:) ) ) ./ ( max( iSig(:) ) - min( iSig(:) ) );
    
    for y=1:size( rAll, 1)
      for x=1:size( rAll, 2)
        if rAll(y,x) == 0
          iSig(y,x) = 0;
        end
      end
    end
    
    F       = fft2( iSig );             %Fourier transform
    FS      = abs( fftshift( F(:) ) );  %Absolute value of the shifted fourier
    FS      = FS .^ 2;                  %Shifted fourier squared
    
    focus(count, 1) = ang;
    focus(count, 2) = sum( FS ) / 10^9;
  end
  
  [A, T]  = min( focus( :, 2 ) );
  A       = max( focus( :, 2 ) ) - A;
  T       = focus( T, 1 );
  %R       = focus;
return

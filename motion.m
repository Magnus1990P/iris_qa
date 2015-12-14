%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Feature for main.m
%%		Calculates angle and magnitude of the motion blur
%%
%%		A:					Amplitude of focus
%%		T:					Angle of motion blur in degrees
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja, NISlab
%%	Last rev:			
%%	Comment:			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A, T] = motion ( all, sig, org  )
  iOrg = rgb2gray( imread( org ) );
  focus= zeros(91,2);
  
  count	= 0;
  for ang=0:2:180												%Rotate 180 degrees for each 2 degrees 
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
    
    focus(count, 1) = ang;							%Append the angle
    focus(count, 2) = sum( FS );				%Calculate the focus
  end																		%End rotation
  
  [A, T]  = min( focus( :, 2 ) );				%Grab min amplitude
  A       = max( focus( :, 2 ) ) - A;		%Calculate amplitude
  T       = focus( T, 1 );							%Save angle

	clear focus rAll iSig iOrg;						%Clear memory
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	LPFILTER Computes frequency domain lowpass filters
%%
%%	Author:				
%%	Copyright:		http://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/lpfilter.m
%%	Supervisor:		
%%	Last rev:			
%%	Comment:			
%%  	Creates the transfer function of a lowpass filter, H, of the specified
%%			TYPE and size (M-by-N).  To view the filter as an image or mesh plot, it
%%			should be centered using H = fftshift(H).
%%   Valid values for TYPE, D0, and n are:
%%   'ideal'    Ideal lowpass filter with cutoff frequency D0.  n need
%%              not be supplied.  D0 must be positive
%%   'btw'      Butterworth lowpass filter of order n, and cutoff D0.
%%              The default value for n is 1.0.  D0 must be positive.
%%   'gaussian' Gaussian lowpass filter with cutoff (standard deviation)
%%              D0.  n need not be supplied.  D0 must be positive.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function H = lpfilter(type, M, N, D0, n)
% Use function dftuv to set up the meshgrid arrays needed for 
% computing the required distances.
[U, V] = dftuv(M, N);

% Compute the distances D(U, V).
D = sqrt(U.^2 + V.^2);

% Begin fiter computations.
switch type
case 'ideal'
   H = double(D <=D0);
case 'btw'
   if nargin == 4
      n = 1;
   end
   H = 1./(1 + (D./D0).^(2*n));
case 'gaussian'
   H = exp(-(D.^2)./(2*(D0^2)));
otherwise
   error('Unknown filter type.')
end


OS_SIZE = 4;
RED=[255, 0, 0];                     %Grab the red color
WHT=[255];                           %Dictate white color
short_list;                          %IMPORT image database


for i = 1:1:1%size(  dbOrg, 1 )
  imgOrg    = imread( dbOrg(i                     , : ) );
  imgMrg    = imread( dbOsiris( ( (i-1)*OS_SIZE)+4, : ) );
  imgMsk    = imread( dbOsiris( ( (i-1)*OS_SIZE)+3, : ) );

  %[pxTotal, pxNoise, pxSignal, pxPupil] = area(imgMrg, imgMsk);
  
  Ac = pxSignal;
  Ap = ( pxPupil / pxTotal ) * 100;
  Ao = ( pxNoise / pxTotal );
  
  %focus( imgOrg, imgMsk );
  
end


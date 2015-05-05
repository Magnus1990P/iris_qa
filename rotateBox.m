
function [M, W, H] = rotateBox( iB, A )
  if A == 0 || A == 90
    X = max(iB(:,1)) - min(iB(:,1));
    Y = max(iB(:,2)) - min(iB(:,2));
    W = X; H = Y;
    M = W * H;
    return
  end

  nB = zeros( size(iB,1), 2 );
  nB(1,:) = [ iB(1, 1:2) ];
  nB(1,:) = [0,0];
  
  for I=1:1:size(iB, 1)
    [DX, DY]  = getDelta( iB, I     );
    T         = atan2d( DY, DX      );
    V         = sqrt(   DX^2 + DY^2 );
    
    nT        = T - A;
    nDX = sind( nT ) * V;
    nDY = cosd( nT ) * V;
    
    if I ~= size(iB,1)
      nB(I + 1,:) = [nB(I,1)+nDX, nB(I,2)+nDY];
    end
  end
  
  W = max(nB(:,1)) - min(nB(:,1)); 
  H = max(nB(:,2)) - min(nB(:,2));
  M = W * H;
  
  clear nB iB DX DY T V nT nDX nDY X Y A;
return

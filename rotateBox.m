%Returns area(M), width(W) and height(H)
%Parameters:  coordinates of a convexHull (iB), 
%             the angle of which to use for rotation
%             coordinates of where "origo" should be placed  (NOT USED)
function [M, W, H] = rotateBox( iB, A, COOR )
  if A == 0 || A == 90
    W     = max(iB(:,1)) - min(iB(:,1));%Calculate width
    H     = max(iB(:,2)) - min(iB(:,2));%Calcualte height
    M     = W * H;                      %Calculate area
    return
  end

  nB      = zeros( size(iB,1), 2 );     %Create a new matrix for the border
  nB(1,:) = [0,0];                      %Initiate origo point for coordinates
  
  for I=1:1:size(iB, 1)
    [DX, DY]  = getDelta( iB, I     );  %Calculate delta values for X and Y
    T         = atan2d( DY, DX      );  %Get angle in degrees
    V         = sqrt(   DX^2 + DY^2 );  %Calculate hypothenuse
    
    nT        = T - A;                  %Calculate new angle, current - rotation
    nDX       = sind( nT ) * V;         %Calulate nuew delta X length
    nDY       = cosd( nT ) * V;         %Calclate new delta Y length
    
    if I ~= size(iB,1)                  %Calculate next points coordinates
                                        %current coordinate + delta values
      nB(I + 1,:) = [nB(I,1)+nDX, nB(I,2)+nDY];
    end
  end
  
  W = max(nB(:,1)) - min(nB(:,1));      %Calculate width of the box
  H = max(nB(:,2)) - min(nB(:,2));      %Calculate height of the box
  M = W * H;                            %Calculate area of the box
  
  clear nB iB DX DY T V nT nDX nDY X Y A;
return

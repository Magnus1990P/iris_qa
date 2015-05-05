function [Aa, Ta, P_AREA, I_AREA] = borderBox( imgParameter )
  param     = imgParameter;
  count     = 1;
  minAngle  = -1;
  minArea   = -1;
  RE        = zeros(5,2);
  dM        = 0;
  dm        = 0;
  
  parameterData   = importdata( param );
  Ph              = parameterData(1);
  Ih              = parameterData(2);
  irisBorder      = zeros(Ih, 3);
  pupilBorder     = zeros(Ph, 3);
  
  
  %%%%%%%%%%%%%%%%%%
  %   Calculate minimum bounding rectangle of pupil
  
  %Generate pupil border matrix
  for I = 3:3:(3*Ph)
    pupilBorder(count,:) = [parameterData(I:I+2)];
    count = count + 1;
  end
  
  minAngle  = -1;
  minArea   = -1;
  %Get convex hull
  pupilHull = convhull(pupilBorder(:,1), pupilBorder(:,2) );
  %Grab coordinate values of the points in the convex hull
  COOR      = pupilBorder( pupilHull, 1:2);
  for I=1:1:size(COOR,1)  
    %Calculate delta of current edge
    [DX, DY]  = getDelta( COOR, I  );
    %Calculate the angle of the vector in degrees
    Angle     = atan2d(   DY,   DX );
    %Rotate and measure values of the convex hull
    [M, W, H] = rotateBox( COOR, Angle );
    
    %If minArea,  update
    if minArea == -1 || minArea > M
      minAngle = Angle;
      minArea  = M;
    end
  end
  P_AREA = minArea;
  
  
  %%%%%%%%%%%%%%%%%%
  %   Calculate minimum bounding rectangle of iris
  %Reset values
  minAngle  = -1;
  minArea   = -1;
  count     =  1;
  
  %Generate pupil border matrix
  for I = 3*Ph+3:3:(3*Ph)+(3*Ih)
    irisBorder(count,:) = [parameterData(I:I+2)];
    count = count + 1;
  end
  
  %Get convex hull
  irisHull = convhull(irisBorder(:,1), irisBorder(:,2) );
  %Grab coordinate values of the points in the convex hull
  COOR     = irisBorder( irisHull, 1:2);
  for I=1:1:size(COOR,1)
    %Calculate delta of current edge
    [DX, DY]  = getDelta( COOR, I  );
    %Calculate the angle of the vector in degrees
    Angle     = atan2d(   DY,   DX );
    %Rotate and measure values of the convex hull
    [M, W, H] = rotateBox( COOR, Angle );
    
    %If minArea,  update
    if minArea == -1 || minArea > M
      minAngle = Angle;
      minArea  = M;
    end
  end
  I_AREA = W*H;
  
  
  %%%%%%%%%%%%%%%%%%
  
  %Set dM and dm
  if W > H
    dM=W; dm=H;
  else
    dM=H; dm=W;
  end
  
  %Calculate angled rectangle
  RE(2,:) = [ (cosd(minAngle)*W),             sind(minAngle)*W ];
  RE(4,:) = [ RE(1,1) + (sind(minAngle)*H),   RE(1,2) + (cosd(minAngle)*H) ];
  RE(3,:) = [ RE(2,1) - RE(4,1),              RE(2,2) + RE(4,2) ];
  RE(4,:) = [ 0       - RE(4,1),              RE(3,2) - RE(2,2) ];
  
  %alpha angle and Theta rotation
  Aa = (1-(dm/dM));
  if RE(2,2) <= 0
    Ta = tand( atan2d( (RE(2,2)/dM), (RE(2,1)/dM) )  );
  else
    Ta = tand( atan2d( ((0-RE(2,2))/dM), ((0-RE(2,1))/dM) ) );
  end
return
  

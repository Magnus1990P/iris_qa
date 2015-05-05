function [IAa, ITa, I_AREA, PAa, PTa, P_AREA] = borderBox( imgParameter )
  param     =  imgParameter;
  count     =  1;
  minAngle  = -1;
  RE        =  zeros(5,2);
  dM        =  0;
  dm        =  0;
  P_AREA    = -1;
  PW        =  0;
  PH        =  0;
  I_AREA    = -1;
  IW        =  0;
  IH        =  0;
  
  parameterData   = importdata( param );
  Ph              = parameterData(1);
  Ih              = parameterData(2);
  irisBorder      = zeros(Ih, 3);
  pupilBorder     = zeros(Ph, 3);
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%
  %   Calculate minimum bounding rectangle of pupil
  
  %
  %Generate pupil border matrix
  for I = 3:3:(3*Ph)
    pupilBorder(count,:) = [parameterData(I:I+2)];
    count = count + 1;
  end
  
  minAngle  = -1;
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
    if P_AREA == -1 || P_AREA > M
      minAngle = Angle;
      P_AREA  = M;
      PW      = W;
      PH      = H;
      
      %Set dM and dm
      if W > H
        dM=W; dm=H;
      else
        dM=H; dm=W;
      end
    end
  end
  
  %Calculate angled rectangle
  RE(2,:) = [ (cosd(minAngle)*PW),            sind(minAngle)*PW ];
  RE(4,:) = [ RE(1,1) + (sind(minAngle)*PH),  RE(1,2) + (cosd(minAngle)*PH) ];
  RE(3,:) = [ RE(2,1) - RE(4,1),              RE(2,2) + RE(4,2) ];
  RE(4,:) = [ 0       - RE(4,1),              RE(3,2) - RE(2,2) ];
  
  %alpha angle and Theta rotation
  PAa = (1-(dm/dM));
  if RE(2,2) <= 0
    PTa = tand( atan2d( (RE(2,2)/dM), (RE(2,1)/dM) )  );
  else
    PTa = tand( atan2d( ((0-RE(2,2))/dM), ((0-RE(2,1))/dM) ) );
  end
  
  
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%
  %   Calculate minimum bounding rectangle of iris
  %Reset values
  minAngle  = -1;
  count     =  1;
  
  %Generate pupil border matrix
  for I = 3*Ph+3:3:(3*Ph)+(3*Ih)
    irisBorder(count,:) = [ parameterData(I:I+2) ];
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
    if I_AREA == -1 || I_AREA > M
      minAngle = Angle;
      I_AREA  = M;
      IW      = W;
      IH      = H;
      %Set dM and dm
      if W > H
        dM=W; dm=H;
      else
        dM=H; dm=W;
      end
    end
  end
  
  %Calculate angled rectangle
  RE(2,:) = [ (cosd(minAngle)*IW),            sind(minAngle)*IW ];
  RE(4,:) = [ RE(1,1) + (sind(minAngle)*IH),  RE(1,2) + (cosd(minAngle)*IH) ];
  RE(3,:) = [ RE(2,1) - RE(4,1),              RE(2,2) + RE(4,2) ];
  RE(4,:) = [ 0       - RE(4,1),              RE(3,2) - RE(2,2) ];
  
  %alpha angle and Theta rotation
  IAa = (1-(dm/dM));
  if RE(2,2) <= 0
    ITa = tand( atan2d( (RE(2,2)/dM), (RE(2,1)/dM) )  );
  else
    ITa = tand( atan2d( ((0-RE(2,2))/dM), ((0-RE(2,1))/dM) ) );
  end
  
return
  

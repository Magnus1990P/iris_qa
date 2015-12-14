%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Calculates the delta values of coordinate
%%
%%		DX			Delta X
%%		DY			Delta Y
%%
%%	Author:				Magnus Øverbø
%%	Copyright:		Magnus Øverbø
%%	Supervisor:		Kiran Bylappa Raja NISlab
%%	Last rev:			
%%	Comment:			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DX, DY] = getDelta( C, I )

  Y2=0; Y1=0; X2=0; X1=0;
  
  if I == size(C,1)
    X1 = C( I,   1 );
    X2 = C( 1,   1 );
    Y1 = C( I,   2 );
    Y2 = C( 1,   2 );
  else
    X1 = C( I,   1 );
    X2 = C( I+1, 1 );
    Y1 = C( I,   2 );
    Y2 = C( I+1, 2 );
	end
  
	DX	=	X2-X1;  
	DY	=	Y2-Y1;
  
	clear X1 X2 Y1 Y2 C I;			%Clear memory
  
return

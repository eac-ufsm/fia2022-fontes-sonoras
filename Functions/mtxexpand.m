function [ZI, XIi, YIi] = mtxexpand(Case,A,B,ScaleFactor,startx,endx,starty,endy)
%% Function to expand matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1, B equal to A
% 2, A equal to B
% 3, Scale Factor for A
% 4, make A a square matrix 
% 4, if the matrix is already square, you may use a scale factor
%
%   Prof. William D'andrea Fonseca, Dr. Eng. - Acoustical Engineering
%
%   Last change: 13/06/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 5
   startx = 1; endx = size(A,2); starty = 1; endy = size(A,1); 
%    disp(['Warning: startx,endx,starty,endy, automatically set to ' num2str(startx) ' ' num2str(endx) ' ' num2str(starty) ' ' num2str(endy) ' .']);
end
if Case==3 && nargin < 4
   error('Please put B=1 and your chosen scale factor.')
end
if (Case==1 || Case==2) && nargin < 3
   error('Please input B matrix.')
end

if Case==4 && nargin < 3
   ScaleFactor = 2;
end
if Case==4 && nargin < 4 && B==1 % Silent mode
   ScaleFactor = 2; silent = 1;
end

if B==1; silent = 1; end % Silent mode
%% Process
% if ScaleFactor~=1
SzMtA = [size(A,1) size(A,2)];
if Case==1 || Case==2
 SzMtB = [size(B,1) size(B,2)];
end

if Case==1    % Matrix B equals to A
  if numel(B)==1; error('B must be at least 2x2.'); end
  if numel(A)==1; error('A must be at least 2x2.'); end
  stpx  = (endx-startx)/(SzMtB(2)-1);
  stpy  = (endy-starty)/(SzMtB(1)-1);
  % Calculate Scale factor
  ScaleFactx = SzMtA(2)/SzMtB(2);
  ScaleFacty = SzMtA(1)/SzMtB(1);
  % Step
  stpxSF = (endx-startx)/(ScaleFactx*SzMtB(2)-1);
  stpySF = (endy-starty)/(ScaleFacty*SzMtB(1)-1);  
  MTX = B;
elseif Case==2 % Matrix A equals to B
  if numel(B)==1; error('B must be at least 2x2.'); end
  if numel(A)==1; error('A must be at least 2x2.'); end  
  stpx  = (endx-startx)/(SzMtA(2)-1);
  stpy  = (endy-starty)/(SzMtA(1)-1);
  % Calculate Scale factor
  ScaleFactx = SzMtB(2)/SzMtA(2);
  ScaleFacty = SzMtB(1)/SzMtA(1);
  % Step
  stpxSF = (endx-startx)/(ScaleFactx*SzMtA(2)-1);
  stpySF = (endy-starty)/(ScaleFacty*SzMtA(1)-1);  
  MTX = A;  
elseif Case==3 % Scale factor for A
  if numel(A)==1; error('A must be at least 2x2.'); end; B = 1;
  stpx  = (endx-startx)/(SzMtA(2)-1);
  stpy  = (endy-starty)/(SzMtA(1)-1);
  % Calculate Scale factor
  ScaleFactx = ScaleFactor;
  ScaleFacty = ScaleFactor;
  % Step
  stpxSF = (endx-startx)/(ScaleFactx*SzMtA(2)-1);
  stpySF = (endy-starty)/(ScaleFacty*SzMtA(1)-1);    
  MTX = A;
elseif Case==4 % Make square matrix
  if numel(A)==1; error('A must be at least 2x2.'); end  
  stpx  = (endx-startx)/(SzMtA(2)-1);
  stpy  = (endy-starty)/(SzMtA(1)-1);  
  % What should I expand ?
  if SzMtA(1)>SzMtA(2)
  % Calculate Scale factor
  ScaleFactx = SzMtA(1)/SzMtA(2);
  ScaleFacty = 1;
  elseif SzMtA(1)<SzMtA(2)
  % Calculate Scale factor
  ScaleFactx = 1;
  ScaleFacty = SzMtA(2)/SzMtA(1);      
  elseif SzMtA(1)==SzMtA(2)
    if ScaleFactor~=1
      ScaleFactx = ScaleFactor;
      ScaleFacty = ScaleFactor;  
    else
      if silent~=1; disp('ScaleFactor=1, I do NOT need to work.'); end
      ZI = A; XIi=1; YIi=1; return;
    end
      if silent~=1; disp('They are already the same size.'); end
  end
  % Step
  stpxSF = (endx-startx)/(ScaleFactx*SzMtA(2)-1);
  stpySF = (endy-starty)/(ScaleFacty*SzMtA(1)-1);
  MTX = A;  
end    

[X, Y] = meshgrid(startx:stpx:endx,starty:stpy:endy);

%% Interpolate points
[XI, YI] = meshgrid(startx:stpxSF:endx,starty:stpySF:endy);

if nargout > 1
    XIi = XI;
    YIi = YI;
end

ZI = interp2(X,Y,MTX,XI,YI);

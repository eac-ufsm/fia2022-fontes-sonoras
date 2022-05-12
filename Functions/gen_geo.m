function [geo, para] = gen_geo(type,param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotina gerar geometrias
%
% Desenvolvido pelo professor
%    Prof. William D'Andrea Fonseca, Dr. Eng.,
%
% Atualização: 12/04/2019
%
% 1. Configure o tipo de geometria
% 2. Utilize os parâmetros de entrada corretos para cada tipo
%    Observe os dados de demonstração para cada tipo.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Testing
% clear all; close all; clc
% type = 'spiral'; param = 'demo';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spiral %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(type,'spiral')
    
if strcmp(param,'demo')   
para.FrameSize   = 1.1;           % Frame size [m]
para.GridInt     = [0.05 0.05];   % Grid interval [m]
para.MinRad      = 0.1;           % Minimum radius [m]
para.MaxRad      = 0.5;           % Maximum radius [m]
para.MicpCircle  = 16;            % Mics per circle [-]
para.Circles     = 4;             % Number of circles [-]
para.SpiralAngle = rad2deg(1.5);  % Spiral Angle [deg]
else
para = param;
end

para.Channels  = para.MicpCircle*para.Circles;
para.xp        = 0:1:para.Circles-1;
para.yp        = 0:1:para.MicpCircle-1;

eq1 = (para.MaxRad^2 - para.MinRad^2)/(para.Circles - 1)*...
       (para.xp+1) +...
       (para.MinRad^2 * para.Circles - para.MaxRad^2)/(para.Circles - 1);
eq1 = sqrt(eq1);

eq2 = log(eq1/para.MinRad) * deg2rad(para.SpiralAngle)/(log(para.MaxRad/para.MinRad));

for a=1:para.Circles
    for b=1:para.MicpCircle
        pos.X(a,b) = cos(eq2(a) + ((2*pi/para.MicpCircle) * para.yp(b)))*eq1(a);
        pos.Y(a,b) = sin(eq2(a) + ((2*pi/para.MicpCircle) * para.yp(b)))*eq1(a);
    end
end

pos.Xgrid = para.GridInt(1,1) .* round(pos.X./para.GridInt(1,1));
pos.Ygrid = para.GridInt(1,2) .* round(pos.Y./para.GridInt(1,2));

pos.Xx = reshape(pos.Xgrid,[1,para.Channels]);
pos.Yy = reshape(pos.Ygrid,[1,para.Channels]);
pos.Zz = zeros(1,para.Channels);

geo.cart = [pos.Xx.' pos.Yy.'];
geo.spanVect = pdist(geo.cart,'euclidean');
geo.spanSquare = squareform(geo.spanVect);
geo.span = max(max(geo.spanSquare));
geo.cart = [pos.Xx.' pos.Yy.' pos.Zz.'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Circle
elseif strcmp(type,'circle')

if strcmp(param,'demo')   
para.FrameSize   = 1.1;            % Frame size [m]
para.GridInt     = [0.0001 0.0001];% Grid interval [m]
para.Radius      = 1.5/2;          % Minimum radius [m]
para.MicpCircle  = 32;             % Mics per circle [-]
para.TurnAngle = 0;                % Spiral Angle [deg]
para.Offset = [0 0];               % Center offset in x and y if nedeed
else
para = param;
end

para.Channels = para.MicpCircle;

para.Theta = (0+para.TurnAngle):360/para.MicpCircle:(360+para.TurnAngle)-360/para.MicpCircle;
pos.X = para.Radius * cos(deg2rad(para.Theta)) + para.Offset(1,1);
pos.Y = para.Radius * sin(deg2rad(para.Theta)) + para.Offset(1,2);
pos.Z = zeros(1,para.Channels);

pos.Xgrid = para.GridInt(1,1) * round(pos.X/para.GridInt(1,1));
pos.Ygrid = para.GridInt(1,2) * round(pos.Y/para.GridInt(1,2));

geo.cart = [pos.Xgrid.' pos.Ygrid.'];
geo.spanVect = pdist(geo.cart,'euclidean');
geo.spanSquare = squareform(geo.spanVect);
geo.span = max(max(geo.spanSquare));
geo.cart = [pos.Xgrid.' pos.Ygrid.' pos.Z.'];

end

%% Check the size
if geo.span>para.FrameSize; warning('The array is bigger than the frame size! Have a look!'); end

%% Plot da geometria
% Plot.geo = figure(28); Plot.geoFig = scatter(geo.cart(:,1),geo.cart(:,2)); 
% arruma_fig('%3.1f','%3.1f')
% title(['Arranjo: ' ar]); xlabel('X [m]'); ylabel('Y [m]'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF
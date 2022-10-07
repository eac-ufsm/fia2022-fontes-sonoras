%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% simulate_measurement_mvs - Simulate an array measuerement with multiple
% moving sources
%
% Inputs:
%  required:
%   sources: Cell{Sources} - array of sources obj
%   array: MicArray - mic array obj
%   Traj: Trajectory - trajectory obj - with postion x,y,z and time_vector 
%   array with at least two points
%
%  optional:
%   'Fs': int - samplingrate
%   'c0': float - sound speed in air - prefer preferably use setGlobalC0
%    to change that value
%   'Noise': float - value in db to add noise to data
%
% Output:
%
%   varargout{1}: SAudio - Simulated audio for each mic in array
%   varargout{2}: Sources - Sources with the created audio
%   varargout{3}: Trajectory - Sources trajectory
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function varargout = simulate_measurement_mvs(sources,array,Traj,varargin)

% Default inputs
sArgs = containers.Map({'Fs','c0','Noise'},{44100,getGlobalc0,0});

% Optional inputs
for i=1:2:length(varargin)
   sArgs(varargin{i}) = varargin{i+1};
end

%%%%%% Sources Properties %%%%%%%%%
pos = Traj.Traj(sArgs('Fs')); % Positions x,y,z
v_s = Traj.V('Fs',sArgs('Fs')); % Velocities vx, vy, vz
n_sources = length(sources);

%%%%%%%%% Time %%%%%%%%
time = Traj.TotalTime();
t = linspace(0,time,time*sArgs('Fs'));

%%%%%% Microphone %%%%%%
x_mic = reshape(array.position('x'),length(array.position('x')),1);
y_mic = reshape(array.position('y'),length(array.position('y')),1);
z_mic = reshape(array.position('z'),length(array.position('z')),1);

%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%
for i=1:1:n_sources
    %%%% Source %%%%%%%
    source = sources{i};
    %%%% Check Fs %%%%%
    if source.Fs ~= sArgs('Fs')
        error(strjoin(["Frequency sample doesn't match! Source{", num2str(i), ...
            "} has a Fs of ", num2str(source.Fs), ...
            " Hz and the function input value is Fs of ", num2str(sArgs('Fs')), ...
            " Hz. Therefore, they don't match! Please check your inputs."], ''));
    end
    %%%% Get positions from the Source %%%%%
    x_s = pos('x') + source.position('x');
    y_s = pos('y') + source.position('y');
    z_s = pos('z') + source.position('z');
    %%%%%% Audio file %%%%%%%%
    Audio = source.CreateAudio('T',time);
    s(i,:) = Audio.time_data;
    %%%%%% Distance in R^3 %%%
    R = sqrt((z_s-z_mic).^2 + (y_s - y_mic).^2 + (x_s - x_mic).^2);
    %%%%%% Distance in R^2 %%%
    R2 = sqrt((x_s - x_mic).^2 + (z_s - z_mic).^2);
    %%%%%% Angle in R^2 %%%%%%
    r_angle = asin(z_s./R2);
    %%%%%% time of the wave travel%%
    t_ray = R./sArgs('c0');
    %%%%%%% Transfer function %%%%%%
    M = v_s('vx')/sArgs('c0'); % mach number
    H = (1./(4*pi.*R.*(1-(M.*cos(r_angle))).^2));
    %%%%%%% Pressure %%%%%%%%%%%%%%%
    P(:,:,i) = H.*s(i,:);
    %%%%%%% Wave reception time %%%%
    T_reception(:,:,i) = t + t_ray;
end

%%%% Ignoring interp for some reasons

%%%%%%%%%% Cutting the time vector due to the time difference %%%%%%% 
%%%%%%% in which the first and last waves arrives %%%%%

% min_t = [];
% max_t = [];
%
% for i=1:1:n_sources
%     min_t = [min_t min(T_reception(:,:,i),[],2).'];
%     max_t = [max_t max(T_reception(:,:,i),[],2).'];
% end
% t_begin = max(min_t);
% t_end = min(max_t);
% t_interp = linspace(t_begin,t_end,(t_end-t_begin)*sArgs('Fs'));
t_interp = t;

%%%%% Interping data %%%%%%%%%%%%
sz = size(P);
%for i=1:1:
output_mic = zeros(sz(1),length(t_interp));
for i=1:1:sz(1)
    for j=1:1:n_sources
        output_mic(i,:) = output_mic(i,:)+interp1(T_reception(i,:,j),P(i,:,j),t_interp);
    end
end

output_mic(isnan(output_mic(:,:))) = 0;

%%%%% Adding Noise %%%%%%%%%%%%%%
if sArgs('Noise')>0
   for  i=1:1:array.n_mic
      output_mic(i,:) = awgn(output_mic(i,:),sArgs('Noise')); 
   end
end

%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%
%%%% Audio vector %%%
if nargout>0
    Audium = SAudio;
    Audium.time_data = output_mic;
    Audium.c0 = sArgs('c0');
    Audium.Fs = sArgs('Fs');
    varargout{1} = Audium;
end
%%%% Source data %%%%%
if nargout>1
    for i =1:1:n_sources
        sources{i}.time_data = s(i,:);
        sources{i}.Fs = sArgs('Fs');
    end
    varargout{2} = sources;
end
%%%% Traj positions %%%
if nargout>2
    out_traj = Trajectory;
    out_traj.position('x') = pos('x');
    out_traj.position('y') = pos('y');
    out_traj.position('z') = pos('z');
    out_traj.time_vector = t - t_interp(1);
    varargout{3} = out_traj;
end
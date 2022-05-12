classdef Trajectory
    % SourceTrajectory  Source Trajetory Constructor.
    % This class is used to calculate the source trajectory samples.
    %
    % SourceTrajectory Properties:
    %    position - containers.Map.
    %    time_vector - Array.
    %
    % SourceTrajectory Methods:
    %    CalcTraj - Function to calculate source trajecory.
  
    properties
        position ;% Positions at x, y, z (m). How to set? Ex. SourceTrajectory.position('x') = two or more values;
        time_vector ;% Time vector (s) - The values is related to each position sample
    end
    methods 
        function this = Trajectory(time,varargin)
           this.position = containers.Map({'x','y','z'},{[],[],[]}); 
           this.time_vector = [];
           if nargin>0
               this.time_vector = time;
               for i=1:2:length(varargin)
                   this.position(varargin{i}) = varargin{i+1};
               end
               names = this.position.keys();
               val = this.position.values();
               for i=1:1:length(names)
                   if isempty(this.position(names{i})) == 1
                       this.position(names{i}) = zeros(length(this.time_vector),1);
                   end
               end
           end
        end
        %%%%% Trajectory positions %%%
        function varargout = Traj(obj,Fs)
            % Function to calculate the source trajectory samples
            % Optional input:
            % Fs - Sample frequency (Hz).
            % Outputs:
            % traj(map.Container) (m) - Values of trajectory samples - How to acces? Ex. traj('x');
            % time_vector (s) - Time instants of each trajectory sample.
            names = obj.position.keys();
            % Empty variable of traj
            traj = containers.Map({'x','y','z'},...
                {[],[],[]});
            % Empty variable of time
            time_out = linspace(obj.time_vector(1),obj.time_vector(end),...
                abs(obj.time_vector(end)-obj.time_vector(1))*Fs);
            traj('x') = interp1(obj.time_vector,obj.position('x'),time_out);
            traj('y') = interp1(obj.time_vector,obj.position('y'),time_out);
            traj('z') = interp1(obj.time_vector,obj.position('z'),time_out);
            % Outputs
            % Traj
            if nargout>0
                varargout{1} = traj;
            end
            % Time vector
            if nargout>1
                varargout{2} = time_out;
            end
        end
        function varargout = get_time_by_position(obj, position, axis)
            [traj, t] = obj.Traj(44100);
            traj = traj(axis);
            [~, idx] = min(abs(position - traj));
            varargout{1} = t(idx);
        end
        function varargout = TimeWindow(obj,x,varargin)
            % Function to calculate the source trajectory samples
            % Optional input:
            % Fs - Sample frequency (Hz).
            % Outputs:
            % traj(map.Container) (m) - Values of trajectory samples - How to acces? Ex. traj('x');
            % time_vector (s) - Time instants of each trajectory sample.
            sArgs = containers.Map({'Fs'}...
                ,{44100});
            for i =1:2:length(varargin)
                sArgs(varargin{i}) = varargin{i+1};
            end
            names = obj.position.keys();
            [pos, time_pos] = obj.Traj(sArgs('Fs'));
            % Empty variable of traj
            time_out = interp1(pos('x'),time_pos,x);
            % Outputs
            % Traj
            if nargout>0
                varargout{1} = time_out;
            end
            % Time vector
            if nargout>1
                varargout{2} = 0;
            end
        end
        %%%%% Velocity %%%%%%%%%%%%%%%
        function varargout = V(obj,varargin)
            % Function to calculate the source trajectory samples
            % Optional input:
            % Fs - Sample frequency (Hz).
            % Outputs:
            % vel(map.Container) (m) - Values of velocity samples - How to acces? Ex. traj('x');
            % time_vector (s) - Time instants of each trajectory sample.
            sArgs = containers.Map({'Fs'},{44100});
            for i=1:2:length(varargin)
               sArgs(varargin{i}) = varargin{i+1}; 
            end
            % Empty variable of traj
            vel = containers.Map({'x','y','z'},{[],[],[]});
            % Cache of the positions
            [traj,time_out] = obj.Traj(sArgs('Fs'));
            % positions
            x = traj('x'); y = traj('y'); z = traj('z');
            % velocities
            vx = diff(x)*sArgs('Fs'); vy = diff(y)*sArgs('Fs');
            vz = diff(z)*sArgs('Fs');
            %
            vel = containers.Map({'vx','vy','vz'},...
                {[vx(1) vx],[vy(1) vy],[vz(1) vz]});            
            % Outputs
            % Traj
            if nargout>0
                varargout{1} = vel;
            end
            % Time vector
            if nargout>1
                varargout{2} = time_out;
            end
        end
        %%%%% mean velocity %%%%%%%%%%
        function vel = dV(obj,varargin)
            sArgs = containers.Map({'Fs'},{44100});
            for i =1:2:length(varargin)
               sArgs(varargin{i}) = varargin{i+1}; 
            end
            dt = obj.time_vector(end) - obj.time_vector(1);
            %%%% Velocity vector %%%%
            vel = obj.V('Fs',sArgs('Fs'));
            %%%% Mean velocity %%%%%%
            vx = mean(vel('vx')); 
            vy = mean(vel('vy'));
            vz = mean(vel('vz'));
            %%%% Output %%%%%%%%%%%%%
            vel = containers.Map({'vx','vy','vz'},...
                {vx,vy,vz});
        end
        %%%%% Total time %%%%%%%%%%%%%
        function time = TotalTime(obj)
            time = obj.time_vector(end)-obj.time_vector(1);
        end
        %%%%% Central time %%%%%%%%%%%
        function varargout = CentralTime(obj,varargin)
            sArgs = containers.Map({'pos','axis','Fs'},{0,'x',44100});
            for i =1:2:length(varargin)
                sArgs(varargin{i}) = varargin{i+1};
            end
            pos = obj.Traj(sArgs('Fs'));
            time_vec = linspace(obj.time_vector(1),obj.time_vector(end),...
                    length(pos('x')));
            [val,idx] = min(abs(pos(sArgs('axis'))-sArgs('pos')));
            varargout{1} = time_vec(idx);
            varargout{2} = val;
        end
    end
    
    methods 
        function plot(obj,type,varargin)
            sArgs = containers.Map({'Fs'},{44100});
            for i=1:2:length(varargin)
               sArgs(varargin{i}) = varargin{i+1}; 
            end
            %%%%%% Velocitie plot %%%%%%%%%%
            if strcmp(type,'vx') || strcmp(type,'vy') || strcmp(type,'vz')
                [vel, t] = obj.V('Fs',sArgs('Fs'));
                figure()
                plot(t,vel(type))
                xlabel('Time [s]')
                ylabel('Velocity [m/s]')
            %%%%%% Position plot %%%%%%%%%%%
            elseif strcmp(type,'x') || strcmp(type,'y') || strcmp(type,'z') 
                [traj, t] = obj.Traj(sArgs('Fs'));
                figure()
                plot(t,traj(type))
                xlabel('Time [s]')
                ylabel('Position [m]')
            end
        end
    end
end
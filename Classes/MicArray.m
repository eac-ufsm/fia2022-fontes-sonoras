classdef MicArray< handle
    properties
       calib;
       position;
       parameters;
    end  
    methods
        %%%%%%%%% Clas constructor %%%%%%%%%%%%%%%%
        function this = MicArray(varargin)
            this.position = containers.Map({'x','y','z','H'},{[],[],0,0});
            if isempty(varargin) == false
                if strcmp(varargin{1},'load')
                    data = load(varargin{2});
                    data = reshape(data,length(data),3);
                    this.position('x') = data(:,1);
                    this.position('y') = data(:,2);
                    this.position('z') = data(:,3);
                    if strcmp(varargin{3},'H')
                       this.position('y') = this.position('y') + varargin{4};
                    end
                else
                    calib = master_mvs;
                    if nargin > 0
                        for i=1:2:length(varargin)
                            this.position(varargin{i}) = varargin{i+1};
                        end
                        this.position('y') = this.position('y') + this.position('H');
                    end
                end
            end
        end
        %%%%%%%%% Invert position %%%%%%%%%%%%%%%%%
        function invert_mic_position(obj,axis)
            obj.position(axis) = obj.position(axis)*(-1);
        end
        %%%%%%%%%%% Generate array %%%%%%%%%%%%%%%%
        function GenerateArray(obj,type,varargin)
            % Default values
            sArgs = containers.Map({'FrameSize','GridInt','Radius',...
                'MicpCircle','Circles','MinRad','MaxRad','SpiralAngle',...
                'TurnAngle','Offset','H','Silent'}...
                ,{1.1,[0.05 0.05],1.3/2,8,4,0.1,0.5,85.9437,0,[0 0],1.2,0});
            
            %Optional inputs
            % General: Framesize, Grid Int, Radius, MicpCircle
            % Spiral: Circles, SpiralAngle, Minrad, Maxrad
            % Circle: 
            for i=1:2:length(varargin)
                sArgs(varargin{i}) = varargin{i+1};
            end       
            para.FrameSize = sArgs('FrameSize'); para.GridInt = sArgs('GridInt'); para.MinRad = sArgs('MinRad'); para.MaxRad = sArgs('MaxRad'); 
            para.MicpCircle = sArgs('MicpCircle'); para.Circles = sArgs('Circles'); para.SpiralAngle = sArgs('SpiralAngle');
            para.TurnAngle = sArgs('TurnAngle'); para.Offset = sArgs('Offset'); para.Radius = sArgs('Radius');
            % Gerando o array
            [geo, ~] = gen_geo(type,para); 
            array = geo.cart;
            sz = size(array);
            obj.position('x') = reshape(array(:,1),sz(1),1);
            obj.position('y') = reshape(array(:,2),sz(1),1) + sArgs('H');
            obj.position('z') = reshape(array(:,3),sz(1),1);
            obj.position('H') = sArgs('H');
            if sArgs('Silent') == 0
                fprintf([type ' array generated \n \n'])
                fprintf('Parameters: \n')
                names = sArgs.keys();
                val = sArgs.values();
                for i=1:1:length(sArgs.keys())
                   fprintf([names{i} ' = ' num2str(val{i}) '\n'])
                end
            end
        end
        %%%%%%%%%%% Array origin %%%%%%%%%%%%%%%%%%
        function out = Origin(obj)
            out = containers.Map({'x','y','z'},{mean(obj.position('x')),mean(obj.position('y')),mean(obj.position('z'))});
        end
        %%%%%%%%%%% Number of microphones %%%%%%%%%
        function out = n_mic(obj)
           out = length(obj.position('x')); 
        end
    end
    %%%%%%%%% Plot %%%%%%%%%%%%%%%%%%%
    methods
        function plot(obj)
            if nargin==1
            figure()
            scatter(obj.position('x'),obj.position('y'),'s','MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor',[1 0.4 1],...
                          'LineWidth',3)
            grid on
            xlim([min(obj.position('x'))-1 max(obj.position('x'))+1])
            ylim([min(obj.position('y'))-1 max(obj.position('y'))+1])
            xlabel('X[m]'); ylabel('Y[m]');
            title('Array Geometry')
            arruma_fig('% 2.2f','% 2.2f','virgula')
            end
        end
    end
end
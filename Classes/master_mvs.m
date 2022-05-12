classdef master_mvs<handle
    properties
       time_data = []
       time_vector = []
       freq_data = []
       freq_vector = []
       Fs = 44100;
    end
    %%% Extra functions %%%%
    methods
        %%%%%%%%% Export Audio %%%%%%%%%%
        function ExportAudio(obj,filename)
            if nargin<2
                filename = 'audio.wav';
            end
            audiowrite(filename,(obj.time_data'./max(max(obj.time_data)))*0.8,obj.Fs)
        end
        function varargout = RMS(obj)
            val_rms = rms(obj.time_data,'dim',2);
            if nargout==0
                for i=1:1:length(val_rms)
                   fprintf(['Channel ' num2str(i) ...
                       ' - ' num2str(mag2dbPa(val_rms)) ' dB [pa] rms \n']) 
                end
            else    
                varargout{1} = val_rms;
            end
        end
    end
    %%%%% Plot functions %%%%%%%%%%%%%%%%
    methods
        %%% time plot %%%
        function plot_time(obj,num)
            if nargin<2
                z = size(obj.time_data);
                num = randi(z(1));
            end
            figure()
            plot(obj.time_vector(num,:),obj.time_data(num,:))
            xlabel('Tempo[s]')
            ylabel('Amplitude [-]')
            xlim([obj.time_vector(num,1) obj.time_vector(num,end)])
            arruma_fig('% 2.2f','% 2.3f','virgula')
        end
        %%% time dB plot %%%
        function plot_time_dB(obj,num)
            if nargin<2
                z = size(obj.time_data);
                num = randi(z(1));
            end
            figure()
            plot(obj.time_vector(num,:),20*log10(abs(obj.time_data(num,:))/2e-5))
            xlabel('Tempo[s]')
            ylabel('Amplitude [dB] ref.: 2e-5')
            xlim([obj.time_vector(num,1) obj.time_vector(num,end)])
            arruma_fig('% 2.2f','% 2.1f','virgula')
        end
        %%% freq plot %%%
        function plot_freq(obj,num)
            if nargin<2
                z = size(obj.time_data);
                num = randi(z(1));
            end
           figure()
            semilogx(obj.freq_vector(num,:),20*log10(abs(obj.freq_data(num,:))/(2e-5)))
            xlabel('Frequency [Hz]')
            ylabel('Amplitude [db] ref.: 2e-5')
            xlim([20 obj.Fs/2])
            arruma_fig('% 2.1f','% 2.1f','virgula')
        end
        %%% time-freq plot %%%
        function plot_tf(obj,num)
            if nargin<2
                z = size(obj.time_data);
                num = randi(z(1));
            end
            figure()
            subplot(2,1,1)
            plot(obj.time_vector(num,:),obj.time_data(num,:))
            xlabel('Tempo[s]')
            ylabel('Amplitude [-]')
            xlim([obj.time_vector(num,1) obj.time_vector(num,end)])
            subplot(2,1,2)
            semilogx(obj.freq_vector(num,:),20*log10(abs(obj.freq_data(num,:))))
            xlabel('Frequency [Hz]')
            ylabel('Amplitude [-]')
            arruma_fig('% 2.2f','% 2.2f','virgula')
            xlim([20 obj.Fs/2])
        end
        %%% Spectrogram plot %%%
        function plot_spec(obj,num,arg1,val1,arg2,val2)
            %Optional Inputs
            % WLen - Window Length
            % Overlap-
            % FRange - 
            % dF - 
            WLen = 2048; Overlap = 0.75; dF = WLen/obj.Fs; 
            if nargin>2; eval([arg1 '=[' num2str(val1) '];']); end
            if nargin>4; eval([arg2 '=[' num2str(val2) '];']); end
            if nargin>6; eval([arg3 '=[' num2str(val3) '];']); end
            if nargin>8; eval([arg4 '=[' num2str(val4) '];']); end
            NFFT = obj.Fs*dF;
            
            figure()
                spectrogram(obj.time_data(num,:),hann(WLen),round(WLen*Overlap),NFFT,obj.Fs,'yaxis')
                title(['Spectrogram ' 'Window Length = ' num2str(WLen)  ' Overlap = ' num2str(Overlap) ])
        end
    end
    % GET functions
     methods
        %%%%% Time vector %%%%
        function a = get.time_vector(obj)
            if nargin==1
                z = size(obj.time_data);
                if z(1)>1
                    for i=1:1:z(1)
                        a(i,:)= linspace(0, length(obj.time_data(i,:))/obj.Fs, length(obj.time_data(i,:)));
                    end
                else
                    a = linspace(0, length(obj.time_data)/obj.Fs, length(obj.time_data));
                end
            
            else
                a = obj.time_vector;
            end
        end
        %%%%% Freq data %%%%%%
        function f = get.freq_data(obj)
            z = size(obj.time_data);
            if z(1)>1
                for i=1:1:z(1)
                    [f(i,:) ,~] = get_fft(obj.time_data(i,:),'Fs',obj.Fs);
                end
            else    
                [f ,~] = get_fft(obj.time_data,'Fs',obj.Fs);
            end
        end
        %%%%% Freq vector %%%%
        function f_v = get.freq_vector(obj)
            z = size(obj.time_data);
            if z(1)>1
                for i=1:1:z(1)
                    [~,f_v(i,:)] = get_fft(obj.time_data(i,:),'Fs',obj.Fs);
                end
            else 
                [~,f_v] = get_fft(obj.time_data,'Fs',obj.Fs);
            end
        end
     end
end


function varargout = get_fft(time,varargin)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Default inputs
    sz = size(time);
    sArgs = containers.Map({'NFFT','Fs','Normalized'},...
        {sz(2),44100,1});
    % Applying optional inputs
    for i=1:2:length(varargin)
        sArgs(varargin{i}) = varargin{i+1};
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f = fft(time,sArgs('NFFT'),2);
    sz = size(f);
    if sArgs('Normalized') == 1
       f = f./sz(2); 
    end
    if mod(length(f),2) ==0
        f = f(:,1:(sArgs('NFFT')/2));
    else    
        f = f(:,1:floor(sArgs('NFFT')/2)+1);
    end
    sz = size(f);
    f_v = linspace(0,floor(sArgs('Fs')/2),sz(2));   
    %%%%%%%%%%%%% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargout == 0
        figure()
        semilogx(f_v,mag2dbPa(abs(f)))
        xlabel('Frequency [Hz]')
        ylabel('Amplitude [db] ref.: 2e-5')
        xlim([min(f_v) max(f_v)])
        arruma_fig('%2.2f','%2.2f','virgula')
    end
    if nargout>0
        varargout{1} = f;
    end
    if nargout>1
        varargout{2} = f_v;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


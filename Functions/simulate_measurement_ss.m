function varargout = simulate_measurement_ss(sources,...
                                   microphone, time,fs)                              
%% Default values
n_sources = length(sources);
n_mic = length(microphone.position('x'));
%%
x_mic = microphone.position('x');
y_mic = microphone.position('y');
z_mic = microphone.position('z');
for j=1:1:n_sources
    source = sources{j};
    source_data = sources{j}.CreateAudio('T',time,'Fs',fs);
    for i=1:1:n_mic
        %% Distance between the source and the microphone in the space 7 
            s = source_data.time_data(1,:);
            R = sqrt(source.position('z')^2 + (source.position('y') - y_mic(i))^2 + (source.position('x') - x_mic(i)).^2);
            p = s./(4*pi*R);
            t = source_data.time_vector(1,:);
            t_ray = R/343;
            t_delay = t+t_ray;
            t_int = linspace(t(1)+1,t(end)-1,(t(end)-2)*44100);
           if j==1
                P(i,:) = interp1(t_delay,p,t_int);
           else
                P(i,:) = interp1(t_delay,p,t_int)+ P(i,:);   
           end
     end
end
%%
if nargout == 1
   out1 = SAudio;
   out1.time_data = P;
   out1.Fs = fs;
   varargout{1} = out1;
end

%%
end


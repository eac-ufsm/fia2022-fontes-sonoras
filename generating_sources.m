clear all; close all; clc;
%% Creating Array

sound_source = Source('x',0.5,'y',1.7,'z',5,'Freq',3000,'Amp',40);
audio = sound_source.CreateAudio('T',4,'Fs', 44100);

audio.plot_time()

audio.plot_freq()
%%
sound_source = Source('x',0.5,'y',1.7,'z',5,'Amp', 20,'Freq',3000, 'Noise', 10);
audio = sound_source.CreateAudio('T',4,'Fs', 44100);

audio.plot_time()

audio.plot_freq()
%%
sound_source = Source('x',0.5,'y',1.7,'z',5,'Amp', 10,'Freq',0, 'FilterNoise', [100, 200]);
audio = sound_source.CreateAudio('T',4,'Fs', 44100);

audio.plot_time()

audio.plot_freq()
%%
sound_source = Source('x',0.5,'y',1.7,'z',5,'Amp', 10,'LoadAudio', 'audio.wav');
audio = sound_source.CreateAudio('T',4,'Fs', 44100);

audio.plot_time()

audio.plot_freq()
%%
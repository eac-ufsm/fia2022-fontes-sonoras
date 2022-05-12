clear all; close all; clc;
%% Creating Array

array = MicArray;
array.GenerateArray('spiral','H',1,'Silent',1)

array.plot()
%% Creating sources

f_sim = 500;
d_sim = 20;
x_initial = -22;
x_final = 22;
t_initial = 0;
t_final = 3;

sources = {};
%sources{1} = Source('x',1,'y',1,'Amp',63,'Freq', f_sim);
%sources{2} = Source('x',1,'y',1,'Amp',63,'Freq', 1500);
sources{1} = Source('x',0.5,'y',1.7,'z',5,'Amp', 10,'LoadAudio', 'audio.wav');

%% Creating Trajectory of sources
    
time_vector = [t_initial t_final];
sources_trajectory = ...
    Trajectory(time_vector,'x',[x_initial x_final],'z',[d_sim,d_sim]); 
vel = sources_trajectory.dV();
%%
%%% adjusting interp simulation
[simulation, sources, simulated_traj] = ....
 simulate_measurement_mvs(sources, array, sources_trajectory,'Noise',100);
%%
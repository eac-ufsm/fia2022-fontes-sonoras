clear all; close all;
%% Criando as fontes sonoras

distance_from_array = 5;

S1 = Source('x',0.5,'y',1.7,'z',distance_from_array,'Freq',3000,'Amp',40);

S2 = Source('x',-0.5,'y',1.2,'z',distance_from_array,'Freq',2000,'Amp',38);
%% Gerando o array para a simulação
    
microphones = MicArray;
microphones.GenerateArray('spiral','H',1.2)

% M.plot
%% Simulando medição das fontes sonoras 

%%% Selecionando as fontes
sources = {S1, S2};

%%% Rodando a simulação
simulation = simulate_measurement_ss(sources,microphones,10,44100);
%%
simulation.plot_freq(1)
%%
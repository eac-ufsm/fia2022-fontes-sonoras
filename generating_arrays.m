clear all; close all; clc;
%% Creating Array

array = MicArray;
array.GenerateArray('spiral','H',1,'Silent',1)

array.plot()
%%
array = MicArray('x', [-1, 0, 1], 'y', [1, 1.5, 1],'z',[0, 0 ,0]);

array.plot()
%%
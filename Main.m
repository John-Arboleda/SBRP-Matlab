%clc
clear


N_gen = 80;%Número de generaciones
N_indivs = 32;%Número de inidividuos
Buses = 12;%Número de buses
Capacity = 48;%Capacidad de los buses
pX = 1; %Probabilidad de selección
pM = 0.1; %Probabilidad de mutación

[Final_Front] = ...
   NSGA_II(N_gen, N_indivs, Buses, Capacity, pX, pM);


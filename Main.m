clc
clear


N_gen = 20;%Número de generaciones
N_indivs = 128;%Número de inidividuos
Buses = 12;%Número de buses
Capacity = 48;%Capacidad de los buses
pX = 1; %Probabilidad de selección
pM = 0.1; %Probabilidad de mutación

[individuo_elite, Obj] = ...
   NSGA_II(N_gen, N_indivs, Buses, Capacity, pX, pM);


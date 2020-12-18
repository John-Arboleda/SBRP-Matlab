function [individuo_elite, Obj] = NSGA_II(N_gen, N_indivs, Buses, Capacity, pX, pM)
tic

%población inicial con N_indivs con rutas cuyos nodos satisfacen la
%restricción de capacidad
[initPop] = NSGA_ParentGen0(N_indivs, Buses, Capacity);

%Cálculo del costo por ruta por inidividuo
[evaluatedInitPop] = NSGA_Evaluate(initPop, N_indivs, Buses);

%Ránking de los índividuos de menor costo
[rankedInitPop] = NSGA_Rank(evaluatedInitPop);

for n = 1:N_gen
    Pairs = NSGA_Tournament(1:N_indivs, N_indivs/2);

    
    
end

toc
end
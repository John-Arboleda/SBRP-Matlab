function [individuo_elite, Obj] = NSGA_II(N_gen, N_indivs, Buses, Capacity, pX, pM)
tic

%población inicial con N_indivs con rutas cuyos nodos satisfacen la
    %restricción de capacidad
[initPop] = NSGA_ParentGen0(N_indivs, Buses, Capacity);

%Cálculo del costo por ruta por inidividuo
[evaluatedInitPop] = NSGA_Evaluate(initPop, N_indivs, Buses);

%Ranking de los índividuos de menor costo
[rankedPop] = NSGA_Rank(evaluatedInitPop);

fprintf( 'Parent generation 0\n');
toc

for n = 1:N_gen
    
    [Pairs] = NSGA_Tournament(1:N_indivs, N_indivs/2);

    [childPop] = NSGA_SBX(rankedPop, Pairs, Buses, N_indivs, Capacity);
    
    [evaluatedChildPop] = NSGA_Evaluate(childPop, N_indivs, Buses);
    
    [rankedParentChild] = NSGA_Rank([rankedPop, evaluatedChildPop]);
    
    [rankedPop] = rankedParentChild(1:N_indivs);
    
    fprintf( 'generation %d\n', n);
    
    toc
end

individuo_elite = rankedPop(1).Individuo;
Obj = rankedPop(1).costoTotal

toc
end
function [rankedPop] = NSGA_II(N_gen, N_indivs, Buses, Capacity, pX, pM)
tic

%población inicial con N_indivs con rutas cuyos nodos satisfacen la
    %restricción de capacidad
[initPop] = NSGA_ParentGen0(N_indivs, Buses, Capacity);

%Cálculo del costo por ruta por inidividuo
[evaluatedInitPop] = NSGA_Evaluate(initPop, N_indivs, Buses);

%Ranking de los índividuos de menor costo
[initRankedPop] = NSGA_Rank(evaluatedInitPop, N_indivs, Capacity);

rankedPop = initRankedPop;

fprintf( 'Parent generation 0\n');

toc

for n = 1:N_gen
    %Elige parejas de aleatorias entre los individuos de la población
    [Pairs] = NSGA_Tournament(1:N_indivs, N_indivs/2,pX);
    %Cruce entre las parejas, crea una población de hijos
    [childPop] = NSGA_SBX(rankedPop, Pairs, Buses, N_indivs, Capacity, n);
    %Muta la población de hijos
    [mutPop,~] = NSGA_Mutate(childPop, N_indivs, Buses, Capacity, pM); 
    %Evalúa la población de hijos
    [evaluatedChildPop] = NSGA_Evaluate(mutPop, N_indivs, Buses);
    %ranking de los padres y los hijos
    [rankedParentChild] = NSGA_Rank([rankedPop, evaluatedChildPop], N_indivs*2, Capacity);
    %mejores N individuos del ranking 
    [rankedPop] = rankedParentChild(1:N_indivs);
    
    fprintf( 'generation %d\n', n);
    
    toc
end

%individuo_elite = rankedPop(1).Individuo;
%Obj = rankedPop(1).CostoTotal

toc
end
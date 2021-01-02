%load sbx_prueba1.mat

function [childPop] = NSGA_SBX(rankedPop, Pairs, Buses, N_indivs, Capacity, N_gen)

%Inicializa chilPop
childPop = makeEmptyPop(N_indivs, Buses);

%Array con todos los nodos y su demanda
allNodes = vertcat(rankedPop(1).Individuo.Ruta);

for c = 1:length(Pairs)
   %Cruza parte superior de un padre con la parte inferior del otro
   %Genera dos hijos
   child_1 = [rankedPop(Pairs(c,1)).Individuo(1:6), rankedPop(Pairs(c,2)).Individuo(7:12)];
   child_2 = [rankedPop(Pairs(c,2)).Individuo(1:6), rankedPop(Pairs(c,1)).Individuo(7:12)];
   %Array con los nodos de cada hijo
   child_1_nodes = vertcat(child_1.Ruta);
   child_2_nodes = vertcat(child_2.Ruta);
   %Identifica nodos faltantes en cada hijo
   missing_child_1 = setdiff(allNodes, unique(child_1_nodes, 'rows'), 'rows');
   missing_child_2 = setdiff(allNodes, unique(child_2_nodes, 'rows'), 'rows');
   %Elimina nodos repetidos de cada hijo 
   %Los faltantes de un hijo son los repetidos del otro
   child_1 = deleteRepeated(child_1,missing_child_2,N_gen,Buses);
   child_2 = deleteRepeated(child_2,missing_child_1,N_gen,Buses);
   %Añadir nodos faltantes a cada hijo
   child_1 = chooseNodes(child_1,missing_child_1,Buses,Capacity);
   child_2 = chooseNodes(child_2,missing_child_2,Buses,Capacity);
   %Agregar hijos a la población de hijos
   childPop(2*c-1).Individuo = child_1;
   childPop(2*c).Individuo = child_2;
end

    %Retorna hijo actualizado sin nodos repetidos
    %Selecciona que rutas actualizar de forma alternativa con la generación
    function childAct = deleteRepeated(child,missing,Ngen,nBuses)
        childAct = child;
        %selecciona en que parte del individuo reconstruir, inferior o superior
        if mod(Ngen, 2) == 0 
            sec = (nBuses/2+1):nBuses;
        else
            sec = 1:nBuses/2;
        end
        %Actualiza Ruta, ocupación y elimina el costo de la ruta
        for b = sec
           childAct(b).Ruta = deleteNodes(childAct(b).Ruta, missing);
           childAct(b).Ocupacion = sum(childAct(b).Ruta(:,2));
           childAct(b).Costo = 0;
        end      
    end

    function incompleteRoute = deleteNodes(aRoute, repNodes)
        %Elimina nodos de una ruta que conincidan con repNodes
        %Retorna ruta incompleta
        logRep = logical(sum(aRoute(:,1) == repNodes(:,1)',2));
        aRoute(logRep,:) = [];
        incompleteRoute = aRoute;
    end
    
end
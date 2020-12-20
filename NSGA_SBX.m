%load sbx_prueba1.mat

function [childPop] = NSGA_SBX(rankedPop, Pairs, Buses, N_indivs, Capacity)

%Pairs = [1 2; 3 4; 5 6; 7 8];

childPop = makeEmptyPop(N_indivs, Buses);

allNodes = vertcat(rankedPop(1).Individuo.Ruta);

for c = 1:length(Pairs)
   child_1 = [rankedPop(Pairs(c,1)).Individuo(1:6), rankedPop(Pairs(c,2)).Individuo(7:12)];
   child_2 = [rankedPop(Pairs(c,2)).Individuo(1:6), rankedPop(Pairs(c,1)).Individuo(7:12)];
   child_1_nodes = vertcat(child_1.Ruta);
   child_2_nodes = vertcat(child_2.Ruta);
   missing_child_1 = setdiff(allNodes, unique(child_1_nodes, 'rows'), 'rows');
   missing_child_2 = setdiff(allNodes, unique(child_2_nodes, 'rows'), 'rows');
   for b = 1:Buses/2
       child_1(b).Ruta = deleteNodes(child_1(b).Ruta, missing_child_2);
       child_1(b).Ocupacion = sum(child_1(b).Ruta(:,2));
       child_1(b).Costo = 0;
       child_2(b).Ruta = deleteNodes(child_2(b).Ruta, missing_child_1);
       child_2(b).Ocupacion = sum(child_2(b).Ruta(:,2));
       child_2(b).Costo = 0;
   end
   childPop(2*c-1).Individuo = child_1 ;
   childPop(2*c-1).Individuo ...
    = chooseNodes(childPop(2*c-1).Individuo, missing_child_1, Buses, Capacity);
   childPop(2*c).Individuo = child_2 ;
  childPop(2*c).Individuo ...
    = chooseNodes(childPop(2*c).Individuo, missing_child_2, Buses, Capacity);
end


    function incompleteChild = deleteNodes (aRoute, repNodes)
        logRep = logical(sum(aRoute(:,1) == repNodes(:,1)',2));
        aRoute(logRep,:) = [];
        incompleteChild = aRoute;
    end
    
    

%      function childIndiv = actualizeOcc (Indiv, nBuses)
%         for n = 1:Buses
%             Indiv(n).Ruta(:,2)
%         end
%      
%      end
end
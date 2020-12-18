%Ordena los individuos según su costo
function [rankedInitPop] = NSGA_Rank(evaluatedInitPop)

%Es necesario convertir la estructura a tabla para ordenar por costoTotal
rankedInitPop = struct2table(evaluatedInitPop);
rankedInitPop = sortrows(rankedInitPop,'costoTotal');
rankedInitPop = table2struct(rankedInitPop);

end
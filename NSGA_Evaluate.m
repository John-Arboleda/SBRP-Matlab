%Mejora el ruteo de la asignación de la generación inicial
    %Cálcula el costo de la ruta

%Input
%InitPop(struct) = Población inicial
%N_indivs(integer) = Número de inidividuos
%Buses(integer) = Número de buses

%Return
%evaluatedInitPop = Población con rutas mejoradas, costo de cada ruta por
    %inidividuo

function [evaluatedInitPop] = NSGA_Evaluate(InitPop, N_indivs, Buses)
    %Inicializa población evaluada
    evaluatedInitPop = InitPop;

    for j = 1:N_indivs % Para cada inididuos
        %Mejora el ruteo y calcula costo de ruta
        evaluatedInitPop(j).Individuo = totalRouting(evaluatedInitPop(j).Individuo, Buses);
        %Costo de cada individuo
        evaluatedInitPop(j).costoTotal = sum([evaluatedInitPop(j).Individuo.Costo]);
    end

    
    function newRouting = totalRouting(aIndiv, nBuses)
        %Mejora el ruteo de cada bus de un individuo
        %Cálcula costo de ruta
        %Retorna individuo actualizado con costos y ruteo
        for m = 1:nBuses
            [aIndiv(m).Ruta, aIndiv(m).Costo] = Routing(aIndiv(m).Ruta,m,nBuses,20);
        end
        newRouting = aIndiv;
    end

%     function totalCost = costIndiv(aIndiv, nBuses)
%         for r = 1:nBuses
%             totalCost(r,1) = costoRuta(aIndiv(r).Ruta,r,nBuses);
%         end
%     end
end
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
        evaluatedInitPop(j).CostoTotal = sum([evaluatedInitPop(j).Individuo.Costo]);
        %Variación distancia de recorrido
        evaluatedInitPop(j).VarDistance = std([evaluatedInitPop(j).Individuo.Costo]);
        %Variación número de estudiantes
        evaluatedInitPop(j).VarStudents = std([evaluatedInitPop(j).Individuo.Ocupacion]);
        %Variación número de paradas
        evaluatedInitPop(j).VarNodes = std(cellfun(@length, {evaluatedInitPop(j).Individuo.Ruta}));
    end
    
    function newRouting = totalRouting(aIndiv, nBuses)
        %Mejora el ruteo de cada bus de un individuo
        %Cálcula costo de ruta
        %Retorna individuo actualizado con costos y ruteo
        for m = 1:nBuses
            [aIndiv(m).Ruta, aIndiv(m).Costo] = Routing(aIndiv(m).Ruta,m,nBuses);
        end
        newRouting = aIndiv;
    end

end
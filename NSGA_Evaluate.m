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

    load dis.mat d %Carga distancias d(matrix)

    % matriz de distancia de los buses a las ciudades.
    dB = d(1:Buses,Buses+1:length(d(1,:))); 

    % distancia de ciudad a ciudad y el deposito.
    dC = d(Buses+1:length(d(:,1)),Buses+1:length(d(1,:))); 

    %Inicializa población evaluada
    evaluatedInitPop = InitPop;

    for j = 1:N_indivs % Para cada inididuos
        %Ruteo por bus de cada individuo
        evaluatedInitPop(j).Individuo = totalRouting(evaluatedInitPop(j).Individuo,Buses,dB,dC);
        %Calcula costo de ruta
        evaluatedInitPop(j).Individuo = totalCost(evaluatedInitPop(j).Individuo,Buses,dB,dC);
        %Costo de cada individuo
        evaluatedInitPop(j).ObjVals(1) = sum([evaluatedInitPop(j).Individuo.Costo]);
%         evaluatedInitPop(j).CostoTotal = sum([evaluatedInitPop(j).Individuo.Costo]);
%         %Variación distancia de recorrido
        evaluatedInitPop(j).ObjVals(2) = max([evaluatedInitPop(j).Individuo.Costo]);
%         evaluatedInitPop(j).VarDistance = std([evaluatedInitPop(j).Individuo.Costo]);
%         %Variación número de estudiantes
        evaluatedInitPop(j).ObjVals(3) = std([evaluatedInitPop(j).Individuo.Ocupacion]);
%         evaluatedInitPop(j).VarStudents = std([evaluatedInitPop(j).Individuo.Ocupacion]);
%         %Variación número de paradas
        evaluatedInitPop(j).ObjVals(4) = std(cellfun(@length, {evaluatedInitPop(j).Individuo.Ruta}));
%         evaluatedInitPop(j).VarNodes = std(cellfun(@length, {evaluatedInitPop(j).Individuo.Ruta}));
    end
    
    function newRouting = totalRouting(aIndiv, nBuses, DB, DC)
        %Mejora el ruteo de cada bus de un individuo
        newRouting = aIndiv;
        for m = 1:nBuses
            if ~isempty(newRouting(m).Ruta)
                newRouting(m).Ruta = Routing(newRouting(m).Ruta,m,DB,DC);
            end
        end   
    end
    
    function newCost = totalCost(aIndiv, nBuses, DB, DC)
        %Cálcula costo de ruta
        %Retorna individuo actualizado con costos de cada ruta
        for m = 1:nBuses
            %aIndiv(m).Ruta = Routing(aIndiv(m).Ruta,m,nBuses);
            if ~isempty(aIndiv(m).Ruta)
                aIndiv(m).Costo = costoRuta(aIndiv(m).Ruta(:,1),m,DB,DC);
            end
        end
        newCost = aIndiv;
    end

end
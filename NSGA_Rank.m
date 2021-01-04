%Ranking de los individuos de acuerdo al número de restricciones que
%no cumple, frontera de pareto y crowd distance
function [rankedPop] = NSGA_Rank(evaluatedPop, N_indivs, Capacity)

rankedPop = evaluatedPop;
%Inicializa individuos de la generación anterior
[rankedPop.Viols] = deal(0);
[rankedPop.N_Front] = deal(0);
[rankedPop.CrowdDist] = deal(0);

%% Violación a las restricciones

%Penaliza los individuos que han excedido la restricción de capacidad
rankedPop = ConsViols(rankedPop,N_indivs,Capacity);

%% Frentes de Pareto

%Valores objetivo de todos los individuos de la población
allObjVals = vertcat(rankedPop.ObjVals);

%Matriz de dominancia
%sean filas i, columnas j
%las filas son los individuos j a los que i domina
%las columnas son los individuos i que dominan a j
DomMat = makeDomMat(allObjVals,N_indivs);

%Población actualizada con frentes de pareto
rankedPop = createFronts(rankedPop,DomMat);

%% Crowd Distance
%Calcula cercanía estandarizada de los individuos en cada valor objetivo
rankedPop = calCrowd(rankedPop,allObjVals,N_indivs);

%% Ranking
%Es necesario convertir la estructura a tabla para ordenar por costoTotal
rankedPop = struct2table(rankedPop);
rankedPop = sortrows(rankedPop,{'Viols','N_Front','CrowdDist'});
rankedPop = table2struct(rankedPop)';

%%
    function violsPop = ConsViols(Pop,nIndivs,Cap)
    %Retorna población actualizada con la magnitud de la suma del sobrecupo
    %de las rutas del individuo
        violsPop = Pop;
        for in = 1:nIndivs
            allOcc = [violsPop(in).Individuo.Ocupacion];
            logCap = allOcc > Cap;
            violsPop(in).Viols = sum(allOcc(logCap) - Cap);
        end  
    end

    function paretoPop = setPareto(Pop,f_ind,p_front)
    %Retorna población actualizada con una frontera p_front
    %Asigna el número de la frontera de pareto (p_front) a cada
        %individuo f_ind
        paretoPop = Pop;
        for f = f_ind
            paretoPop(f).N_Front = p_front;
        end
    end

    function domMat = makeDomMat(ObjVals,nIndivs)
    %establece la dominancia entre los individuosde la población
    %retorna matriz lógica con columnas de los individuos dominados y
        %filas de los individuos a quienes domina
        domMat = zeros(nIndivs);
        for i = 1:nIndivs
            %Valores objetivos de i
            D = ObjVals(i,:);
            %Condición de dominancia
            logDom = prod(D <= ObjVals,2) & sum(D < ObjVals,2);
            domMat(i,:) = logDom';
        end
    end

    function frontPop = createFronts(Pop,domMat)
    %Según la matriz de dominancia, establece las fronteras de pareto para
        %los inidividuos de la población
    %Retorna población actualizadas con todas las fronteras de pareto
        frontPop = Pop;
        min_dom = 0;%Dominaciones a individuos menos dominados
        N_front = 1;%Frontera actual
        set_inds = [];%individuos con frontera asignada
        while min_dom ~= inf
            %Número de individuos por quien es dominado
            N_dominated_by = sum(domMat,1);
            %Filtro para los nodos asignados a fronteras superiores
            N_dominated_by(set_inds) = inf;
            %Filtro para Individuos menos dominados
            min_dom = min(N_dominated_by);
            if min_dom ~= inf %no asigna si ya se han asignado toas las fronteras
                %Individuos elegidos para la frontera actual
                front_ind = find(N_dominated_by == min_dom);
                %Establecer fronteras en estructura de población
                frontPop = setPareto(frontPop,front_ind,N_front);
                set_inds = [set_inds,front_ind];
                %Elimina dominación para individuos de fronteras inferiores
                domMat(set_inds,:) = 0;
                N_front = N_front + 1;
            end
        end
    end

    function crowdPop = calCrowd(Pop,ObjVals,nIndivs)
        crowdPop = Pop;
        for n = 1:length(ObjVals(1,:))
          [ObjValsSorted, SortIdx] = sort(ObjVals( :, n));
          % individuals w/ extreme objective function values are assigned a negative
          % infinite crowding distance so that their rank is always lower than the rank
          % of other individuals which are otherwise of the same rank (same degree of
          % constraint violation; same Pareto-Front)
          crowdPop(SortIdx( 1)).CrowdDist = -inf;
          crowdPop(SortIdx(nIndivs)).CrowdDist = -inf;
          for j = 2:(nIndivs - 1)
            %%% introduced normalization by the absolute range of the 
            %%% objective function; a range of [0 1] is equivalent to no normalization
            % add negative of the distance between the nearest other two individuals
            % to the overall crowding distance
              crowdPop(SortIdx( j)).CrowdDist = crowdPop(SortIdx( j)).CrowdDist - ...
              (ObjValsSorted( j + 1) - ObjValsSorted( j - 1)) / ...
              (ObjValsSorted(nIndivs) - ObjValsSorted(1));
          end
        end
    end

end
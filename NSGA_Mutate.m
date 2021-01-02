%INPUT
%Pop(struct) = Población
%N_indivs(integer) = número de individuos
%Buses(integer) = Número de buses
%Capacity(integer)
%pM(double) = Probabilidad de mutación

%RETURN
%MutPop(struct) = Población con individuos mutados
%SelMut(array) = lista de individuos mutados

%Reasigna los nodos más alejados de cada bus al bus más cercano con cupo
    %disponible.
%Los individuos son escogidos de forma aleatoria de acuerdo a la probabilidad 
    %de mutación
function [MutPop,selMut] = NSGA_Mutate(Pop, N_indivs, Buses, Capacity, pM)

load dis.mat d %Carga distancias d(matrix)

% matriz de distancia de los buses a las ciudades.
dB = d(1:Buses,Buses+1:end); 
clear d

%Inicializa MutPop
MutPop = Pop;

%Indices de los individuos seleccionados a mutar
selMut = find(rand(1,N_indivs) < pM);

for i = 1:length(selMut)
    m = selMut(i);
    %Extrae nodos más alejados de cada individuo seleccionado para mutar
    [MutPop(m).Individuo,maxNodes] = extrNodes(MutPop(m).Individuo,Buses,dB);
    %Reasigna los nodos de acuerdo a su cercanía a cada bus
    MutPop(m).Individuo = addNodes(MutPop(m).Individuo, maxNodes, Capacity, dB);   
end

    %extrae nodos más lejanos de cada bus de un individuo
    %retorna el individuo sin los nodos y un array con los nodos y su demanda
    function [extIndiv,arrNodes] = extrNodes(Indiv,buses,DB)
        extIndiv = Indiv;
        arrNodes = [];
        for j = 1:buses
            if ~isempty(Indiv(j).Ruta)
                %Indice de nodo más alejado de un bus
                [~,indMax] = max(DB(j,Indiv(j).Ruta(:,1)));
                %Concatenar y extraer el nodo
                node = extIndiv(j).Ruta(indMax,:);
                arrNodes = [arrNodes; node];
                %Eliminar nodo de la ruta
                extIndiv(j).Ruta(indMax,:) = [];
                %Descontar la demanda del nodo extraido de ocupación
                extIndiv(j).Ocupacion = extIndiv(j).Ocupacion - node(2);
            end
        end
    end
    %Agrega los nodos al bus más cercano con su demanda
    %retorna individuo con nuevos nodos
    function addIndiv = addNodes(Indiv,m_Nodes,cap,DB)
        n_x_a = m_Nodes;
        addIndiv = Indiv;
        while ~isempty(n_x_a)
            %Cupo de cada bus
            cupo = cap - [addIndiv.Ocupacion];
            %demandas que no exceden el cupo
            dem_x_cupo = cupo' >= n_x_a(:,2)';
            %Distancia de los buses a los nodos por asignar
            dBMAx = DB(:,n_x_a(:,1));
            %Filtra distancias de nodos que exceden el cupo
            resCap = dBMAx.*dem_x_cupo;
            resCap(resCap <= 0) = inf;
            %indice del bus con el nodo más cercano
            [~,bus] = min(min(resCap,[],2));
            %indice del nodo más cercano al bus escogido
            [~,indNodo] = min(dBMAx(bus,:));
            nodo = n_x_a(indNodo,1);
            dem = n_x_a(indNodo,2);
            %asignar nodo al bus elegido con su demanda
            addIndiv = asignarNodo(addIndiv, bus, nodo, dem);
            n_x_a(indNodo,:) = [];
        end
    end

end
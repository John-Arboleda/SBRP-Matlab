%INPUT
    %Indiv(struct) = Individuo con nodos faltantes
    %arrN(array) = nodos con demanda
    %Buses(integer) = número de buses
    %Capacity(integer) = capacidad de los buses
%RETURN
    %IndivNode(struct) = Individuo con nodos asignados

function IndivNode = chooseNodes(Indiv, arrN, Buses, Capacity)
    load dis.mat d %Carga distancias d(matrix)

    % matriz de distancia de los buses a las ciudades.
    dB = d(1:Buses,Buses+1:end); 
    clear d
    %inicializa nodos por asignar
    nodos_x_asignar = arrN;
    %inicializa individuo de retorno
    IndivNode = Indiv;
    
    while ~isempty(nodos_x_asignar)
        %Aleatoriamente elege un bus que tenga capacidad disponible
        [busElegido, cupo] = chooseBus(IndivNode, Buses, Capacity);
        %Busca el nodo con la mínima distancia al bus elegido
        [~, indMin] = min(dB(busElegido, nodos_x_asignar(:,1)));
        demNodo = nodos_x_asignar(indMin,2); %Buscar la demanda del nodo
        %Si el nodo más cercano no supera el cupo disponible
        if demNodo <= cupo
            %Asigne el nodo al bus elegido
            IndivNode = asignarNodo(IndivNode,busElegido,nodos_x_asignar(indMin),demNodo);
            nodos_x_asignar(indMin,:) = [];
        end
    end
    
end
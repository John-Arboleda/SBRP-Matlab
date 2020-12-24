function IndivNode = chooseNodes(Indiv, arrN, Buses, Capacity)
    load dis.mat d %Carga distancias d(matrix)

    % matriz de distancia de los buses a las ciudades.
    dB = d(1:Buses,Buses+1:end); 
    clear d
    
    nodos_x_asignar = arrN;
    
    while ~isempty(nodos_x_asignar)
    %for i = 1:length(nodos_x_asignar) %Para cada nodo del problema
        %Aleatoriamente elege un bus que tenga capacidad disponible
        [busElegido, cupo] = chooseBus(Indiv, Buses, Capacity);
        %if nodos_x_asignar(i) ~= 1 %diferente del depósito
        [nodeMin, indMin] = min(dB(busElegido, nodos_x_asignar(:,1)));
        demNodo = nodos_x_asignar(indMin,2); %Buscar la demanda del nodo
        %Aleatoriamente elege un bus que tenga capacidad disponible
        %[busElegido, cupo] = chooseBus(Indiv, Buses, demNodo, Capacity);
        if demNodo <= cupo
            %Asigne el nodo al bus elegido
            Indiv = asignarNodo(Indiv,busElegido,nodos_x_asignar(indMin),demNodo);
            nodos_x_asignar(indMin,:) = [];
        end
    end
    IndivNode = Indiv;
end
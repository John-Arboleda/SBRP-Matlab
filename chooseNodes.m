function IndivNode = chooseNodes(Indiv, arrN, Buses, Capacity)
    for i = 1:length(arrN) %Para cada nodo del problema
        if arrN(i) ~= 1 %diferente del depósito
            demNodo = arrN(i,2); %Buscar la demanda del nodo
            %Aleatoriamente elege un bus que tenga capacidad disponible
            busElegido = chooseBus(Indiv, Buses, demNodo, Capacity);
            %Asigne el nodo al bus elegido
            Indiv = asignarNodo(Indiv,busElegido,arrN(i),demNodo);
        end
    end
    IndivNode = Indiv;
end
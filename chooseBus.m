function chosenBus = chooseBus(aIndiv, nBuses, dNodo, cap)
    %Asigna nodos a buses aleatorios respetando la capacidad
    occup = 1000;
    while occup > cap %Si se viola restricción de capacidad busca otro bus
        aBus = randi(nBuses); %Elige un bus al azar
        occup = aIndiv(aBus).Ocupacion + dNodo; % Capacidad con demanda nuevo nodo
    end
    chosenBus = aBus; %Returna bus elegido
end
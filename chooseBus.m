%INPUT
    %aIndiv(struct) = Individuo
    %nBuses(integer) = Número de buses
    %cap(integer) = capacidad

%RETURN
    %chosenBus(integer) = bus elegido
    %cupo(integer) = cupo del bus elegido

function [chosenBus, cupo] = chooseBus(aIndiv, nBuses, cap)
    %Asigna nodos a buses aleatorios respetando la capacidad
    cupo = 0;
    while cupo <= 0 %Si se viola restricción de capacidad busca otro bus
        aBus = randi(nBuses); %Elige un bus al azar
        cupo = cap - aIndiv(aBus).Ocupacion; % Calcula cupo
    end
    chosenBus = aBus; %Returna bus elegido
end
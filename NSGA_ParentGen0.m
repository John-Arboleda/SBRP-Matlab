%Input
%N_indivs(integer) = Número de individuos 
%Buses(integer) = Número de buses
%Capacity(integer) = Capacidad

%Returns
%initPop(struct) = Una estructura con la población inicial y los buses de cada
%inidividuo respetando restricción de capacidad

function [initPop] = NSGA_ParentGen0(N_indivs, Buses, Capacity)

%Carga Problem Workspace(matrix)
load dpro.mat Problem

% Si la capacidad de los vehículos es menor que la demanda máxima de todos los clientes (columna 4 de Problem)
if Capacity<max(Problem(:,4)) 
    fprintf('La Capacidad del vehículo no es Factible\n'); % Imprimame el mensaje.
    return
end

%Inicializa estructura de la población inicial
initPop = makeEmptyPop(N_indivs, Buses);

%Asigna nodos a buses de forma aleatoria
for j = 1:N_indivs %Para cada inidividuo
    %Organiza los nodos del problema en un array aleatorio
    nodoPorAsignar = randperm(length(Problem));
    for i = 1:length(nodoPorAsignar) %Para cada nodo del problema
        if nodoPorAsignar(i) ~= 1 %diferente del depósito
            demNodo = Problem(nodoPorAsignar(i),4); %Buscar la demanda del nodo
            %Aleatoriamente elege un bus que tenga capacidad disponible
            busElegido = chooseBus(initPop(j).Individuo, Buses, demNodo, Capacity);
            %Asigne el nodo al bus elegido
            initPop(j).Individuo = asignarNodo(initPop(j).Individuo,busElegido,nodoPorAsignar(i),demNodo);
        end
    end
    %Inicializa costo total de la ruta
    initPop(j).costoTotal;
end

function emptyPop = makeEmptyPop(N_indi, nBuses)
    %Costruye una estructura inicial según N_inidv y Buses
    m = 1;
    while m <= N_indi
        n = 1;
        while n <= nBuses
            emptyPop(m).Individuo(n).Ruta = [];
            emptyPop(m).Individuo(n).Ocupacion = 0;
            emptyPop(m).Individuo(n).Costo = 0;
            n = n + 1;
        end
        emptyPop(m).costoTotal = 0;
        m = m + 1;
    end
end

function chosenBus = chooseBus(aIndiv, nBuses, dNodo, cap)
    %Asigna nodos a buses aleatorios respetando la capacidad
    occup = 1000;
    while occup > cap %Si se viola restricción de capacidad busca otro bus
        aBus = randi(nBuses); %Elige un bus al azar
        occup = aIndiv(aBus).Ocupacion + dNodo; % Capacidad con demanda nuevo nodo
    end
    chosenBus = aBus; %Returna bus elegido
end

function actualizeIndiv = asignarNodo(aIndiv, cBus, nodo, dem)
    %Asigna el nodo y su demanda al bus elegido
    aIndiv(cBus).Ruta(end + 1,1) = nodo;
    aIndiv(cBus).Ruta(end,2) = dem;
    %Calcula ocupación del bus
    aIndiv(cBus).Ocupacion = aIndiv(cBus).Ocupacion + dem;
    actualizeIndiv = aIndiv; %Retorna estructura individuo actualizado
end

end
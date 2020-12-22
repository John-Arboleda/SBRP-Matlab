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

nodoPorAsignar = Problem(2:end,[1,4]);

%Asigna nodos a buses de forma aleatoria
for j = 1:N_indivs %Para cada inidividuo
    %Organiza los nodos del problema en un array aleatorio
    %nodoPorAsignar = nodoPorAsignar(randperm(length(nodoPorAsignar)),:);
    initPop(j).Individuo ...
        = chooseNodes(initPop(j).Individuo, nodoPorAsignar, Buses, Capacity);
    
%     for i = 1:length(nodoPorAsignar) %Para cada nodo del problema
%         if nodoPorAsignar(i) ~= 1 %diferente del depósito
%             demNodo = nodoPorAsignar(i,2); %Buscar la demanda del nodo
%             %Aleatoriamente elege un bus que tenga capacidad disponible
%             busElegido = chooseBus(initPop(j).Individuo, Buses, demNodo, Capacity);
%             %Asigne el nodo al bus elegido
%             initPop(j).Individuo = asignarNodo(initPop(j).Individuo,busElegido,nodoPorAsignar(i),demNodo);
%         end
%     end
    %Inicializa costo total de la ruta
    %initPop(j).costoTotal;
end

        
end
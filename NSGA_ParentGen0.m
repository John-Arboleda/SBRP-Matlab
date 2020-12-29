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

%Todos los nodos del problema
nodoPorAsignar = Problem(2:end,[1,4]);

for j = 1:N_indivs %Para cada inidividuo
    %Asigna nodos a buses de forma aleatoria
    initPop(j).Individuo ...
        = chooseNodes(initPop(j).Individuo, nodoPorAsignar, Buses, Capacity);
end

        
end
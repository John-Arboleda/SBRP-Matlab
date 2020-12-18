%Retorna una mejor ruta y el costo de dicha ruta
%Realiza permutaciones aleatorias de la ruta y retorna la más económica

%Input
%Route(array) = Nodos asignados con su demanda
%aBus(integer) = Bus asignado
%nBuses(integer) = Número de buses
%iter(integer) = Número de iteracciones aleatorias de la ruta

%Return
%minRoute(array) = Nodos reordenados con su demanda
%cost(double) = Costo de la ruta
function [minRoute, cost] = Routing(Route,aBus,nBuses,iter)

matPer = {}; %Inicializa matrices de permutaciones

for z = 1:iter
    %Genera iter permutaciones aleatorias de la ruta
    newSecuence = randperm(length(Route));
    newRoute = Route(newSecuence,:);
    matPer{z,1} = newRoute;
end

fCost = @(x) costoRuta(x(:,1),aBus,nBuses);
calcCost = cellfun(fCost, matPer);%Calcula el costo de cada permutación
cost = min(calcCost);%Elige el menor costo
minRoute = matPer{calcCost == cost,1};%Elige el ruteo asociado al menor costo

end

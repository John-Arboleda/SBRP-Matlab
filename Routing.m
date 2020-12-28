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
function [newRoute] = Routing(Route,aBus,DB,DC)

arrBus = [];
arrDepot = [];

nodo_x_asignar = Route(:,1);


while ~isempty(nodo_x_asignar)
    %if rand > 0.50000
    if (mod(length(nodo_x_asignar),2)==0)
        if isempty(arrBus)
            [~,node] = min(DB(aBus,nodo_x_asignar));
        else
            [~,node] = min(DC(Route(arrBus(end),1),nodo_x_asignar));
        end
        indB = find(Route(:,1) == nodo_x_asignar(node),1);
        arrBus = [arrBus, indB];
    else
        if isempty(arrDepot)
            [~,node] = min(DC(1,nodo_x_asignar));
        else
            [~,node] = min(DC(Route(arrDepot(end),1),nodo_x_asignar));
        end
        indD = find(Route(:,1) == nodo_x_asignar(node),1);
        arrDepot = [arrDepot, indD];
    end
    nodo_x_asignar(node) = [];
end

newRoute = Route([arrBus, flip(arrDepot)],:);
% 
% oldR = costoRuta(Route,aBus, DB,DC)
% newR = costoRuta(newRoute,aBus, DB,DC)


% for z = 1:iter
%     %Genera iter permutaciones aleatorias de la ruta
%     newSecuence = randperm(length(Route));
%     newRoute = Route(newSecuence,:);
%     matPer{z+1,1} = newRoute;
% end

%fCost = @(x) costoRuta(x(:,1),aBus,nBuses);
% calcCost = cellfun(fCost, matPer);%Calcula el costo de cada permutación
% cost = min(calcCost);%Elige el menor costo
% minRoute = matPer{calcCost == cost,1};%Elige el ruteo asociado al menor costo

end

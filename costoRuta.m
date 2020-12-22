%Costo de la ruta en distnacia
function rutaCost = costoRuta(ruta,aBus,nBuses)


load dis.mat d %Carga distancias d(matrix)

% matriz de distancia de los buses a las ciudades.
dB = d(1:nBuses,nBuses+1:length(d(1,:))); 

% distancia de ciudad a ciudad y el deposito.
dC = d(nBuses+1:length(d(:,1)),nBuses+1:length(d(1,:))); 

%Suma de la distancia entre nodos de la ruta, bus al primer nodo de la
    %ruta, depósito a último nodo de la ruta
rutaCost = disCities(ruta,dC) + dB(aBus,ruta(1)) + dC(ruta(end),1);

function disBetween = disCities(arrRoute, matDis)
    %Retorna suma entre los nodos de una ruta sin tener en cuenta bus y
        %deposito
    disBetween = 0;
    for i = 1:length(arrRoute)-1
        disBetween = disBetween + matDis(arrRoute(i),arrRoute(i+1));
    end
end

end
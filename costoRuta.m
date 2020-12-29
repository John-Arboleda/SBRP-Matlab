%Costo de la ruta en distnacia
function rutaCost = costoRuta(ruta,aBus,dB,dC)

arrDis = [dB(aBus,ruta(1)),disCities(ruta,dC),dC(ruta(end),1)];
%Suma de la distancia entre nodos de la ruta, bus al primer nodo de la
    %ruta, depósito a último nodo de la ruta
rutaCost = sum(arrDis);

function disBetween = disCities(arrRoute, matDis)
    %Retorna suma entre los nodos de una ruta sin tener en cuenta bus y
        %deposito
    disBetween = [];
    for i = 1:length(arrRoute)-1
        disBetween(end + 1) = matDis(arrRoute(i),arrRoute(i+1));
    end
    
end

end
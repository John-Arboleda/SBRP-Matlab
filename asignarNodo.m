%INPUT
    %aIndiv(struct) = Individuo
    %cBus(integer) = Bus elegido
    %nodo(integer) = nodo más cercano
    %dem(integer) = demanda del nodo
%RETURN
    %actualizeIndiv(struct) = Individuo con ruta y ocupación actualizadas
function actualizeIndiv = asignarNodo(aIndiv, cBus, nodo, dem)
    %Asigna el nodo y su demanda al bus elegido
    aIndiv(cBus).Ruta(end + 1,1) = nodo;
    aIndiv(cBus).Ruta(end,2) = dem;
    %Calcula ocupación del bus
    aIndiv(cBus).Ocupacion = aIndiv(cBus).Ocupacion + dem;
    actualizeIndiv = aIndiv; %Retorna estructura individuo actualizado
end

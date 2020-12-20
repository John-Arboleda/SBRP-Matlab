function actualizeIndiv = asignarNodo(aIndiv, cBus, nodo, dem)
    %Asigna el nodo y su demanda al bus elegido
    aIndiv(cBus).Ruta(end + 1,1) = nodo;
    aIndiv(cBus).Ruta(end,2) = dem;
    %Calcula ocupación del bus
    aIndiv(cBus).Ocupacion = aIndiv(cBus).Ocupacion + dem;
    actualizeIndiv = aIndiv; %Retorna estructura individuo actualizado
end

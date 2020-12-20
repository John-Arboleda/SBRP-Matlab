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
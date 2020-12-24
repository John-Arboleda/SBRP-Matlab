function emptyPop = makeEmptyPop(N_indi, nBuses)

    %Costruye una estructura inicial según N_inidv y Buses
    IndivStruct(1,1:nBuses) = struct('Ruta',[],'Ocupacion',0,'Costo',0)';
    emptyPop(1,1:N_indi) = struct('Individuo',IndivStruct,...
        'CostoTotal',0,'VarDistance',0,'VarStudents',0,'VarNodes',0)';

end
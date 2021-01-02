%Ranking de los individuos de acuerdo al número de restricciones que
%viola, frontera de pareto y crowd distance
function [rankedPop] = NSGA_Rank(evaluatedPop, N_indivs, Capacity)

rankedPop = evaluatedPop;

%
for in = 1:N_indivs
    allOcc = [rankedPop(in).Individuo.Ocupacion];
    logCap = allOcc > Capacity;
    rankedPop(in).Viols = sum(allOcc(logCap) - Capacity);
end




allObjVals = vertcat(evaluatedPop.ObjVals);
Dominated = {[]};
NmbOfDominating = zeros(N_indivs,1);

% Pareto-optimal fronts
Front = {[]};
% number of Pareto-optimal front for each individual; 2nd highest priority sorting key



[rankedPop.N_Front] = deal([]);
[rankedPop.CrowdDist] = deal(0);


for i = 1:N_indivs
    D = allObjVals(i,:);
    logDom = prod(D <= allObjVals,2) & sum(D < allObjVals,2);
    Dominated{i,1} = find(logDom);
    NmbOfDominating(i,1) = sum(~sum(D < allObjVals,2))-1;
    if NmbOfDominating(i,1) == 0 % si p nunca fue dominada establecer en frontera de pareto 1
        rankedPop(i).N_Front = 1;
        Front{1}(end + 1) = i;
    end
end
m = 1;
while sum(NmbOfDominating) > 0%Si la frontera i no tiene elementos
  NextFront = [];
  for k = 1:length( Front{m})%num indivs de la frontera i
    p = Front{m}( k);%indiv k de la frontera i
    for l = 1:length( Dominated{ p})%num indivs dominados por indiv k
      q = Dominated{p}( l);%restar 1 a cada individuo l dominado por k 
      NmbOfDominating(q) = NmbOfDominating(q) - 1;
      if NmbOfDominating(q) == 0
        rankedPop(q).N_Front = m + 1;
        NextFront(end + 1) = q;
      end
    end
  end
  if ~isempty(NextFront)
    m = m + 1;
    Front{end + 1} = NextFront;
  else
    minFront = min(NmbOfDominating(NmbOfDominating > 0));
    NextFront = find(NmbOfDominating == minFront);
    NmbOfDominating(NextFront) = 0;
    [rankedPop(NextFront).N_Front] = deal(m + 1);
    m = m + 1;
    Front{end + 1} = NextFront;
  end
end

% crowding distance for each individual; 3rd highest priority sorting key
CrowdDist = zeros( N_indivs, 1);
for n = 1:length(allObjVals(1,:))
  [ObjValsSorted, SortIdx] = sort(allObjVals( :, n));
  % individuals w/ extreme objective function values are assigned a negative
  % infinite crowding distance so that their rank is always lower than the rank
  % of other individuals which are otherwise of the same rank (same degree of
  % constraint violation; same Pareto-Front)
  rankedPop(SortIdx( 1)).CrowdDist = -inf;
  rankedPop(SortIdx( N_indivs)).CrowdDist = -inf;
  for j = 2:(N_indivs - 1)
    %%% introduced normalization by the absolute range of the 
    %%% objective function; a range of [0 1] is equivalent to no normalization
    % add negative of the distance between the nearest other two individuals
    % to the overall crowding distance
      rankedPop(SortIdx( j)).CrowdDist = rankedPop(SortIdx( j)).CrowdDist - ...
      (ObjValsSorted( j + 1) - ObjValsSorted( j - 1)) / ...
      (ObjValsSorted(N_indivs) - ObjValsSorted(1));
  end
end

%Es necesario convertir la estructura a tabla para ordenar por costoTotal
rankedPop = struct2table(rankedPop);
rankedPop = sortrows(rankedPop,{'Viols','N_Front','CrowdDist'});
rankedPop = table2struct(rankedPop)';

end
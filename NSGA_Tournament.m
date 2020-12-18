
function [Pars, Tourn] = NSGA_Tournament( Ranking, nmbOfPairs)

nmbOfIndivs = length( Ranking);
% indices of all pairs of identical individuals
DiagIdx = 1:(nmbOfIndivs + 1):nmbOfIndivs^2;
% indices of all pairs of distinct individuals
OffDiagIdx = setdiff( 1:nmbOfIndivs^2, DiagIdx);
% random permutation of all pairs of distinct individuals
RandPerm = randperm( length( OffDiagIdx));
% initialization of competing pairs
Tourn = zeros( 2, 2 * nmbOfPairs);
% randomly select 2 * nmbOfPairs competing pairs of distinct individuals from pool
[Tourn( 1, :), Tourn( 2, :)] = ind2sub( ...
  [nmbOfIndivs nmbOfIndivs], OffDiagIdx( RandPerm( 1:(2 * nmbOfPairs))));
% let paired individuals compete; individual w/ lower rank wins
FirstRowWins = Ranking( Tourn( 1, :)) < Ranking( Tourn( 2, :));
% pair winners, creating pairs of parent individuals
Pars = reshape( ...
  [Tourn( 1, FirstRowWins) Tourn( 2, ~FirstRowWins)], nmbOfPairs, 2);

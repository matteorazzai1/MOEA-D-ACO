function [ nextNode ] = rouletteWheel( P )
% Roulette wheel to choose one edge based on P values 

cumsumP = cumsum(P); % cumulative sum of the probabilities


r = rand(); % random number between 0 and 1

nextNode = find( r <= cumsumP ); % find the first node whose cumulative sum is greater than r


nextNode = nextNode(1); % select the first node


end
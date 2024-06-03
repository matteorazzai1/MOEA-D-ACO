function [ fitness ] = fitnessFunction ( tour , graph)


fitnessDist = 0;
fitnessCost = 0;

for i = 1 : length(tour) -1
    
    currentNode = tour(i);
    nextNode = tour(i+1);

    
    fitnessDist = fitnessDist + graph.edges( currentNode ,  nextNode,1 ); % access to the distance edge
    fitnessCost = fitnessCost + graph.edges( currentNode ,  nextNode,2 ); % access to the cost edge

    fitness=[fitnessDist,fitnessCost];
    
end


end
function [ colony ] = initializedTour( nodeNo, colony , antNo)
    % Initialize the tour of each ant
    
    for i = 1 : antNo
        
        initial_node = randi( [1 , nodeNo] ); % select a random node 
        colony.ant(i).tour(1) = initial_node;
        
        for j = 2 : nodeNo % to choose the rest of nodes 
                   
                    nextNode = randi([1, nodeNo]);  % Select a random node initially
                    while ismember(nextNode, colony.ant(i).tour)
                        nextNode = randi([1, nodeNo]);  % Select a new random node if it has already been visited
                    end
                   
                    colony.ant(i).tour = [  colony.ant(i).tour , nextNode ];
        end
        
        % complete the tour 
        colony.ant(i).tour = [ colony.ant(i).tour , colony.ant(i).tour(1)];
    end
    
    end
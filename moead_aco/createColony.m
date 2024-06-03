function [ colony ] = createColony( nodeNo, colony , antNo, r, phi)

% Create the ants

for i = 1 : antNo
    
    initial_node = randi( [1 , nodeNo] ); % select a random node 
    colony.ant(i).tour(1) = initial_node;
    
    for j = 2 : nodeNo % to choose the rest of nodes 
                currentNode =  colony.ant(i).tour(end);
               
                if rand < r
                    % take the node whose edge (i,node) has the maximum phi, among the cities not visited
                    phi_max = -inf;
                    for k = 1 : nodeNo
                        if ~ismember(k, colony.ant(i).tour)
                            if phi(i,currentNode, k) > phi_max
                                phi_max = phi(i,currentNode, k);
                                nextNode = k;
                            end
                        end
                    end
                else
                    % select the next node using the roulette wheel selection, according to the probability phi normalized
               
                    P_allNodes = phi(i,currentNode, :);
                    
                    P_allNodes(colony.ant(i).tour) = 0 ;  % assing 0 to all the nodes visited so far
                    
                    P = P_allNodes ./ sum(P_allNodes); % normalize the probabilities
               
                    nextNode = rouletteWheel(P); 
                end
                colony.ant(i).tour = [  colony.ant(i).tour , nextNode ];
    end
    
    % complete the tour 
    colony.ant(i).tour = [ colony.ant(i).tour , colony.ant(i).tour(1)];
end

end
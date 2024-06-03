function [colony,replacingSolution]=findBestNeighborhoodTour(colony,graph, antIndex, neighborhood, replacingSolution,T,lambda_weights)
    % Find the best solution in the neighborhood that was not used to replace any other old solution
    
    antG=findGMin(colony,lambda_weights,antIndex,antIndex);
    bestTour=colony.ant(antIndex).tour;
    changedTour=false;

    
    for i = neighborhood(antIndex,1):neighborhood(antIndex,T) % for each ant in the neighborhood
        
        if i == antIndex
            continue;
        end
        
        newTour = colony.ant(i).tour;
        newG=findGMin(colony,lambda_weights,i,i);

        
        inReplacingSolution=false;
        for j=1:size(replacingSolution{i},2)
            if isequal({newTour},{replacingSolution{antIndex}}) % if the solution is already used to replace another solution
                inReplacingSolution=true;
                break;
            end
        end
        if inReplacingSolution
            continue;
        end

        
        % If the solution of a certain neighbor is better than the current one, replace it
        if newG < antG
            colony.ant(antIndex).tour = newTour;
            colony.ant(antIndex).fitness = fitnessFunction(newTour, graph);
            antG = newG;
            bestTour=newTour;
            changedTour=true;
        end
        
    end

    % If the solution was changed, add it to the replacing solutions
    if(changedTour)
        replacingSolution{antIndex}{end+1} = bestTour;
    end



end
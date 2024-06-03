function [new_sol_EP,ant_best_tour,EP]=updateEP(colony,EP)

    new_sol_EP=[]; % new solutions that are not dominated by the solutions in EP
    ant_best_tour=[]; % the index of the ants that generated the new solutions in new_sol_EP

    % create the matrix F of fitness values of all ants
    F=[];
    for i=1:numel(colony.ant(:))
        for j=1:numel(colony.ant(i).fitness)
            F(i,j)=colony.ant(i).fitness(j); 
        end
    end
    
    % for each ant, check if it is not dominated by the solutions in EP
    for i=1:numel(colony.ant(:))
        currentSol=F(i,:);
        dominated=false;
        for j=1:size(EP,1)
            
            currentEP=EP(j,:);
            moreOrEqual=0;
            more=0;
            for k=1:numel(currentEP)  % the number of element of currentEP are the number of objectives
                
                if currentSol(k)>=currentEP(k) 
                    moreOrEqual=moreOrEqual+1;
                end
                if currentSol(k)>currentEP(k)
                    more=more+1;
                end
                
            end
            if moreOrEqual==numel(currentEP) && more>0
                dominated=true;
                break;
            end
        end
        if ~dominated
            % remove from EP all the elements that are dominated by currentSol, that is the non-dominated solution taken in exam 
            indexToRemove=[];
            for j=1:size(EP,1)
                
                currentEP=EP(j,:);
                moreOrEqual=0;
                more=0;
                for k=1:numel(currentEP)  % the number of element of currentEP are the number of objectives
                
                    if currentEP(k)>=currentSol(k) 
                        moreOrEqual=moreOrEqual+1;
                    end
                    if currentEP(k)>currentSol(k)
                        more=more+1;
                    end
                
                end
                if moreOrEqual==numel(currentEP) && more>0
                    % currentEP is dominated by currentSol
                    %Save the index of the row to remove
                    indexToRemove=[indexToRemove,j];
                   
                end
            end
            % remove the dominated solution from EP
           
            EP(indexToRemove,:)=[]; % remove the dominated solutions (indexed in vector indexToRemove) from EP
           
            % add currentSol to EP
            
            EP(end+1,:)=currentSol;
            
            % add currentSol to new_sol_EP
            new_sol_EP(end+1,:)=currentSol;
            ant_best_tour=[ant_best_tour,i];

        end
    end
    % remove from new_sol_EP all the elements that has been removed from EP

    if size(new_sol_EP,1)~=0
        % new_sol_EP is not empty
        indexToRemove=~ismember(new_sol_EP,EP,'rows');
        new_sol_EP(indexToRemove,:)=[];
        ant_best_tour(indexToRemove)=[];
    end
    


end
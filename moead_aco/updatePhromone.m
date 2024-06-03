function [ taumax,taumin,tau ] = updatePhromone(tau , colony,new_sol_EP,ant_best_tour,rho,groupAnt,lambda_weights,eps)
% Update the phromone matrix. 
nodeNo = length (colony.ant(1).tour);
antNo = length( colony.ant(:) );

% Evaporation of pheromone
tau = rho * tau;

% Update pheromone

for i = 1 : numel(ant_best_tour) % for each ant that just generated an optimal new solution
    antSelected=ant_best_tour(i);
    group=groupAnt(antSelected);

    for j = 1 : nodeNo-1 % for each node in the tour
        currentNode = colony.ant(i).tour(j);
        nextNode = colony.ant(i).tour(j+1);
        sum=0;

        for l=1:size(new_sol_EP,2)
            sum=sum+lambda_weights{antSelected}(l)*colony.ant(antSelected).fitness(l);  %lambda_weights{i}(l) is the weight of the l-th objective and graph.edges(j,k,l) is the value of the l-th objective of the edge beteween node j and k
        end
        
        tau(group,currentNode , nextNode) = tau(group,currentNode , nextNode)  + 1/sum;
        tau(group,nextNode , currentNode) = tau(group,nextNode , currentNode)  + 1/sum;

    end
end

% find taumax and taumin

B=numel(ant_best_tour);
gmin=findGMin(colony,lambda_weights,1,antNo);
taumax=(B+1)/(1-rho)*gmin;
taumin=eps*taumax;

% check if taumax and taumin are respected

for i=1:size(tau,1)
    for j=1:size(tau,2)
        for k=1:size(tau,3)
            if tau(i,j,k)>taumax
                tau(i,j,k)=taumax;
            end
            if tau(i,j,k)<taumin
                tau(i,j,k)=taumin;
            end
        end
    end
end

end
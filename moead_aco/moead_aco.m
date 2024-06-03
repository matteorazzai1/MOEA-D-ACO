% MOEAD-ACO da paper

%% basic setting

clear all
close all
clc

N=14; K=2; T=5; m=2; %N(number of ants), m(number of obj), T(number of neighbors), K(number of groups)


EP=[];


lambda=0.0:(1/(N-1)):1.00;  %weight for the aggregation function
lambda

%weight vectors


for i=1:numel(lambda)

        lambda_weights{i}=[lambda(i),1-lambda(i)];

end

%lambda_weights

%setting of group

psi=0.0:(1/(K-1)):1.0; %weight for the aggregation function

%then we cluster lambda in K groups

for i=1:K
    psi_weights{i}=[psi(i),1-psi(i)];
end

lambda_group={[]};
for j=1:numel(lambda_weights)
    for i=1:K
        
        min_dist=pdist2(lambda_weights{j},psi_weights{1});
        belonging_group=1;
        if(pdist2(lambda_weights{j},psi_weights{i})<min_dist)
            
            belonging_group=i;
            min_dist=pdist2(lambda_weights{j},psi_weights{i});
        end

    end
    if numel(lambda_group) < belonging_group
        
        lambda_group{belonging_group}={lambda_weights{j}};
        groupAnt(j)=belonging_group; %structure to verify the group of each ant
    else
        lambda_group{belonging_group}=horzcat(lambda_group{belonging_group},{lambda_weights{j}});
        groupAnt(j)=belonging_group;
    end
end



[ graph ]  = createGraph(); %create the graph

%% Initialization

%initialized herustic information

for i=1:N
    %initialize the heuristic information for ant i
    for j=1:graph.n
        for k=1:graph.n
            %sum at denominator
            sum=0;
            for l=1:m
                sum=sum+lambda_weights{i}(l)*graph.edges(j,k,l);  %lambda_weights{i}(l) is the weight of the l-th objective and graph.edges(j,k,l) is the value of the l-th objective of the edge beteween node j and k
            end
            
            eta(i,j,k)=1/sum;
        end
    end
end


%initialize pheromone matrix


for i=1:K  %for each group of ants
    for j=1:graph.n
        for k=1:graph.n
            tau(i,j,k)=1;  % i group, j e k nodes
        end
    end
end

tau_min=1;
tau_max=1;

%% solution construction

rho = 0.5; % Persistence rate 
alpha = 1;  % Phromone exponential parameters 
beta = 1;  % Desirability exponetial paramter
eps=1/(2*N);

delta=0.5*tau_max; %delta parameter

%% Main loop of ACO 

antNo=N; %number of ants

bestFitness = inf;
bestTour = [];
replacingSolution = cell(1,N); %initiliaze the replacing solution for each ant
maxIter = 500;

%create tour for each ant
% Create Ants
colony = [];
colony = initializedTour( graph.n, colony , antNo); %initialize the tour of each ant


%initialize the neighborhoods
neighborhoods = zeros(antNo, T); %initialize the neighborhoods matrix for each ant
for i = 1:antNo
    if(i<=floor(T/2))
        lowerBound = 1;
        upperBound = T;
    elseif(i>antNo-floor(T/2))
        lowerBound = antNo-T+1;
        upperBound = antNo;
    else
        lowerBound = i-floor(T/2);
        upperBound = i+floor(T/2);
    end

    neighborhoods(i, :) = lowerBound:upperBound;
end

for t = 1 : maxIter

    fprintf('cycle %d: ',t);
     
    %create attractiveness for each ant on each edge
    
    for i=1:antNo
        for k=1:graph.n
            for l=1:graph.n
                
                phi(i,k,l)=(tau(groupAnt(i),k,l)+delta*(indicatorFunction(colony.ant(i).tour,k,l)))^alpha*eta(i,k,l)^beta;  %i is the number of the ant for eta, k e l are the two nodes
                %groupAnt(i) is the belonging group of the i-th ant, which is a number from 1 to k
            end
        end
    end

    r = 0.7; %control parameter for the probability of choosing the next node
    colony=[];
    colony = createColony( graph.n, colony , antNo, r, phi);

    
     % Calculate the fitness values of all ants 
    for i = 1 : antNo 
        colony.ant(i).fitness = fitnessFunction(colony.ant(i).tour , graph );
    end

    % Update EP
    new_sol_EP=[];
    [new_sol_EP,ant_best_tour,EP]=updateEP(colony,EP); %update the EP with the new solutions
    
    % Update pheromone matrix
    [taumax,taumin,tau] = updatePhromone(tau , colony, new_sol_EP,ant_best_tour,rho,groupAnt,lambda_weights,eps);


    % Update of xi solutions 
  
    %find solutions in the neighborhood for each ant
    for i = 1:antNo
            % Find the best solution in the neighborhood that was not used to replace any other old solution
            [colony,replacingSolution]=findBestNeighborhoodTour(colony,graph, i, neighborhoods, replacingSolution,T,lambda_weights);
           
    end
    
end

figure(1);
PlotCosts(EP);
pause(0.01);

    
% Display Iteration Information
disp(['Iteration ' num2str(t) ': Number of Pareto Solutions = ' num2str(numel(EP(:,1)))]);

opt_point=[max(EP(:,1)), max(EP(:,2))];
disp(['opt_point: ', num2str(opt_point)]);
hyp = hypervolume(EP, opt_point);
disp(['Hypervolume: ', num2str(hyp)]);



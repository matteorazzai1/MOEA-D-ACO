function gmin=findGMin(colony,lambda_weights,startAnt,endAnt)
    % Find the minimum value of the objective function
    gmin=inf;
    
    for i=startAnt:endAnt
         sum=0;
         for l=1:size(lambda_weights{i},2) % the number of element of lambda_weights are the number of objectives
              sum=sum+lambda_weights{i}(l)*colony.ant(i).fitness(l);
         end
         if sum<gmin
              gmin=sum;
         end
    end
end
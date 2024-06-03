function result= indicatorFunction(tour,node1,node2)
    % This function returns 1 if the edge between node1 and node2 is in the tour, 0 otherwise
    result = 0;
    if(numel(tour)<2)
        return;
    end
    for i=1:numel(tour)-1
        if tour(i)==node1 && tour(i+1)==node2
            result=1;
        end
    end
end
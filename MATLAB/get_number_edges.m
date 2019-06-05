function number_of_edges = get_number_edges(continuous)
for i=1:size(continuous,1)   %go through all the row
    j=3;    %set and reset j at the 3rd column
    while continuous(i,j)~=0 %goes along the row until it finds a zero meaning the end has been reached
        j=j+1;
        if size(continuous,2)>12
            if j==12    %if there is 10 edges in total there is no point in going further than j=11
                break
            end
        else
            if j==size(continuous,2)+1
                break
            end
        end
        number_of_edges(i)=j-2; %store the number of edges in an array
    end
end
function change_of_edges = change_edges(number_of_edges)
j=1;
for i=1:size(number_of_edges,2)-1
    if (number_of_edges(i)-number_of_edges(i+1))~=0 %if the difference between the edges of two frames is not equal to zero it means there is a change
        change_of_edges(j)=i+1; %store the frame where the change occurs
        j=j+1;  %increment
    end
end
if j==1 %in case there is no change of edges in the file, still return an empty array
    change_of_edges=[];
end
end

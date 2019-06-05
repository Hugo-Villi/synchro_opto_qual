function only_numerical = delete_object_artefact(only_numerical)
%Theorically, with a hollow foot, the maximum number of edges detected is
%10. If a higher number of edge is detected after the first treatment, the
%concerned row is considered as an error and is deleted.
j=1;
if size(only_numerical,2)>11    %first check if there is actually more than 10 edges at some point in the file
    row_to_del=[];
    for i=1:size(only_numerical,1)
        if only_numerical(i,12)~=0    %if there is more than 10 edges it means a value different than 0 would be present in the 12th cell of the row
            row_to_del(j)=i;    %creates a list of row to delete
            j=j+1;
        end
    end
    only_numerical(row_to_del,:)=[];  %delete the rows with too many edges
    only_numerical(1:size(only_numerical,1),1:11)=only_numerical(1:end,1:11); % delete everything further than the 11th column, as it is filled with 0
    only_numerical(:,12:end)=[];
end
end
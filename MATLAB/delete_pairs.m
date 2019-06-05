function only_numerical = delete_pairs(only_numerical)
%blinking can occur at the same time as the detection of an object,
%generating 'pairs' of similar rows
j=1;    %to increment the array row_to_del
row_to_del_blink_2=[];
for i=1:size(only_numerical,1)-3 %go through the array
    if only_numerical(i,2:end)==only_numerical(i+2,2:end) 
        if only_numerical(i+1,2:end)==only_numerical(i+3,2:end) %check if the line n+1 is equal to the line n
            row_to_del_blink_2(j)=i+1;  %if it is add the number of the row to the list of row to delete
            j=j+1;  %increment
        end
    end
end
if isempty(row_to_del_blink_2)~=1
    only_numerical(row_to_del_blink_2,:)=[];
    row_to_del_blink_2=[];
end
end
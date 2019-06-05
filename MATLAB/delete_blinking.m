function only_numerical = delete_blinking(only_numerical)
%Deleting the blinking effect between true/false state of the led. If the
%state at the row n+1 is the same as the row n, the row n+1 is deleted
j=1;    %to increment the array row_to_del
row_to_del_blink=[];
for i=1:size(only_numerical)-1 %go through the array
    if only_numerical(i,2:end)==only_numerical(i+1,2:end) %check if the line n+1 is equal to the line n
        row_to_del_blink(j)=i+1;  %if it is add the number of the row to the list of row to delete
        j=j+1;  %increment
    end
end
if isempty(row_to_del_blink)~=1
    only_numerical(row_to_del_blink,:)=[];    %delete the row without interests.
    row_to_del_blink=[]; %empty the list of row to delete to avoid errors
end
end
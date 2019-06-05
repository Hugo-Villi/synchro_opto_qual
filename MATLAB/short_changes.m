function short_change = short_changes(change_of_edges,threshold_time)
j=1;
short_change=[];    %declare an empty array to return it if there is no short changes in the file
for i=1:size(change_of_edges,2)-1 
    if change_of_edges(i+1)-change_of_edges(i)<=threshold_time  %test if the change occurred during a time smaller than the given threshold. If yes it means that it certainly is an artefact
        short_change(j)=change_of_edges(i); %store at which frame short change happenned
        j=j+1;
    end
end
end
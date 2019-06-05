function continuous = create_continuous(only_numerical)
%recreation of a "continous" file to ease later synchronisation
previous_timestamp=1;   %to start the file a timestamp of 1
j=1;
for i=1:size(only_numerical,1)-1    %go through each line of the 'only_numerical" array, as each line represent a change of state
    line_to_copy=only_numerical(i,2:end);    %store the line as the line to copy
    next_timestamp=only_numerical(i+1,1);   %get until when the line need to be copied
    for j=previous_timestamp:next_timestamp-1   %iteration to copy the line (may be improved with only a copy of the line and a iteration of the timestamp)
        continuous(j,1)=j;   %timestamp
        continuous(j,2:size(only_numerical,2))=line_to_copy; %state
    end
    previous_timestamp=next_timestamp;  %get the next timestamp
end
j=j+1;   %to copy the last line 
continuous(j,1)=j;
continuous(j,2:end)=only_numerical(i+1,2:end);
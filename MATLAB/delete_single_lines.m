function continuous = delete_single_lines(short_change,continuous)
single_line=[];
j=1;
i=1;
if isempty(short_change)~=1
    if size(short_change,2)==1  %if there is only one line in the array there is no need to look for neighbour
        continuous(short_change(i),2:size(continuous,2))=continuous(short_change(i)-1,2:size(continuous,2));
    else
        if short_change(i+1)-short_change(i)>1  %for the first line only check if there is a neighbour after
            single_line(j)=short_change(i);
            j=j+1;
        end
        for i=2:size(short_change,2)-1  %check if the short change line doesn't have any neighbour
            if short_change(i)-short_change(i-1)>1  %test if there is another change of edge before
                if short_change(i+1)-short_change(i)>1  %after
                    single_line(j)=short_change(i);  %if there is none it is considered as a single line
                    j=j+1;
                end
            end
        end
        i=i+1;
        if short_change(i)-short_change(i-1)>1  %for the last line only check if there is a neighbour before
            single_line(j)=short_change(i);
        end
    end
    if isempty(single_line)~=1  %execute the deletion of the error only if there is actually single lines to correct, otherwise it generate errors
        for i=1:size(single_line,2)
            continuous(single_line(i),2:end)=continuous(single_line(i)-1,2:end);  %the single line error is solved by being replaced by the previous line
        end
    end
end
end
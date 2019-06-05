function continuous = delete_case_2(continuous,short_change,number_of_edges)
%{
for two continuous bugged line like:
1:____
2:____
3:__
4:______
5:____
6:____
7:____
%}
for i=2:size(short_change,2)-1
    n0=number_of_edges(short_change(i)-1);
    n1=number_of_edges(short_change(i));
    n2=number_of_edges(short_change(i)+1);
    n3=number_of_edges(short_change(i)+2);
    if n0==n3
        if n1~=n2
            if n2~=n3
                continuous(short_change(i),2:11)=continuous(short_change(i)-1,2:11);
                continuous(short_change(i+1),2:11)=continuous(short_change(i)-1,2:11);
            end
        end
    end
end
end

function continuous = delete_case_1(continuous,short_change,number_of_edges)
%{
in this configuration:
1:__
2:____
3:__
4:____
5:____
the first part of the correction of errors would transform the line 2 into
line 1, but the line 2 seems to be the start of a new block. Transforming
it would mean to falsely time the start of the block. The best thing to do
would be to transform the line 3 into line 2.
get the number of edges from n-1 to n+2
%}
for i=1:size(short_change,2)-1
    n1=number_of_edges(short_change(i));    %get the number of edges and compare them 
    n2=number_of_edges(short_change(i)+1);  %to check if it is in the correct configuration
    n3=number_of_edges(short_change(i)+2);  %for the application of the correction
    if n1==n3
        continuous(short_change(i+1),2:11)=continuous(short_change(i),2:11);    %copy the previous line onto the error line
    end
end
end
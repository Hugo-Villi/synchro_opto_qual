function only_numerical = delete_false_edges(only_numerical,threshold,number_of_leds)
%cleaning the noise made by the qualisys
%deleting false edges
for i=1:size(only_numerical,1)    %go through the whole array
    j=3;    %will select the second edge
    while j<=size(only_numerical,2)
        if only_numerical(i,j)==number_of_leds   %if the selected cell is equal to 96*number_of_bars it means it has reached the end and breaks out the loop
            break;
        end
        %if the cell n-1 is smaller than the the cell n by a a value 
        %inferior to the threshold, it is considered as an arefact and 
        %the on or two cell concerned are deleted by shifting the position
        %of the neighbouring cell
        if only_numerical(i,j)-only_numerical(i,j-1)<threshold %The min number of led that have to be lit to be considered as an object 
            if j==3
                only_numerical(i,j:end-1)=only_numerical(i,j+1:end);    %shift position only by one when at the beginning of the row
                only_numerical(i,end)=0;    %place a zero at the 'space' left by the shifting
            else
                only_numerical(i,j-1:end-2)=only_numerical(i,j+1:end);  %shift position by 2 to delete the pair of value that are too close
                only_numerical(i,end-1:end)=0;    %place zeros at the 'space' left by shifting
            end
            j=2;    %set j back at two to start over at the beginning of the row
        end
        j=j+1;
    end
end
end
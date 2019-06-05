function all_led_data = get_all_led_info(data_to_plot,number_of_edges_to_plot)

for i=1:size(data_to_plot,1)
    if mod(number_of_edges_to_plot(i),2)==0 %test if the number of edges is even
        start_at=0; %if it is, then there is no foot at the edge, and the starting state is at 0 (no occlusion)
    else    %if it is not, it means there is a foot at the edge, and the side have to be determined
        Left=data_to_plot(i,3)-data_to_plot(i,2);   %compute the distance between the "Left" edge and the next object
        Right=data_to_plot(i,number_of_edges_to_plot(i)+1)-data_to_plot(i,number_of_edges_to_plot(i)); %compute the distance between the "right" edge and the next object
        if Right<Left   %if the object is closer to the "right" side the starting state is at 0
            start_at=0;
        else    %otherwise it is at 1
            start_at=1;
        end
    end
    for j=3:number_of_edges_to_plot(i)+1    
        from=data_to_plot(i,j-1);   %will go from on edge to another and will inverse the starting state at each edge. 
        to=data_to_plot(i,j);
        if from==0
            from=1;
        end
        for k=from:to
            all_led_data(i,k)=start_at;
        end
        if start_at==0
            start_at=1;
        else
            start_at=0;
        end  
    end  
end
end
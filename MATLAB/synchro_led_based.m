clearvars   %clear the variables
file = uigetfile('*.xml');  %get the file name
[~,only_numerical,total_time,start_time]=read_xml(file); %read the .xml
acq = btkReadAcquisition(regexprep(file,'xml','c3d'));  %read the .c3d
analogic_entries=btkGetAnalogs(acq);    %get the values of analogic entries in a struct
analogic_entries=analogic_entries.Channel_10;   %In the case of this algortihm the analogic
markers_value=btkGetMarkersValues(acq);
grf = btkGetGroundReactionWrenches(acq);
%entries was setup to the entries #10, this would need to be changed if the entrie
%is modified or applied in another setup
analog_freq=btkGetAnalogFrequency(acq); %get the sample frequency of the analog channel
point_freq=btkGetPointFrequency(acq); 
Opto_freq=1000;
blink_time=300; %this value is coming from the Arduino code, where the settings
%are made so the led blink during 300ms
pause_time=200;  %from Arduino, 200ms
num_square_wave=4;   %from Arduino
blink_time_analog_frame=(blink_time*analog_freq)/Opto_freq;  %express the blink time in analog frames
pause_time_analog_frame=(pause_time*analog_freq)/Opto_freq;
i=1;    %initialize the variable for the while loop
j=1;
while i<size(analogic_entries,1)    %go througha all the vector to identify the frame were it goes from a low to high state
    if analogic_entries(i,1)<0.1 && analogic_entries(i+1,1)>0.1  %will detect a switching from low to high state
        up(j)=i;    %store the frame (analog) where it switches
        j=j+1;  %increment for the storage
        i=i+blink_time_analog_frame+50; %will jump directly after the blink phase
    end
    i=i+1;
end

i=1;    %initialize the variable for the while loop
j=1;
while i<size(analogic_entries,1)    %go througha all the vector to identify the frame were it goes from a low to high state
    if analogic_entries(i,1)>0.1 && analogic_entries(i+1,1)<0.1  %will detect a switching from high to low state
        down(j)=i;    %store the frame (analog) where it switches
        j=j+1;  %increment for the storage
        i=i+blink_time_analog_frame+50; %will jump directly after the blink phase
    end
    i=i+1;
end

%As the LED is blinking at 30000Hz (see arduino code), the rate of the
%analog sampling is to low to catch every switch, it is not possible to use
%an individual blink to synchronise. The start and end of the
%switching phase are used instead.
[row_to_keep,col_to_keep]=find(only_numerical==287);    %locate the rows where the led blink (every row where the receptor 287 is active)
only_led=only_numerical(sort(row_to_keep),1);   %create an array with only the timestamps of the rows where the LED is active
start_led(1)=only_led(1,1); %the first start will be at the first timestamp in the only_led array
j=1;
for i=1:size(only_led,1)-1  %will look for gaps in the timestamps, if it is higher than 150, a gap is identified
    if only_led(i+1)-only_led(i)>150
        end_led(j)=only_led(i); %the frame i is considered as the end of the gap
        start_led(j+1)=only_led(i+1);    %the following frame is the start of the next gap
        j=j+1;  %increment for the storing array.
    end
end
start_led(num_square_wave+1:end)=[];    %the pression on the button to end the acquisition trigger a new synchronisation sequence that can be enregistred at the end of the file
end_led(num_square_wave+1:end)=[];  %So only the first  values of the array are keeped

up_in_opto_frame=up/(analog_freq/Opto_freq)  %the analog frame rate (2000) is reduced to the one of the optogait(1000)
down_in_opto_frame=down/(analog_freq/Opto_freq)
delay_up=up_in_opto_frame-start_led     %compute the delay, will give a result in opto frames
delay_down=down_in_opto_frame-end_led
delay=cat(1,delay_down,delay_up)    %concatenate the up and down delays
delayed_timestamps=only_numerical(:,1)+round(mean(delay,'all')) %modify the timestamps to correct the delay

corrected_only_numerical=only_numerical;    %store the only numerical array in a new one to apply changes
corrected_only_numerical(:,1)=delayed_timestamps(:,1);  %give the new timestamps
for i=1:size(row_to_keep)
    corrected_only_numerical(row_to_keep(i),col_to_keep(i))=corrected_only_numerical(row_to_keep(i),col_to_keep(i)+1);  %delete all the rows used for synchronisation to ease the next steps
    corrected_only_numerical(row_to_keep(i),col_to_keep(i)+1)=0;
end
[row288,col288]=find(corrected_only_numerical(:,2:end)==288)
col288=col288+1;
j=1;
row_to_del=[]
for i=1:size(row288)
    if corrected_only_numerical(row288(i),col288(i)-1)==286
        corrected_only_numerical(row288(i),col288(i))=0;
    else if corrected_only_numerical(row288(i),col288(i)-1)==0
            row_to_del(j)=row288(i);
            j=j+1;
        else
            corrected_only_numerical(row288(i),col288(i))=286;
        end
    end
end

if isempty(row_to_del)~=1
    corrected_only_numerical(row_to_del,:)=[]
end
%
corrected_only_numerical(find(corrected_only_numerical(:,1)<0),:)=[];   %delete all the timestamp under 0
delayed_timestamps(1,1)=0;
%this part is only to validate the algo with files with on/off and impacts,
%the resulting delay between impact opto and qual is about 1ms.
only_numerical=corrected_only_numerical;
%treshold_forceplate_impact=10;  %Newton threshold
%treshold_time=200;  %Time threshold, expressed in frame, to avoid the interpreation of noise generated by the impact a events
%[plot_grf,frames_of_impact_grf,last_frame_grf]=detect_impact_forceplate(acq,treshold_forceplate_impact,treshold_time);    %this function will output a plot to make sure the correct data is extracted, the moments of impact, and size of the recording
number_of_leds=286;    %the number of bars in the set up
threshold_leds=2;
only_numerical=delete_object_artefact(only_numerical);
only_numerical=delete_false_edges(only_numerical,threshold_leds,number_of_leds);
%After the deletion of false objects, a second treatment occurs. The maximal
%number of edge the optogait could record for a patient with hollow foot is
%ten. Hence any row with more than ten edge is considered as an error and
%is deleted.


%An effect of the qualisys on the optogait is the blinking of leds between a
%TRUE/FALSE state. To delete these unnecessary rows, the function check if
%two line are the same. If yes, the row is deleted.

%only_numerical=delete_blinking(only_numerical);

%Another similar effect can occur, but instead of blinking between
%TRUE/FALSE states its blink between two different states with different
%number of edges. To delete this effect pairs of row are compared, and if
%similarities are found the pair is deleted.
%only_numerical=delete_pairs(only_numerical);

%Once the data have been cleaned, a continuous file is recreated, to ease
%the future synchronisation and the deletion of the remaining errors.
continuous=create_continuous(only_numerical);

%delete the remaining blink of errors in valid data, based on the timestamp
%and the time the change took to occur
%detection of the error

%getting of the number of edges
number_of_edges=get_number_edges(continuous);

%detecting the changement of edges
indexes_of_change_of_edges=change_edges(number_of_edges);

%detecting the short changes
short_change=short_changes(indexes_of_change_of_edges,1);

%for singles lines, the values of the previous row is copied
continuous=delete_single_lines(short_change,continuous);

%Once the single line have been deleted the number of changes is computed
%again to ease the next steps
number_of_edges=get_number_edges(continuous);
indexes_of_change_of_edges=[];
indexes_of_change_of_edges=change_edges(number_of_edges);
short_change=[];
short_change=short_changes(indexes_of_change_of_edges,1);

continuous = delete_case_1(continuous,short_change,number_of_edges);
continuous = delete_case_2(continuous,short_change,number_of_edges);

number_of_edges=get_number_edges(continuous);
indexes_of_change_of_edges=[];
indexes_of_change_of_edges=change_edges(number_of_edges);
short_change=[];
short_change=short_changes(indexes_of_change_of_edges,1);
continuous=delete_single_lines(short_change,continuous);

number_of_edges=get_number_edges(continuous);
indexes_of_change_of_edges=[];
indexes_of_change_of_edges=change_edges(number_of_edges);
short_change=[];
short_change=short_changes(indexes_of_change_of_edges,1);
continuous=delete_single_lines(short_change,continuous);

%tests to plot the needed information
%the graph will display the moment when a change occurs
data_to_plot=delete_blinking(continuous);
%The number of edges is important as if the number is odd it means there is
%a feet at the edge of the optogait and the further steps won't be exactly
%the sames.
number_of_edges_to_plot=get_number_edges(data_to_plot);
continous_number_of_edges_to_plot=get_number_edges(continuous);
all_led_info=get_all_led_info(data_to_plot,number_of_edges_to_plot);
continuous_all_led_info=get_all_led_info(continuous,continous_number_of_edges_to_plot);
plot_optogait=plot_opto(all_led_info,data_to_plot,number_of_leds);
j=1;
for i=1:5:size(continuous_all_led_info,1)
    continuous_all_led_info_to_c3d(j,:)=continuous_all_led_info(i,:);
    j=j+1;
end


for i=1:size(continuous_all_led_info_to_c3d,2)
    clear values
    values(1:size(continuous_all_led_info_to_c3d,1),1)=2016-(i*10.4);
    values(1:size(continuous_all_led_info_to_c3d,1),2)=239.5;
    values(1:size(continuous_all_led_info_to_c3d,1),3)=continuous_all_led_info_to_c3d(:,i)*100;
    values(size(markers_value,1)+1:end,:)=[];
    [points, pointsInfo] = btkAppendPoint(acq, 'marker', ['opto_',num2str(i)], values);
end
btkWriteAcquisition(acq, strcat(regexprep(file,'.xml',''),'_mod.c3d'));
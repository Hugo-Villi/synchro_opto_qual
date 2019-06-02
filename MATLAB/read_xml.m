function [data,only_numerical,total_time,start_time] = read_xml(file_name)
%%get the raw values and fill a 'data' array with strings.
[num,txt,raw] = xlsread(file_name,1); %num and txt are not used
i=2;
[num1,txt1,raw1]=xlsread(file_name,4,strcat('X',num2str(i)));   %Will look for the line 'external trigger stop' to find the total and start time. The language must be set as english or the string must be changed to work. 
while strcmp(char(txt1),'External trigger STOP')~=1
    [num1,txt1,raw1]=xlsread(file_name,4,strcat('X',num2str(i)));
    i=i+1;
end
total_time=xlsread(file_name,4,strcat('Y',num2str(i-1)));   %the start time is the time between the start and end trigger
start_time=xlsread(file_name,4,strcat('Z',num2str(i-1)));   %time between the start of the acquisition after the click on execute and the end trigger.
data=string(raw);   %convert cells into strings
data=fillmissing(data,'constant',"0"); %fill the <missing> data with strings of 0, to ease the next steps of the algorithm
for i=1:size(data,1)-1 %only get the timestamp, as a numerical value, to facilitate the following incrementation
    only_numerical(i,1)=str2num(data(i+1,4));
end
for i=1:size(data,1)-1 %only get numerical values for the edges detected by the optogait
    for j=1:size(data,2)/2-2
        only_numerical(i,j+1)=str2num(data(i+1,j*2+3));
    end
end
end
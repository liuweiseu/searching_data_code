function [ data,N,lost ] = read_psr_block( fp,frame_num )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%输入参数：  fp---文件指针
%           frame_num---想要取的数据的帧数
%返回数据：  data----返回的数据
%           N----实际返回的数据帧数
%           lost---丢包帧数
PsrGlobals;
i = 1;
N = 0;
lost = 0;
[data_temp,len] = fread(fp,frame_num*Frame_Len,'uint8');    %一次性取想要的帧数数据出来
if(len<(Frame_Len*frame_num))                               %如果数据不足，直接返回
    data = zeros(frame_nu,Frame_Len);
    return;
end
data_array = reshape(data_temp,frame_num,Frame_Len);              %转换成矩阵的形式
time_array = data_array(:,25:32);                           %取出时标信息
time_temp = CalTime(time_array);                            %计算时标

i = 1;
data_p = 1;             %指向缓存数据的指针
for i = 1:frame_num
   if(time_temp(data_p)== (pre_time + ACCNo)) 
       data(i,:) = data_array(data_p,:);
       data_p = data_p + 1;
   else
       data(i,:) = 0;
       lost = lost + 1;
   end
   pre_time = pre_time + ACCNo;
end
N = frame_num;
fseek(fp,-1*Frame_Len*(frame_num+1-data_p),'cof');
end


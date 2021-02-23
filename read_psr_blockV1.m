function [ data_out,N,lost ] = read_psr_blockV1( fp,frame_num )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%输入参数：  fp---文件指针
%           frame_num---想要取的数据的帧数
%返回数据：  data----返回的数据
%           N----实际返回的数据帧数
%           lost---丢包帧数
PsrGlobals;
[data_temp,len] = fread(fp,Frame_Len*frame_num,'uint8');    %取相应的数据出来
if(len<(Frame_Len*frame_num))                               %看是否取出足够的数据
   data_out = 0;                                                %如果没有，则说明取到文件最后了，返回数据帧数为-1
   N = -1;
   lost = 0;
   return;
end
data_array = reshape(data_temp,Frame_Len,frame_num);        %将取出的数据组织成矩阵形式
[ lost, data ] = CheckData( data_array, ACCNo);             %调用数据检查函数，检查是否丢包
data_out = data(33:Frame_Len,:);
fseek(fp,lost*(-1)*Frame_Len,'cof');
N = frame_num;
end
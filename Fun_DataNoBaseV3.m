function [ filename , lost ] = Fun_DataNoBaseV3( filename , time )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
PsrGlobals


fp_r=fopen(filename);
frame_length = read_psr_head(fp_r);%将512字节文件头读出来
%打开结果存储文件
filename_len=length(filename);
filename(filename_len-3:filename_len)='_nob';
filename=[filename,'ase_V3.dat'];
fp_w=fopen(filename,'wb');
%计算相关参数
dt = 1/SampFreq*ChannelNo*2*ACCNo;
nobase_len = uint32(5/dt);
%定义下一个文件的文件头，并写入相关信息
write_file_head=zeros(512,1);
write_file_head(1) = dt;
write_file_head(2) = ChannelNo*Mode;
write_file_head(6) = Start_Freq;
write_file_head(7) = Stop_Freq;
write_file_head(8) = Mode;
write_file_head(9) = ACCNo;
fwrite(fp_w,write_file_head,'double');

%取数据进行处理
% [temp_data,len]=fread(fp_r,frame_length*nobase_len,'*uint8');
lost_all = 0;
[d,pre_time,pps] = read_psr_data(fp_r,Frame_Len);
[d,pre_time,pps] = read_psr_data(fp_r,Frame_Len);
[data,N,lost] = read_psr_blockV1(fp_r,nobase_len);
temp = zeros(ChannelNo*Mode*nobase_len,1);
while (N == nobase_len)
    lost_all = lost_all + lost;
    average=zeros(ChannelNo*Mode,1);
    average=mean(data,2);
    average_array=zeros(ChannelNo*Mode,nobase_len);
    average_array=repmat(average,1,nobase_len);
    data=double(data)-average_array;
    temp = reshape(data,ChannelNo*Mode*nobase_len,1);
    fwrite(fp_w,temp,'double');
    [data,N,lost] = read_psr_blockV1(fp_r,nobase_len);
end
fclose(fp_r);
fclose(fp_w);

end


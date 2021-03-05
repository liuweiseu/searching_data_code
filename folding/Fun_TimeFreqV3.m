function [ output_args ] = Fun_TimeFreqV3( filename ,  pulsar_period)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

pulsar_period=pulsar_period/1000;
% filename=['D:/data process/',filename];
filename_len=length(filename);
%打开读文件
fp_r=fopen(filename,'rb');
%输出文件名构成
filename(filename_len-3:filename_len)='_Tim';
filename=[filename,'eFreq_V3.dat'];
fp_w=fopen(filename,'wb');
%读出文件头
[file_head_info,len]=fread(fp_r,512,'double');
dt=file_head_info(1);
frame_len=uint32(file_head_info(2));
ACCNo = file_head_info(9);
% ACCNo = 22;
now_ptr=0;
cal_ptr=0;
delt_ptr=0;
cycle = 0;%已经叠加的周期数
file_head_info(3)=pulsar_period;
N=uint32(pulsar_period/dt);                         %计算一个周期里应该有几帧数据
N_double=pulsar_period/dt;
file_head_info(4)=N;
%写入新的文件头
fwrite(fp_w,file_head_info,'double');
data=zeros(frame_len,N);
temp_data=zeros(frame_len,N);
temp=zeros(frame_len*N,1);
get_frame_num=0;
cal_ptr_mid=0;
[temp,len]=fread(fp_r,frame_len*N,'double');
while ~feof(fp_r)
    now_ptr=now_ptr+N;
%     cal_ptr=uint32(cal_ptr+N_double);
    cal_ptr_mid = cal_ptr_mid + N_double;
    cal_ptr = uint32(cal_ptr_mid);
    cycle = cycle+1;
    delt_ptr=cal_ptr-now_ptr;
    temp_data=reshape(temp,frame_len,N);
    if(delt_ptr ~= 0)
        [d,len] = fread(fp_r,frame_len*delt_ptr,'double');
        now_ptr = 0;
        cal_ptr = 0;
        cal_ptr_mid = 0;
    end
    data=data+temp_data;
    get_frame_num=get_frame_num+1;
    [temp,len]=fread(fp_r,frame_len*N,'double'); 
end
% data=data/get_frame_num;
fwrite(fp_w,data,'double');
fclose(fp_r);
fclose(fp_w);
end


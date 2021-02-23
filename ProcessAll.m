clear;
% clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'G:\存数软件');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end
pulsar_period=input('pulsar_period(ms)=');
%打开数据文件
fp_r=fopen(filename);
frame_length = read_psr_head(fp_r);%将512字节文件头读出来
%打开结果存储文件
filename_len=length(filename);
filename(filename_len-3:filename_len)='_nob';
filename=[filename,'ase_V3.dat'];
fp_w=fopen(filename,'wb');
%计算相关参数
dt = 1/SampFreq*ChannelNo*2*ACCNo;
nobase_len = uint32(1/dt);
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
while (N == nobase_len)
    lost_all = lost_all + lost;
    average=zeros(ChannelNo*Mode,1);
    average=mean(data,2);
    average_array=zeros(ChannelNo*Mode,nobase_len);
    average_array=repmat(average,1,nobase_len);
    data=double(data)-average_array;
    fwrite(fp_w,data,'double');
    [data,N,lost] = read_psr_blockV1(fp_r,nobase_len);
end
fclose(fp_r);
fclose(fp_w);
helpdlg('去基线运算结束','提示');


close all;


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
delt_prt=0;
lost_all = 0;
error_1 = 0;
error_2 = 0;
cycle = 0;%已经叠加的周期数
max_delt = 0;
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
[temp,len]=fread(fp_r,frame_len*N,'double');
while ~feof(fp_r)
    now_ptr=now_ptr+N;
    cal_ptr=uint32(cal_ptr+N_double);
    cycle = cycle+1;
    delt_ptr=cal_ptr-now_ptr;
    temp_data=reshape(temp,frame_len,N);
    if(delt_ptr ~= 0)
        now_ptr = 0;
        cal_ptr = 0;
    end
    data=data+temp_data;
    get_frame_num=get_frame_num+1;
    [temp,len]=fread(fp_r,frame_len*N,'double'); 
end
% data=data/get_frame_num;
fwrite(fp_w,data,'double');
fclose(fp_r);
fclose(fp_w);
helpdlg('时频处理结束','提示');
error_1
error_2
lost_all
% [y,Fs] = audioread('五月天 - 你不是真正的快乐.mp3');
% %播放读入的数据
% p = audioplayer(y,Fs);
% play(p);
% a = input('请输入任意字符：');
% stop(p);
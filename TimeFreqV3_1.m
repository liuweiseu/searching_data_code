clear;
% clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'J:\存数软件');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

pulsar_period=input('pulsar_period(ms)=');
pulsar_period=pulsar_period/1000;
% filename=['D:/data process/',filename];
filename_len=length(filename);
%打开读文件
fp_r=fopen(filename,'rb');
%输出文件名构成
filename(filename_len-3:filename_len)='_Tim';
filename=[filename,'eFreq_V3_1.dat'];
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
lost_all = 0;
error_1 = 0;
error_2 = 0;
cycle = 0;%已经叠加的周期数
max_delt = 0;
dn = 10; %主要用于说明将一帧数据划分成多少小份
file_head_info(3)=pulsar_period;
N=floor(pulsar_period/dt);                         %计算一个周期里应该有几帧数据
N_real = floor(pulsar_period/dt*dn);        %计算一个周期里细分的帧数
N_double=pulsar_period/dt*dn;
file_head_info(4)=N_real;
shift_N = N_real - N*dn;
%写入新的文件头
fwrite(fp_w,file_head_info,'double');
data=zeros(frame_len,N_real);
temp_data_mid = zeros(frame_len,N_real);
temp_data=zeros(frame_len,N);
temp=zeros(frame_len*N,1);
get_frame_num=0;
cal_ptr_mid=0;
[temp,len]=fread(fp_r,frame_len*N,'double');
while ~feof(fp_r)
    now_ptr=now_ptr+N*dn;
%     cal_ptr=uint32(cal_ptr+N_double);
    cal_ptr_mid = cal_ptr_mid + N_real;
    cal_ptr = uint32(cal_ptr_mid);
    cycle = cycle+1;
    delt_ptr=cal_ptr-now_ptr;
    temp_data=reshape(temp,frame_len,N);
    for i=1:N
        for j=1:dn
           temp_data_mid(:,(i-1)*dn+j) = temp_data(:,i)/dn; 
        end
    end
    if(delt_ptr >=1)
%         data = [data(:,N_real:N_real) data(:,1:(N_real-1))];
        now_ptr = 0;
        cal_ptr = 0;
        cal_ptr_mid = 0;
    end
    data=data+temp_data_mid; %叠加上去
    data = [data(:,(N*dn+1):N_real) data(:,1:N*dn)]; %做一下移位操作
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
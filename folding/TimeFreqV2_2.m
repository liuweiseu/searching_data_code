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
pulsar_period=pulsar_period/1000;
% filename=['D:/data process/',filename];
filename_len=length(filename);
%打开读文件
fp_r=fopen(filename,'rb');
%输出文件名构成
filename(filename_len-3:filename_len)='_Tim';
filename=[filename,'eFreq_V2.2.dat'];
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
start_time=CalTime(temp(25:32));
while ~feof(fp_r)
    now_ptr=now_ptr+N;
    cal_ptr=uint32(cal_ptr+N_double);
    cycle = cycle+1;
    delt_ptr=cal_ptr-now_ptr;
    temp_data=reshape(temp,frame_len,N);
    [lost, temp_data] = CheckData(temp_data,ACCNo);
    if(lost == -1)
        error_1 = error_1+1;
         helpdlg('时标出现异常:-1','提示');
         return;
    elseif(lost == -2)
        error_2 = error_2+1;
        [temp,len]=fread(fp_r,frame_len*N,'double'); 
%         helpdlg('时标出现异常:-2','提示');
    else
        fseek(fp_r,lost*(-1)*frame_len*8,'cof');
        lost_all = lost_all + lost;
    end
    fseek(fp_r,delt_ptr*frame_len*8,'cof');
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
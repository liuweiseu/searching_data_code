clear;
clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'D:\data process\色散值较大的数据');
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
filename=[filename,'eFreq_V2.1.dat'];
fp_w=fopen(filename,'wb');
%读出文件头
[file_head_info,len]=fread(fp_r,512,'double');
dt=file_head_info(1);
frame_len=uint32(file_head_info(2));
delt = file_head_info(9);
now_ptr=0;
cal_ptr=0;
delt_prt=0;
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
    if(delt_prt~=0)%这里的情况是，实际叠加过程中的误差已经在delt中体现出来了，所以两个指针应该回归同一位置
        now_ptr = 0;
        cal_ptr = 0;
        fseek(fp_r,delt_ptr,'cof');
    end
    temp_data=reshape(temp,frame_len,N);
    time_array=temp_data(25:32,:);
    time_temp=CalTime(time_array);
    diff_time_temp=diff(time_temp);
    min_delt = min(diff_time_temp);
    max_delt = max(diff_time_temp);
    if (min_delt < 0)
        
    if (max_delt~= delt)%这里考虑的是丢包的情况
        %丢包的话，放弃这一周期的数据，也放弃下一周期的数据（因为丢包，会导致下一周期的到了上一周期中），重新开始找下下周期的数据，然后从0开始
        cai_ptr = 0;
        now_ptr = 0;
        cycle = cycle +2 +uint32(max_delt/delt/N_double);
        FindNextFrame(fp_r,start_time, frame_len, uint32(cycle*N_double), delt);
    else
        data=data+temp_data;
        get_frame_num=get_frame_num+1;
    end
    [temp,len]=fread(fp_r,frame_len*N,'double'); 
end
% data=data/get_frame_num;
fwrite(fp_w,data,'double');
fclose(fp_r);
fclose(fp_w);
helpdlg('时频处理结束','提示');

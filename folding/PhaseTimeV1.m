clc;
clear;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ����������������',...
    'J:\��������');
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
%�򿪶��ļ�
fp_r=fopen(filename,'rb');
%����ļ�������
filename(filename_len-3:filename_len)='_Pha';
filename=[filename,'seTime.dat'];
fp_w=fopen(filename,'wb');
%�����ļ�ͷ
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
cycle = 0;%�Ѿ����ӵ�������
N_time_now = 1;
file_head_info(3)=pulsar_period;
N=uint32(pulsar_period/dt);                 %����һ��������Ӧ���м�֡����
N_double=pulsar_period/dt;
I_time = input('integral time(s)=');
exp_cycle = floor(I_time/pulsar_period);    %������ô��ʱ����Ӧ��ȡ����
Obs_time = input('Obs_time(s)=');
N_time = floor(Obs_time/I_time);            %����۲�ʱ���ڣ��м�������ʱ���
data_PT = zeros(N_time,N);
file_head_info(4)=N;
%д���µ��ļ�ͷ
fwrite(fp_w,file_head_info,'double');
data=zeros(frame_len,N);
temp_data=zeros(frame_len,N);
temp=zeros(frame_len*N,1);
get_frame_num=0;
cal_ptr_mid=0;
[temp,len]=fread(fp_r,frame_len*N,'double');
while (~feof(fp_r)) && (N_time_now<N_time)
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
    if(cycle==exp_cycle)
        cycle = 0;
        data_PT(N_time_now,:)=sum(data(1:580,:))+sum(data(606:2040,:));
        N_time_now = N_time_now + 1;
        data = zeros(frame_len,N);
    end       
    [temp,len]=fread(fp_r,frame_len*N,'double'); 
end
% data=data/get_frame_num;
fwrite(fp_w,data_PT,'double');
fclose(fp_r);
fclose(fp_w);
x = 1:N;
y = 1:N_time;
h=pcolor(x,y,data_PT);
set(h,'edgecolor','none','facecolor','interp');
colorbar;
xlabel('Phase');
ylabel('Time');
helpdlg('��λʱ��ͼ�������','��ʾ');
error_1
error_2
lost_all
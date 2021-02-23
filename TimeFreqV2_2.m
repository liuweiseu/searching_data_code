clear;
% clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ���������������',...
    'G:\�������');
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
filename(filename_len-3:filename_len)='_Tim';
filename=[filename,'eFreq_V2.2.dat'];
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
max_delt = 0;
file_head_info(3)=pulsar_period;
N=uint32(pulsar_period/dt);                         %����һ��������Ӧ���м�֡����
N_double=pulsar_period/dt;
file_head_info(4)=N;
%д���µ��ļ�ͷ
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
         helpdlg('ʱ������쳣:-1','��ʾ');
         return;
    elseif(lost == -2)
        error_2 = error_2+1;
        [temp,len]=fread(fp_r,frame_len*N,'double'); 
%         helpdlg('ʱ������쳣:-2','��ʾ');
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
helpdlg('ʱƵ�������','��ʾ');
error_1
error_2
lost_all
% [y,Fs] = audioread('������ - �㲻�������Ŀ���.mp3');
% %���Ŷ��������
% p = audioplayer(y,Fs);
% play(p);
% a = input('�����������ַ���');
% stop(p);
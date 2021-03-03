clear;
clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ����������������',...
    'D:\data process\ɫɢֵ�ϴ������');
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
filename=[filename,'eFreq.dat'];
fp_w=fopen(filename,'wb');
%�����ļ�ͷ
[file_head_info,len]=fread(fp_r,512,'double');
dt=file_head_info(1);
frame_len=uint32(file_head_info(2));
frame_len_double=file_head_info(2);
now_ptr=0;
cal_ptr=0;
delt_prt=0;
file_head_info(3)=pulsar_period;
N=uint32(pulsar_period/dt);
file_head_info(4)=N;
%д���µ��ļ�ͷ
fwrite(fp_w,file_head_info,'double');
data=zeros(frame_len,N);
temp_data=zeros(frame_len,N);
temp=zeros(frame_len*N,1);
get_frame_num=0;
[temp,len]=fread(fp_r,frame_len*N,'double');
while ~feof(fp_r)
    now_ptr=now_ptr+frame_len;
    cal_ptr=uint32(cal_ptr+frame_len_double);
    delt_ptr=cal_ptr-now_ptr;
    fseek(fp_r,delt_ptr,'cof');
    temp_data=reshape(temp,frame_len,N);
    data=data+temp_data;
    get_frame_num=get_frame_num+1;
    [temp,len]=fread(fp_r,frame_len*N,'double'); 
end
% data=data/get_frame_num;
fwrite(fp_w,data,'double');
fclose(fp_r);
fclose(fp_w);
helpdlg('ʱƵ��������','��ʾ');
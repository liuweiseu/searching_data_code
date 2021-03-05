clear;
clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ���������������',...
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
filename=[filename,'eFreq_V2.1.dat'];
fp_w=fopen(filename,'wb');
%�����ļ�ͷ
[file_head_info,len]=fread(fp_r,512,'double');
dt=file_head_info(1);
frame_len=uint32(file_head_info(2));
delt = file_head_info(9);
now_ptr=0;
cal_ptr=0;
delt_prt=0;
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
    if(delt_prt~=0)%���������ǣ�ʵ�ʵ��ӹ����е�����Ѿ���delt�����ֳ����ˣ���������ָ��Ӧ�ûع�ͬһλ��
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
        
    if (max_delt~= delt)%���￼�ǵ��Ƕ��������
        %�����Ļ���������һ���ڵ����ݣ�Ҳ������һ���ڵ����ݣ���Ϊ�������ᵼ����һ���ڵĵ�����һ�����У������¿�ʼ���������ڵ����ݣ�Ȼ���0��ʼ
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
helpdlg('ʱƵ�������','��ʾ');

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

%�������ļ�
fp_r=fopen(filename);
frame_length = read_psr_head(fp_r);%��512�ֽ��ļ�ͷ������
%�򿪽���洢�ļ�
filename_len=length(filename);
filename(filename_len-3:filename_len)='_nob';
filename=[filename,'ase.dat'];
fp_w=fopen(filename,'wb');

%��Բ�ͬ��ʽ�����ݣ�ȷ��ȥ����ʱ��
if(frame_length == 16416)
    nobase_len = 1000;
else
    nobase_len = 100000;
end

%������ز���
dt = 1/SampFreq*ChannelNo*2*ACCNo;

%������һ���ļ����ļ�ͷ����д�������Ϣ
write_file_head=zeros(512,1);
write_file_head(1) = dt;
write_file_head(2) = frame_length;
write_file_head(6) = Start_Freq;
write_file_head(7) = Stop_Freq;
write_file_head(8) = Mode;
write_file_head(9) = ACCNo;
fwrite(fp_w,write_file_head,'double');

%ȡ���ݽ��д���
[temp_data,len]=fread(fp_r,frame_length*nobase_len,'*uint8');
    data=zeros(frame_length,nobase_len);
while ~feof(fp_r)
    data=reshape(temp_data,frame_length,nobase_len);
%     data=checkdata(data,10000);
    average=zeros(frame_length,1);
%     average=floor(mean(data,2));
    average=mean(data,2);
    average(1:32)=0;
    average_array=zeros(frame_length,nobase_len);
    average_array=repmat(average,1,nobase_len);
    data=double(data)-average_array;
    fwrite(fp_w,data,'double');
    [temp_data,len]=fread(fp_r,frame_length*nobase_len,'*uint8');
    if(len< frame_length*nobase_len)
        break;
    end
end
fclose(fp_r);
fclose(fp_w);
helpdlg('ȥ�����������','��ʾ');

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

%打开数据文件
fp_r=fopen(filename);
frame_length = read_psr_head(fp_r);%将512字节文件头读出来
%打开结果存储文件
filename_len=length(filename);
filename(filename_len-3:filename_len)='_nob';
filename=[filename,'ase.dat'];
fp_w=fopen(filename,'wb');

%针对不同格式的数据，确定去基线时间
if(frame_length == 16416)
    nobase_len = 1000;
else
    nobase_len = 100000;
end

%计算相关参数
dt = 1/SampFreq*ChannelNo*2*ACCNo;

%定义下一个文件的文件头，并写入相关信息
write_file_head=zeros(512,1);
write_file_head(1) = dt;
write_file_head(2) = frame_length;
write_file_head(6) = Start_Freq;
write_file_head(7) = Stop_Freq;
write_file_head(8) = Mode;
write_file_head(9) = ACCNo;
fwrite(fp_w,write_file_head,'double');

%取数据进行处理
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
helpdlg('去基线运算结束','提示');

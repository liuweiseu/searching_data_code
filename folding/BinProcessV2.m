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

Bin_Num=input('Bin_Num=');
% Start_Freq=input('Start_Freq(MHz)=');
% Stop_Freq=input('Stop_Freq(MHz)=');
% filename=['D:/data process/',filename];
filename_len=length(filename);
%打开读文件
fp_r=fopen(filename,'rb');
%输出文件名构成 
filename(filename_len-3:filename_len)='_Bin';
filename=[filename,'.dat'];
fp_w=fopen(filename,'wb');
%读出文件头
[file_head_info,len]=fread(fp_r,512,'double');
%从文件头中读出相应的参数
dt=file_head_info(1);
frame_len=uint32(file_head_info(2));
pulsar_period=file_head_info(3);
N=file_head_info(4);
Start_Freq=file_head_info(6);
Stop_Freq=file_head_info(7);
if(Start_Freq == 0 || Stop_Freq == 0)
    Start_Freq=input('Start_Freq(MHz)=');
    Stop_Freq=input('Stop_Freq(MHz)=');
end
 %往文件头中写入相应的参数
file_head_info(5)=Bin_Num;
Mode = file_head_info(8);
Mode = 2;

fwrite(fp_w,file_head_info,'double');
frame_per_bin=floor(N/Bin_Num);
data=zeros(frame_len,Bin_Num);
temp_data=zeros(frame_len,frame_per_bin);
temp=zeros(frame_len*frame_per_bin,1);
sum_temp=zeros(frame_len,1);
[temp,len]=fread(fp_r,frame_len*frame_per_bin,'double');
data_coloum=1;
while ~feof(fp_r)
   temp_data=reshape(temp,frame_len,frame_per_bin);
   sum_temp=sum(temp_data,2);
   data(:,data_coloum)=sum_temp;
   data_coloum=data_coloum+1;
   if(data_coloum==(Bin_Num+1))
       break;
   end
   [temp,len]=fread(fp_r,frame_len*frame_per_bin,'double');
end
fwrite(fp_w,data,'double');
fclose(fp_r);
fclose(fp_w);
x=1:Bin_Num;
delt_t=pulsar_period/Bin_Num*1000;
x=x*delt_t;
delt_freq=double((Stop_Freq-Start_Freq))/double(frame_len-32);
y=Start_Freq+double((1:(frame_len-32))*delt_freq);
pic_data=zeros(frame_len-32,Bin_Num);
pic_data(:,:)=data(33:frame_len,:);
color_map=colormap(jet(128));
% pic_data=pic_data/(max(max(pic_data)));
h=pcolor(x,y,pic_data);
set(h,'edgecolor','none','facecolor','interp');
colorbar;
xlabel('Time/ms');
% xlabel('Time/ms');
ylabel('Freq/MHz');
pic_data_sum=zeros(1,Bin_Num);
pic_data_sum=sum(pic_data);
figure;
plot(x,pic_data_sum);
xlabel('Time/ms');

%横坐标取360度
figure;
x=(1:Bin_Num);
dt=360/double(Bin_Num);
x=x*dt;
h=pcolor(x,y,pic_data);
set(h,'edgecolor','none','facecolor','interp');
title(filename);
xlabel('Pulse Phase(degrees)');
ylabel('Freq/MHz');
figure;
plot(x,pic_data_sum);
title(filename);
xlabel('Pulse Phase(degrees)');
%横坐标取1
figure;
x=(1:Bin_Num);
dt=1/double(Bin_Num);
x=double(x)*dt;
h=pcolor(x,y,pic_data);
set(h,'edgecolor','none','facecolor','interp');
title(filename);
xlabel('Phase');
ylabel('Freq/MHz');
figure;
plot(x,pic_data_sum);
title(filename);
xlabel('Phase');

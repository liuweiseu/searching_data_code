function [ filename ] = Fun_AllOnesFilter( filename )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
fp_r=fopen(filename);
%输出文件名构成
filename_len=length(filename);
filename(filename_len-3:filename_len+5)='_AllOnes.';
filename=[filename,'dat'];
fp_w=fopen(filename,'wb');
%读出文件头
[file_head_info,len]=fread(fp_r,512,'double');
%写文件头
fwrite(fp_w,file_head_info,'double');
%从文件头中提取相关数据
dt=file_head_info(1);
frame_len=uint32(file_head_info(2));
pulsar_period=file_head_info(3);
N=file_head_info(4);
%从文件中读取数据
[data,len]=fread(fp_r,frame_len*N,'double');
data_array_temp=reshape(data,frame_len,N);
data_array=data_array_temp(33:frame_len,:);
% start_colum=input('start_colum=');
% end_colum=input('end_colum=');
start_colum=1;
end_colum=N;
% Start_Freq=input('Start_512Freq(MHz)=');
% Stop_Freq=input('Stop_Freq(MHz)=');
Start_Freq=file_head_info(6);
Stop_Freq=file_head_info(7);

x=1:(end_colum-start_colum)+1;
y=1:frame_len;
x=x*dt*1000;
delt_freq=double((Stop_Freq-Start_Freq))/double(frame_len);
y=Start_Freq+double((1:(frame_len))*delt_freq);
%生成全1滤波器
% window_size=input('window_size=');
window_size=21;
filter=ones(window_size);
%用全1滤波器滤波
data_array_filter=imfilter(data_array,filter,window_size);
%滤波结果绘图
% figure;
%h=pcolor(x,y,data_array_filter(:,start_colum:end_colum));
xlabel('Time/ms');
ylabel('Freq/MHz');
title('全1滤波器滤波后瀑布图');
%set(h,'edgecolor','none','facecolor','interp');
colorbar;
%画时域图
data_array_DMfilter_sum1=sum(data_array_filter,1);
figure;
plot(x,data_array_DMfilter_sum1(start_colum:end_colum));
xlabel('Time/ms');
title('全1滤波器滤波后时域图');
%滤波结果写入文件
data_array_temp(1:frame_len,:)=data_array_filter;
data=reshape(data_array_temp,frame_len*N,1);
fwrite(fp_w,data,'double');
%关闭打开的文件
fclose(fp_r);
fclose(fp_w);

end


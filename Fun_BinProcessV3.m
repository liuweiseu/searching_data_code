function [ filename ] = Fun_BinProcessV3( filename , Bin_Num , RFI_File )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
RFI = 1;
filename_len=length(filename);
%打开读文件
fp_r=fopen(filename,'rb');
%输出文件名构成 
filename(filename_len-3:filename_len)='_Bin';
filename=[filename,'_V3.dat'];
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
Mode = file_head_info(8);
 %往文件头中写入相应的参数
file_head_info(5)=Bin_Num;
% Mode = 2;

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


% Channelnum = (frame_len-32)/Mode;
Channelnum = (frame_len)/Mode;
%打开配置文件
if(exist(RFI_File,'file') && (RFI == 1))
    cfg = load(RFI_File);
    [r,l]=size(cfg);
    if(r>0)
       for pic_mode=1:Mode
            for i = 1:r
                data((cfg(i,1)+(pic_mode-1)*Channelnum):(cfg(i,2)+(pic_mode-1)*Channelnum),:) = 0;
            end
       end
    end
end
for pic_num=1:Mode
    figure;
    x=1:Bin_Num;
    delt_t=pulsar_period/Bin_Num*1000;
    x=x*delt_t;
    delt_freq=double((Stop_Freq-Start_Freq))/double(Channelnum);
    y=Start_Freq+double((1:Channelnum)*delt_freq);
    pic_data=zeros(Channelnum,Bin_Num);
    pic_data(:,:)=data((1+Channelnum*(pic_num-1)):(Channelnum*pic_num),:);
    color_map=colormap(jet(128));
    pic_data=pic_data/(max(max(pic_data)));
    h=pcolor(x,y,pic_data);
    set(h,'edgecolor','none','facecolor','interp');
    colorbar;
    xlabel('Time/ms');
    ylabel('Freq/MHz');
    pic_data_sum=zeros(1,Bin_Num);
    pic_data_sum=sum(pic_data);
    figure;
    plot(x,pic_data_sum);
    xlabel('Time/ms');
end

end


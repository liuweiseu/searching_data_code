%本函数
%输入参数为：输入数据、起始频率，结束频率，DM值，时间分辨率
%输出参数为：输出数据
function [data_out]=DeDispersion(data_in,Start_Freq,Stop_Freq,DM,dt)
    [row,colum]=size(data_in);
    data_out=zeros(row,colum);
    data_out=data_in;%先将输入数据复制一份到输出数据中
    %计算色散参数
%     filter_len=floor(DM*4.15*10^6*(1/(Start_Freq)^2-1/(Stop_Freq)^2)/dt/1000)+1;
%     ww=zeros(row,filter_len);
    delt_freq=(Stop_Freq-Start_Freq)/double(row);
    for i=1:row
        Stop_Freq_temp=Start_Freq+double(i-1)*delt_freq;
        dtn=floor(DM*4.15*10^6*(1/(Start_Freq)^2-1/(Stop_Freq_temp)^2)/dt/1000);
        if(dtn~=0)
            data_in_temp=data_in(i,:);
            data_out(i,(dtn+1):(colum))=data_in_temp(1:(colum-dtn));
            data_out(i,1:dtn)=data_in_temp((colum-dtn+1):colum);
        else
            data_out(i,:)=data_in(i,:);
        end
%         ww(frame_len-32-i+1,filter_len-dtn)=1; 
    end
end
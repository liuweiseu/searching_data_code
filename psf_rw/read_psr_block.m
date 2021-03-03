function [ data,N,lost ] = read_psr_block( fp,frame_num )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%���������  fp---�ļ�ָ��
%           frame_num---��Ҫȡ�����ݵ�֡��
%�������ݣ�  data----���ص�����
%           N----ʵ�ʷ��ص�����֡��
%           lost---����֡��
PsrGlobals;
i = 1;
N = 0;
lost = 0;
[data_temp,len] = fread(fp,frame_num*Frame_Len,'uint8');    %һ����ȡ��Ҫ��֡�����ݳ���
if(len<(Frame_Len*frame_num))                               %������ݲ��㣬ֱ�ӷ���
    data = zeros(frame_nu,Frame_Len);
    return;
end
data_array = reshape(data_temp,frame_num,Frame_Len);              %ת���ɾ������ʽ
time_array = data_array(:,25:32);                           %ȡ��ʱ����Ϣ
time_temp = CalTime(time_array);                            %����ʱ��

i = 1;
data_p = 1;             %ָ�򻺴����ݵ�ָ��
for i = 1:frame_num
   if(time_temp(data_p)== (pre_time + ACCNo)) 
       data(i,:) = data_array(data_p,:);
       data_p = data_p + 1;
   else
       data(i,:) = 0;
       lost = lost + 1;
   end
   pre_time = pre_time + ACCNo;
end
N = frame_num;
fseek(fp,-1*Frame_Len*(frame_num+1-data_p),'cof');
end


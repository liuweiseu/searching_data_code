function [ data_out,N,lost ] = read_psr_blockV1( fp,frame_num )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%���������  fp---�ļ�ָ��
%           frame_num---��Ҫȡ�����ݵ�֡��
%�������ݣ�  data----���ص�����
%           N----ʵ�ʷ��ص�����֡��
%           lost---����֡��
PsrGlobals;
[data_temp,len] = fread(fp,Frame_Len*frame_num,'uint8');    %ȡ��Ӧ�����ݳ���
if(len<(Frame_Len*frame_num))                               %���Ƿ�ȡ���㹻������
   data_out = 0;                                                %���û�У���˵��ȡ���ļ�����ˣ���������֡��Ϊ-1
   N = -1;
   lost = 0;
   return;
end
data_array = reshape(data_temp,Frame_Len,frame_num);        %��ȡ����������֯�ɾ�����ʽ
[ lost, data ] = CheckData( data_array, ACCNo);             %�������ݼ�麯��������Ƿ񶪰�
data_out = data(33:Frame_Len,:);
fseek(fp,lost*(-1)*Frame_Len,'cof');
N = frame_num;
end
function [  ] = FindNextFrame( fp , start_time, frame_len, frame_num, delt )
%���������ֱ�Ϊ��
%1���ļ�ָ��
%2����һ֡���ݶ�Ӧ��ʱ��
%3��ÿһ֡���ݵĳ��ȣ���λ�ֽڣ�
%4����Ҫ��֡��
%5��ʱ��ļ��
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
  E_Time = start_time +  frame_num*delt; 
  while ~feof(fp)
      [data,len]=fread(fp,frame_len,'double'); 
      R_Time=CalTime(data(25:32));
      if(R_Time == E_Time)
          break;
      end
  end
  fseek(fp,-1*frame_len,'cof');
end


function [  ] = FindNextFrame( fp , start_time, frame_len, frame_num, delt )
%三个参数分别为：
%1、文件指针
%2、第一帧数据对应的时标
%3、每一帧数据的长度（单位字节）
%4、需要的帧数
%5、时标的间隔
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


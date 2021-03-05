clear;
clc;
close all;

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

N=input('N=');%输入要看的点数

fp_r=fopen(filename);
length = read_psr_head(fp_r);%read file head,retrun length

i=1;


while i<=N
   [d,t,pps]=read_psr_data(fp_r,length);
   timer(i)=t;
   i=i+1
end

plot(diff(timer));

fclose(fp_r);

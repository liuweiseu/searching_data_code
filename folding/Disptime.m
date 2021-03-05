clear;
clc;
close all;

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ���������������',...
    'D:\data process\ɫɢֵ�ϴ������');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

N=input('N=');%����Ҫ���ĵ���

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

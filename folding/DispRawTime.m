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
%   [d,n]=fread(fp_r,length,'*uint8'    );
   [d,t]=read_psr_data(fp_r,length);
   time(i,:)=t;
   i=i+1
end

dt=1/2400e6*4096*22;%time inteval
t=(0:N-1)*dt;

fclose(fp_r);
plot(time);
xlabel('Time Number');

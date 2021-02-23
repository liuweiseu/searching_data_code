clear;
clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ���������������',...
    'J:\�������');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

N=input('N=');%����Ҫ���ĵ���
%N=30000;

fp_r=fopen(filename);
length = read_psr_head(fp_r);%��512�ֽ��ļ�ͷ������

i=1;


while i<=N
%   [d,n]=fread(fp_r,2080,'*uint8');
   d=read_psr_data(fp_r,length);
   data(i)=sum(d);
   i=i+1
   
end

dt=1/2400e6*4096*ACCNo;%time inteval
t=(0:N-1)*dt;

plot(t(1:N),data);
xlabel('time(s)');title(['multichannel result of ',filename0]);
fclose(fp_r);

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

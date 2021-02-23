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

%N=input('N=');%输入要看的点数

fp_r=fopen(filename);
length = read_psr_head(fp_r);%read file head,retrun length

i=1;


%while i<=N
while 1
%   [d,n]=fread(fp_r,length,'*uint8'    );
   [d,t]=read_psr_data(fp_r,length);
   if t<0
       break;
   end
%   data(i,:)=d;
   d1(i)=d(1000);
   d2(i)=d(1005);
   i=i+1
end

dt=1/2400e6*4096*22;%time inteval
t=(0:N-1)*dt;

% plot(t(1:N),data);
% xlabel('time(s)');title(['multichannel result of ',filename0]);
fclose(fp_r);


plot(sum(data))
xlabel('channel');
title(['spectrum of ',filename0]);


while i>0

    i=input('pPls select 1st channel (-1 to skip)=');
    i1=input('pPls select 2nd channel (-1 to skip)=');
    
    if i<=0 
        break;
    end
    f1=fft(data(:,i));
    f2=fft(data(:,i1));
    dd=ifft(f);
    plot(abs(dd));
end

plot(t,sum(data'))
xlabel('time（s）');
title('sum of all channel');
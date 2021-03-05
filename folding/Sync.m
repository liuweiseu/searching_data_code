clear;
clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'H:\存数软件\');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename1= fullfile(pathname, filename0);
end
   filename2= fullfile('J:\存数软件',filename0);
   filename3= fullfile('K:\存数软件',filename0);
   filename4= fullfile('L:\存数软件',filename0);
   
N=input('N=');%输入要看的点数
%N=30000;
fp_r=zeros(4);
fp_r(1)=fopen(filename1);
fp_r(2)=fopen(filename2);
fp_r(3)=fopen(filename3);
fp_r(4)=fopen(filename4);
length = read_psr_head(fp_r(1));%将512字节文件头读出来

t=zeros(4);
for i=1:4
    [d,t(i),p]=read_psr_data(fp_r(i),length);
end



max_t=max(t);
pre_frame=zeros(0);
for i=1:4
   pre_frame(i)=(max_t-t(i))/(ACCNo+1); 
end

for i=1:4
    for j=1:pre_frame(i)
        [d,t0,p]=read_psr_data(fp_r(i),length);
    end
end
i=1;
while i<=N
    for j=1:4
        [d,t,p]=read_psr_data(fp_r(j),length);
        d_sum=sum(d);
        data(j,i)=d;
    end
   i=i+1
end

dt=1/SampFreq*(ChannelNo*2)*(ACCNo+1);%time inteval
t=(0:N-1)*dt;
for i=1:4
    plot(t(1:N),data(i));
    xlabel('time(s)');
    figure;
end

fclose(fp_r);
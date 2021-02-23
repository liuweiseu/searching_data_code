clear;
clc;
close all;
PsrGlobals
[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'J:\存数软件');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

N=100;

fp_r=fopen(filename);
len = read_psr_head(fp_r);%read file head,retrun len

i=1;


while i<=N
%   [d,n]=fread(fp_r,len,'*uint8'    );
   [d,t,pps]=read_psr_data(fp_r,len);
   d_len = length(d);
   if(ChannelNo == 2048)
    x=round((Start_CH:Stop_CH)/2048*1200)-1;
    if(Frame_Len==8224)
            subplot(2,2,1);
            plot(x,d(1:2048),'-r');
            xlabel('MHz');
            title('RR')
            subplot(2,2,2);
            plot(x,d(2049:4096),'b');
            xlabel('MHz');
            title('LL')
            subplot(2,2,3);
            plot(x,d(4097:6144),'g');
            xlabel('MHz');
            title('Re(RL*)')
            subplot(2,2,4);
            plot(x,d(6145:8192),'black')
            xlabel('MHz');
            title('Im(RL*)')
    elseif(Frame_Len==4128)
            subplot(2,1,1);
            plot(x,d(1:2048),'-r');
            xlabel('MHz');
            title('RR')
            subplot(2,1,2);
            plot(x,d(2049:4096),'b');
            xlabel('MHz');
            title('LL')
    elseif(Frame_Len==2080)
            plot(x,d(1:2048),'-r');
            xlabel('MHz');
            title('RR+LL')
    end
   elseif(ChannelNo == 512)
       x=round((1:512)/512*1200)-1;
       if(Frame_Len==2080)
            subplot(2,2,1);
            plot(x,d(1:512),'-r');
            xlabel('MHz');
            title('RR')
            subplot(2,2,2);
            plot(x,d(513:1024),'b');
            xlabel('MHz');
            title('LL')
            subplot(2,2,3);
            plot(x,d(1025:1536),'g');
            xlabel('MHz');
            title('Re(RL*)')
            subplot(2,2,4);
            plot(x,d(1537:2048),'black')
            xlabel('MHz');
            title('Im(RL*)')
      elseif(Frame_Len==1056)
            subplot(2,1,1);
            plot(x,d(1:512),'-r');
            xlabel('MHz');
            title('RR')
            subplot(2,1,2);
            plot(x,d(513:1024),'b');
            xlabel('MHz');
            title('LL')
      elseif(Frame_Len==544)
            plot(x,d(1:512),'-r');
            xlabel('MHz');
            title('RR+LL')
       end
   elseif(ChannelNo == 65536)
       x=round((Start_CH:Stop_CH)/ChannelNo*1200);
       plot(x,d);
       xlabel('MHz');
       title('RR+LL-64K');
   end
   
    pause;
end

fclose(fp_r);



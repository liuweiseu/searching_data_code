clear;
clc;
close all;

% add the path of psf_rw
addpath(genpath('../psf_rw'));

% include global parameters
PsrGlobals;

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

time=input('Pls type in the time(s):');

n = time/SamplingTime;

if(n>FrameNumOneTime)
    len = FrameNumOneTime;
else
    len = n;
end

fp = OpenPsrFile(filename);

while(n>0)
   [d,t] = ReadPsrDataFrame(fp,len);
   data = reshapre(d,ObsMode,ChannelNum);
end

plot(t(1:N),data);
xlabel('time(s)');title(['multichannel result of ',filename0]);
fclose(fp_r);

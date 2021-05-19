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
    'Please select the PSR data file',...
    '../../SearchingMode');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

fp = OpenPsrFile(filename);

status = ReadPsrHeader(fp);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

time=input('Pls type in the time(s, -1 means inf):');

% SamplingTime is in ms
dt = SamplingTime / 1000;
if(time == -1)
    requirednum = inf;
else
    requirednum = floor(time/dt);
end

fprintf('The number of required data frames is %d\n',requirednum);

if(requirednum > FrameNumOneTime)
    len = FrameNumOneTime;
else
    len = requirednum;
end

data = {[],[],[],[]};
time = [];
n = requirednum;

while(n>0 && ~feof(fp))
   [d,t] = ReadPsrDataFrame(fp,len);
   for i = 1:ObsMode
        data{i} = [data{i}; sum(d{i},2)];
   end
   time = [time;t];
   n = n - len;
   if(n<len)
       len = n;
   end
end
ClosePsrFile(fp);

first_time_info = time(1)
% set some necessary parameters here
fig_para = [[1,1];[2,1];[2,2]];
fig_title = [[{'RR+LL'},{'Reserved'},{'Reserved'},{'Reserved'}];...
             [{'RR'},{'LL'},{'Reserved'},{'Reserved'}];...
             [{'RR'},{'LL'},{'Re'},{'Im'}]];
fig_color = ['-r','-b','-g','-black'];

% x = (1:requirednum) * dt;
x = time * FFTNum/SamplingFreq;
index = nextpow2(ObsMode) + 1;
for i =1:ObsMode
        subplot(fig_para(index,1),fig_para(index,2),i);
        plot(x,data{i}/ChannelNum,fig_color(i));
        xlabel('Time/s');
        title([fig_title{index,i}]);
end

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
    '/Users/wei/Project/PSR/data');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

starttime = clock;

fp = OpenPsrFile(filename);

status = ReadPsrHeader(fp);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

baselinetime = 3;

dt = AccNum * FFTNum / SamplingFreq;

n = floor(baselinetime/dt);

remaining = {[],[0]};

%period = 0.156384121559;
period = 0.005757451936712637;

[d,t] = ReadPsrDataFrame(fp,n);
len_d = 1;

i = 0;
x = floor(period/dt);
pf_data = zeros(ChannelNum,x);
while(len_d > 0)
    % remove base line first
    baseline = mean(d{1},1);
    d{1} = d{1} - baseline;
    [tmp,remaining] = PsrFolding([remaining{1};d{1}],remaining{2},period,dt);
    pf_data = pf_data + tmp;
    [d,t] = ReadPsrDataFrame(fp,n);
    len_d = size(d,2);
    i = i + 1
end

ClosePsrFile(fp);

endtime = clock;

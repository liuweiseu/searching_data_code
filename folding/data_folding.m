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

fp = OpenPsrFile(filename);

status = ReadPsrHeader(fp);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

baselinetime = 3;

n = baselinetime / SamplingTime * 1000;

[d,t] = ReadPsrDataFrame(fp,n);
len_d = size(d,2);
remaining = {[],[0]};
period = 0.156384121559;

% remove base line first

[d,t] = ReadPsrDataFrame(fp,n);
len_d = 1;

n = floor(period/SamplingTime);
pf_data = zeros(ChannelNum,n);
while(len_d > 0)
    baseline = mean(d{1},1);
    d{1} = d{1} - baseline;
    [tmp,remaining] = PsrFolding([remaining{1};d{1}],remaining{2},period,SamplingTime);
    pf_data = pf_data + tmp;
    [d,t] = ReadPsrDataFrame(fp,n);
    len_d = size(d,2);
end

ClosePsrFile(fp);



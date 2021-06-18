clear;
clc;

% add the path of psf_rw
addpath(genpath('../psf_rw'));

% include global parameters
PsrGlobals;

% get the full path of the psr file
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

% record the start time of the this program
starttime = clock;
dp = 0.0013/252;
p0=1.187913065936;
p1=1.18803779015977;
j=0;
fprintf('cyc=%d\n',floor((p1-p0)/dp));
for period=p0:dp:p1
% open and read file header
fp = OpenPsrFile(filename);
fileinfo = dir(filename);

status = ReadPsrHeader(fp);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

% calculate the time resolution 
dt = AccNum * FFTNum / SamplingFreq;

% we need to remove base line in the data processing,
% so the time is necessary here.
% the default value is 3s.
baselinetime = 3;
n = floor(baselinetime/dt);

% init some necessary patameters here
i = 0;
x = floor(period/dt);
remaining = {[],[0]};
pf_data = zeros(ChannelNum,x);

% read data frame first, and check the len of data
[d,t] = ReadPsrDataFrame(fp,n);
len_d = size(d,2);
sum_cnt = 0;
total_cyc = floor(fileinfo.bytes/(n*FrameLen));
while(len_d > 0)
    % remove base line first
    baseline = mean(d{1},1);
    d{1} = d{1} - baseline;
    [tmp,remaining] = PsrFolding([remaining{1};d{1}],remaining{2},period,dt);
    pf_data = pf_data + tmp;
    sum_cnt = sum_cnt +1;
    [d,t] = ReadPsrDataFrame(fp,n);
    len_d = size(d,2);
    i = i + 1;
    %clc;
    %fprintf('%.2f%% of raw data has already been processed...\n',i/total_cyc*100);
end
j=j+1;
pf_data = pf_data/sum_cnt;
fprintf('i: %d Period: %.14f  Peak: %.2f\n',j,period,max(sum(pf_data)))
ClosePsrFile(fp);
end
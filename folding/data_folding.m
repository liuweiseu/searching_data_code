clear;
clc;
close all;

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

% open and read file header
fp = OpenPsrFile(filename);

status = ReadPsrHeader(fp);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

% get the period of the pulsar
[period,dm] = GetPulsarInfo('Pulsar_info.txt',deblank(SourceName));
if(period == 0)
    fprintf('Pls type in in the period of the pulsar--%s(s):',deblank(SourceName));
    period = input('');
    fprintf('Pls type in in the DM of the pulsar--%s(s):',deblank(SourceName));
    dm = input('');
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

% save data to *.pf
[path,filename,ext] = fileparts(filename);
filename = [path,'/',filename,'.pf'];
fp = fopen(filename,'wb');
% let's write 512 zeros to the file, which the original file header
tmp = zeros(1,512);
fwrite(fp,tmp,'uint8');
fseek(fp,0,'bof');
% write period to pf file
fwrite(fp,period,'double');
% write dt to pf file
fwrite(fp,dt,'double');
% write startfreq to pf file
fwrite(fp,ObsStartFreq,'double');
% write bandwidth to pf file
fwrite(fp,ObsBandwidth,'double');
% write Channelnum/row num to pf file;
fwrite(fp,ChannelNum,'double');
% write cloumn to pf file
fwrite(fp,size(pf_data,2),'double');
% write dm to pf file
fwrite(fp,dm,'double');
% skip the first 512 Bytes, which is the pf file header
fseek(fp,512,'bof');
% write pf_data to pf file
fwrite(fp,pf_data,'double');
fclose(fp);

% record the end time, so we can know how long it takes to finish the data
% processing
endtime = clock;

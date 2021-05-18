clear;
clc;
close all;

% add the path of psf_rw
addpath(genpath('../psf_rw'));

% include global parameters
PsrGlobals;

% get the full path of the psr file
[filename0, pathname] = uigetfile( ...
    {'*.pf;*.pfd','data Files';...
    '*.*','All Files' },...
    'Please select the PSR Folded data file',...
    '/Users/wei/Project/PSR/data');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

[path,name,ext] = fileparts(filename);
fp = fopen(filename);

% get period
Period = fread(fp,1,'double');
% get dt
dt = fread(fp,1,'double');
% get obs start freq
ObsStartFreq = fread(fp,1,'double');
% get obs bandwidth
ObsBandwidth = fread(fp,1,'double');
% get channelnum/row num
row = fread(fp,1,'double');
% get column num
col = fread(fp,1,'double');
% get dm
dm = fread(fp,1,'double');
% skip the pf file header
fseek(fp,512,'bof');
% get pf_data
pf_data = fread(fp,[row, col],'double');

fclose(fp);

bin = input('Pls type in the bin number(default-512; -1-Original number):');
if(length(bin) == 0)
   bin = 512;
elseif(bin == -1)
    bin = col;
end

delta_bin = floor(col/bin);
for i = 1:bin
    if(i ~= bin)
        data(:,i) = sum(pf_data(:,((i-1)*delta_bin+1):(i*delta_bin)),2)/delta_bin;
    else
        data(:,i) = sum(pf_data(:,((i-1)*delta_bin+1):(size(pf_data,2))),2)/(col-delta_bin*bin);
    end
end

dt = Period / bin * 1000;
x = (1:bin)*dt;
df = ObsBandwidth/row;
y = ObsStartFreq + (1:row)*df;
figure;
h = pcolor(x,y,data);
set(h,'edgecolor','none','facecolor','interp');
colorbar;
xlabel('Time/ms');
ylabel('Freq/MHz');
figure;
plot(x,sum(data));
xlabel('Time/ms');
title(name);

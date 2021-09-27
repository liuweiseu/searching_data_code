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
    '../../Yunnan_Data/J0835-4510_0');
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
fprintf('Channel Number: %d\n',row);
bin = input('Pls type in the bin number(default-512; -1-Original number):');

if(length(bin) == 0)
   bin = 512;
elseif(bin == -1)
    bin = col;
end

sub_band = input('Pls type in the sub bandwidth(default-df):');
if(length(sub_band) == 0)
    sub_band = -1;
end

delta_bin = floor(col/bin);
if(delta_bin == 1)
    tmp = pf_data;
else
    for i = 1:bin
        if(i ~= bin)
            tmp(:,i) = sum(pf_data(:,((i-1)*delta_bin+1):(i*delta_bin)),2)/delta_bin;
        else
            tmp(:,i) = sum(pf_data(:,((i-1)*delta_bin+1):(size(pf_data,2))),2)/(col-delta_bin*bin);
        end
    end
end
snr = Cal_SNR(sum(tmp));

if(sub_band ~= -1)
    n_band = floor(ObsBandwidth/sub_band);
    sub_ch = floor(row/n_band);
    for i=1:n_band
        data(i,:) = sum(tmp((i-1)*sub_ch+1:i*sub_ch,:));
    end
else
    data = tmp;
end
dt_bin = Period / bin * 1000;
x = (1:bin)*dt_bin;
p = (1:bin)/bin;
df = ObsBandwidth/row;
if(sub_band == -1)
    y = ObsStartFreq + (1:row)*df;
else
    y = ObsStartFreq + (1:n_band)*sub_band;
end
name=replace(name,'_','\_');
figure;
colormap(jet(128));
h = pcolor(p,y,data);
set(h,'edgecolor','none','facecolor','interp');
colorbar;
set(gca,'FontSize',14);
xlabel('Phase','FontSize',16);
ylabel('Freq/MHz','FontSize',16);
title(name,'FontSize',16);
figure;
plot(p,sum(data));grid;
set(gca,'FontSize',14);
xlabel('Phase','FontSize',16);
ylabel('Power','FontSize',16);
name = [name,'  ','SNR: ',num2str(snr)]
title(name,'FontSize',16);


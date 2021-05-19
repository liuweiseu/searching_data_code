clear;
clc;
close all;

% add the path of psf_rw
addpath(genpath('./psf_rw'));

PsrGlobals  

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Fil es' },...
    '请选择要处理的脉冲星数据',...
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
    fprintf("The file header can't be recognized\n");
    ClosePsrFile(fp);
    return;
end

i = 1;
data = [];
timeinfo = [];
len_d = 1;
while(len_d > 0)
    [d,t] = ReadPsrDataFrame(fp,10000);
    len_d = size(d,2);
    if(len_d == 0)
        break;
    end
    %[d,t] = ReadPsrDataFrame(fp,1);data(i,:) = d;
    timeinfo = [timeinfo; t];
    tmp = sum(d{1},2);
    data = [data, tmp'];
    i = i + 1
end

figure;
plot(timeinfo*FFTNum/SamplingFreq,data);
figure;
plot(diff(timeinfo));

ClosePsrFile(fp);
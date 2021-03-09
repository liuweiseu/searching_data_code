clear;
clc;
close all;

% all the psf_rw functions are in psf_rw.
path(path,'psf_rw');
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
    %[d,t] = ReadPsrDataFrame(fp,1);data(i,:) = d;
    timeinfo = [timeinfo; t];
    i = i + 1
end

figure;
plot(timeinfo);
figure;
plot(diff(timeinfo));

ClosePsrFile(fp);
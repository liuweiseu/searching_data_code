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
clock
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

fp = OpenPsrFile(filename);
status = ReadPsrHead(fp);
N = 100;
i = 1;
data = [];
timeinfo = [];
while(i<N)
    [d,t] = ReadPsrData(fp);
    data(i,:) = d;
    timeinfo(i) = t;
    i = i + 1;
end
plot(diff(timeinfo));
ClosePsrFile(fp);
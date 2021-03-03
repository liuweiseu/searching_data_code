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

fp = open_psr_file(filename);
status = read_psr_head(fp);
N = 1000;
i = 1;
data = [];
timeinfo = [];
while(i<N)
    [d,t] = read_psr_data(fp);
    data(i,:) = d;
    timeinfo(i) = t;
    i = i + 1;
end
plot(timeinfo);
close_psr_file(fp);
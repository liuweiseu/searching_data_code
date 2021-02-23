clear;
close all;
clc;

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'D:\data process\201708数据\psr_rw_v3.0处理结果');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

[ filename ] = Fun_AllOnesFilter(filename);
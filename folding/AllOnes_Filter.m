clear;
close all;
clc;

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ����������������',...
    'D:\data process\201708����\psr_rw_v3.0�������');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

[ filename ] = Fun_AllOnesFilter(filename);
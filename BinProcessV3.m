clear;
% clc;
close all;

% PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '请选择要处理的脉冲星数据',...
    'J:\存数软件');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

Bin_Num=input('Bin_Num=');
RFI=input('RFI(YES-1;NO-0):');
[ filename ] = Fun_BinProcess(filename , Bin_Num , 'shanghai.cfg' );


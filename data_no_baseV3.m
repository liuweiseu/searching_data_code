clear;
% clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Fil es' },...
    '��ѡ��Ҫ���������������',...
    '/Users/wei/Project/PSR/data');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

%�������ļ�
[ filename ] = Fun_DataNoBaseV3(filename);
helpdlg('ȥ�����������','��ʾ');
recognize
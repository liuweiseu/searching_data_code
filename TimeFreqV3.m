clear;
% clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    '��ѡ��Ҫ���������������',...
    'J:\�������');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

pulsar_period=input('pulsar_period(ms)=');
[ filename ] = Fun_TimeFreq(filename , pulsar_period);
helpdlg('ʱƵ�������','��ʾ');
% [y,Fs] = audioread('������ - �㲻�������Ŀ���.mp3');
% %���Ŷ��������
% p = audioplayer(y,Fs);
% play(p);
% a = input('�����������ַ���');
% stop(p);
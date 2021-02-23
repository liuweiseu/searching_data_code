clear;
% clc;
close all;

PsrGlobals  %define the global variable for useful parameter to be used in other program

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

pulsar_period=input('pulsar_period(ms)=');
[ filename ] = Fun_TimeFreq(filename , pulsar_period);
helpdlg('时频处理结束','提示');
% [y,Fs] = audioread('五月天 - 你不是真正的快乐.mp3');
% %播放读入的数据
% p = audioplayer(y,Fs);
% play(p);
% a = input('请输入任意字符：');
% stop(p);
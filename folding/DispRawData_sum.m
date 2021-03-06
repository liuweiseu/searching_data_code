clear;
clc;
close all;

addpath(genpath('../psf_rw'));

PsrGlobals;

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    'Please select the PSR data file',...
    '/Users/wei/Project/PSR/data');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

time=input('Pls type in the time you want to show(s)=');




while i<=N
   
end

clear;
clc;
close all;
PsrGlobals
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

fp_r=OpenPsrFile(filename);

status = ReadPsrHeader(fp_r);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

[d,t]=ReadPsrDataFrame(fp_r,1);

cho = 1;
while cho~=1
  
end

ClosePsrFile(fp_r);



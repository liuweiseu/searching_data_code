clear;
clc;
close all;

% add the path of psf_rw
addpath(genpath('../psf_rw'));

% include global parameters
PsrGlobals;

[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    'Please select the PSR data file',...
    '/Users/wei/Project/PSR/Yunnan_Data/J0835-4510_0');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

fp = OpenPsrFile(filename);

time=input('Pls type in the time(s, -1 means inf):');

[path,filename,ext] = fileparts(filename);
filename_s = [path,'/',filename,'_',int2str(time),'s.dat'];

fp_s = fopen(filename_s,'w');

status = ReadPsrHeader(fp);
if(status < 0)
    fprintf("The file header can't be recognized");
    return;
end

% SamplingTime is in ms
dt = SamplingTime / 1000;
if(time == -1)
    requirednum = inf;
else
    requirednum = floor(time/dt);
end

fseek(fp,0,'bof');
s=fread(fp,[16,32],'uchar');
tmp = zeros(16,1);
s_time = num2str(time);
for i = 1:length(s_time)
   tmp(i) = s_time(i); 
end
s(:,3)=tmp;

fwrite(fp_s,s,'uchar');

d = fread(fp,[FrameLen,requirednum],'uchar');
fwrite(fp_s,d,'uchar');
ClosePsrFile(fp);
fclose(fp_s);
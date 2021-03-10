clear;
clc;
close all;
 
% get the path of the header info file
[filename0, pathname] = uigetfile( ...
    {'*.xlsx','data Files';...
    '*.*','All Files' },...
    'Please select the header info1.1879130659361.1879130659361.187913065936 file',...
    '/Users/wei/Project/PSR/data');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

[num, txt, raw] = xlsread(filename);

fileheader = uint8(zeros(32,16));

for i = 1:size(raw)
   fileheader(i,1:length(num2str(raw{i,2}))) = num2str(raw{i,2}); 
   fprintf('%-16s: %s\n',raw{i,1},fileheader(i,:));
end

% get the path of the psr file
[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    'Please select the PSR data file',...
    '/Users/wei/Project/PSR/data');
if isequal(filename0,0)% create the name of output file
fp_w = filename
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

% create the name of output file
[filepath,name,ext] = fileparts(filename);
filename_o = [filepath,'/',name, '_m',ext];

fp_r = fopen(filename);
fp_w = fopen(filename_o,'wb');
fprintf(fp_w,'%s',fileheader');

while(~feof(fp_r))
    d = uint8(fread(fp_r,100000,'uint8'));
    fwrite(fp_w,d,'uint8');
end
fclose(fp_r);
fclose(fp_w);



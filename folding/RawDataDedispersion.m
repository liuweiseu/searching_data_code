clear;
clc;
close all;

% add the path of psf_rw
addpath(genpath('../psf_rw'));

% include global parameters
PsrGlobals;

% get the full path of the psr file
[filename0, pathname] = uigetfile( ...
    {'*.pf','data Files';...
    '*.*','All Files' },...
    'Please select the PSR Folded data file',...
    '../../SearchingMode');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end

[path,name,ext] = fileparts(filename);
fp = fopen(filename);

% get period
Period = fread(fp,1,'double');
% get dt
dt = fread(fp,1,'double');
% get obs start freq
ObsStartFreq = fread(fp,1,'double');
% get obs bandwidth
ObsBandwidth = fread(fp,1,'double');
% get channelnum/row num
row = fread(fp,1,'double');
% get column num
col = fread(fp,1,'double');
% get dm
dm = fread(fp,1,'double');
% skip the pf file header
fseek(fp,512,'bof');
% get pf_data
pf_data = fread(fp,[row, col],'double');

fclose(fp);

if(dm >= 0)
    offset_array = [];
else
    [filename0, pathname] = uigetfile( ...
    {'*.oa','data Files';...
    '*.*','All Files' },...
    'Please select the Offset Array file',...
    '../../SearchingMode');
    if isequal(filename0,0)
        disp('User selected Cancel')
        return;
    else
        oa_filename= fullfile(pathname, filename0);
    end
    offset_array = load(oa_filename); 
end

pf_data_out = DeDispersion(pf_data,ObsStartFreq,ObsBandwidth,dm,dt,offset_array);
    
% save data to *.pf
[path,filename,ext] = fileparts(filename);
filename = [path,'/',filename,'.pfd'];
fp = fopen(filename,'wb');
% let's write 512 zeros to the file, which the original file header
tmp = zeros(1,512);
fwrite(fp,tmp,'uint8');
fseek(fp,0,'bof');
% write period to pf file
fwrite(fp,Period,'double');
% write dt to pf file
fwrite(fp,dt,'double');
% write startfreq to pf file
fwrite(fp,ObsStartFreq,'double');
% write bandwidth to pf file
fwrite(fp,ObsBandwidth,'double');
% write Channelnum/row num to pf file;
fwrite(fp,ChannelNum,'double');
% write cloumn to pf file
fwrite(fp,size(pf_data,2),'double');
% write dm to pf file
fwrite(fp,dm,'double');
% skip the first 512 Bytes, which is the pf file header
fseek(fp,512,'bof');
% write pf_data to pf file
fwrite(fp,pf_data_out,'double');
fclose(fp);
disp('Dedispersion Finished!');
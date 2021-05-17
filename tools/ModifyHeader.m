clear;
clc;
close all;

raw {1,1} = 'pulsar_file_id';
raw {2,1} = 'source_name';
raw {3,1} = 'save_time';
raw {4,1} = 'observer';
raw {5,1} = 'obsdate';
raw {6,1} = 'obstime';
raw {7,1} = 'receiver';
raw {8,1} = 'obsmode';
raw {9,1} = 'channel_num';
raw {10,1} = 'vga_gain_l';
raw {11,1} = 'vga_gain_r';
raw {12,1} = 'lscale';
raw {13,1} = 'rscale';
raw {14,1} = 'digital_gain';
raw {15,1} = 'obs_start_freq';
raw {16,1} = 'obs_center_freq';
raw {17,1} = 'obs_bandwidth';
raw {18,1} = 'samplingtime';
raw {19,1} = 'az';
raw {20,1} = 'el';
raw {21,1} = 'ra';
raw {22,1} = 'dec';
raw {23,1} = 'samplingfreq';
raw {24,1} = 'fft_num';
raw {25,1} = 'acc_num';
raw {26,1} = 'pps_reset_time';
raw {27,1} = 'bit_mode';
raw {28,1} = 'start_ch';
raw {29,1} = 'stop_ch';
raw {30,1} = 'center_freq';
raw {31,1} = 'side_band';
raw {32,1} = 'reserved';

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

fp_r = fopen(filename);
d = fread(fp_r,[16,32],'uint8');
d = d';
fclose(fp_r);

fileheader=uint8(zeros(32,16));

for i = 1:size(raw)
    raw{i,2} = char(d(i,:));
    fileheader(i,1:length(num2str(raw{i,2}))) = num2str(raw{i,2}); 
end
    
sel = 0;
while(sel~=-1)
    for i = 1:size(raw)
        fprintf('%-3d- %-16s: %s\n',i,raw{i,1},fileheader(i,:));
    end
    sel = input('Which one do you want to modify?(-1:exit): ');
    if(sel>0)
        tmp = input('Pls type in the modified content:','s');
        fileheader(sel,:) = zeros(1,16);
        fileheader(sel,1:length(num2str(tmp))) = num2str(tmp); 
    end
end
fileheader = fileheader';
fp_r = fopen(filename,'rb+');
fprintf(fp_r,'%s',fileheader);
fclose(fp_r);




clear;
clc;
close all;

% add the path of psf_rw
addpath(genpath('../psf_rw'));

% include global parameters
PsrGlobals;

% get the path of the psr file
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

% set some necessary parameters here
fig_para = [[1,1];[2,1];[2,2]];
fig_title = [[{'RR+LL'},{'Reserved'},{'Reserved'},{'Reserved'}];...
             [{'RR'},{'LL'},{'Reserved'},{'Reserved'}];...
             [{'RR'},{'LL'},{'Re'},{'Im'}]];
fig_color = ['-r','-b','-g','-black'];

% calculate freq resolution
df = SamplingFreq/FFTNum;

cho = 0;
frameno = 0;
while cho~=1
    [d,t]=ReadPsrDataFrame(fp_r,1);
    index = nextpow2(ObsMode) + 1;
    x = (1:ChannelNum)*df/10^6;
    frameno = frameno + 1;
    for i =1:ObsMode
        subplot(fig_para(index,1),fig_para(index,2),i);
        plot(x,d{i},fig_color(i));
        xlabel('Freq/MHz')
        title([fig_title{index,i},'  FrameNo:',int2str(frameno)]);
    end
    cho = input('Pls input choice: 0(or none) for next;1 for exit:');
    if(cho == 1)
        cho = 1;
    else
        cho = 0;
    end
end

ClosePsrFile(fp_r);



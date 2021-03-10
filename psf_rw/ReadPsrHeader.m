function status=ReadPsrHeader(fp)

%---------------------------------
% Description:
% We will get all the necessary parameters from the file header.
% Currently, here are three file formats can be supported.
% You can get more info about file header here:
% http://10.129.19.232/weiliu/searchingmode_fileformat.git
%---------------------------------

%addpath('./ReadPsrHead');
PsrGlobals;

[file_head,n]=fread(fp,16,'*uint8');

%return to top
fseek(fp,0,'bof');

s=sprintf('%s',file_head);

status = 0;

% Three file formats can be recognized here.
if(strncmp(s,'PSF_V0100',9))
    PSF_V0100(fp);
elseif(strncmp(s,'PSF_V0101',9))
    PSF_V0101(fp);
elseif strncmp(s, 'SOURCE_NAME',11)
    PSF_V0001(fp);   
else
    status = -1;
    return;
end

    % sometimes,we only record some valid channel data, not all the data
    % so we need to re-calculate the ChannelNum, ObsStartFreq, ObsCenterFreq and ObsBandwidth here.
    df = ObsBandwidth/ChannelNum;
    ChannelNum = StopCh - StartCh + 1;
    ObsCenterFreq = ObsStartFreq + (StartCh + StopCh + 1)/2 * df;
    ObsStartFreq = ObsStartFreq + StartCh * df;
    ObsBandwidth = ChannelNum * df;
    
% initialize global parameters 
% calculate DateType and FrameHeaderSize
if(BitMode == 8)
    DataType = 'uchar';
elseif(BitMode == 16)
    DataType = 'uint16';
else
    DataType = 'uchar';
end
FrameHeaderSize = 32 * 8 / BitMode;
FrameLen = ChannelNum * ObsMode + FrameHeaderSize;
    
% init lost frame
TotalLost = [];
% read the timeinfo from the first data frame
[d] = fread(fp,8,'uint32');
TimeInfoPrevious = d(7) - AccNum;
TimeInfoNext = 0;
fseek(fp,-32,'cof');
    
% calculate FrameNumOneTime
% read 1GB from data file one time
memorysize = 0.1;
FrameNumOneTime = floor(memorysize * 1024 * 1024 * 1024 /(BitMode/8) /FrameLen);
PsfDataBuf = [];
PsfTimeInfoBuf = [];
PsfDataCnt = uint64(0);
PsfPointer = uint64(1);
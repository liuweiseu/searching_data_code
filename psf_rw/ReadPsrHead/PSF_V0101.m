function PSF_V0101(fp)

%------------------------------
% Description:
% What we did in this function
% 1. read some necessary parameters from the psf file;
% 2. initialize the global parameters;
%------------------------------

%----PSF header format v1.1----
%(pulsar_file_id)
%(source_name)
%(save_time)
%(observer)
%(obsdate)
%(obstime)
%(receiver)
%(obsmode)
%(channel_num)
%(vga_gain_1)
%(vga_gain_r)
%(lscale)
%(rscale)
%(digital_gain)
%(obs_start_freq)
%(obs_center _freq)
%(obs_bandwidth)
%(samplingtime)
%(az)
%(el)
%(ra)
%(dec)
%(samplingfreq)
%(fft_num)
%(acc_ num)
%(pps_reset_time)
%(bit_mode)
%(start_ch)
%(stop_ch)
%(center_freq)
%(side_band)
%(reserved)
%------------------------------
PsrGlobals;
    s=fread(fp,[16,32],'uchar');
    
    % get parameters from psf header.
    SourceName = sprintf('%s',s(:,2));
    SaveTime = str2num(sprintf('%s',s(:,3)));
    Observer = sprintf('%s',s(:,4));
    ObsDate = sprintf('%s',s(:,5));
    ObsTime = sprintf('%s',s(:,6));
    Receiver = sprintf('%s',s(:,7));
    ObsMode = str2num(sprintf('%s',s(:,8)));
    ChannelNum = str2num(sprintf('%s',s(:,9)));
    VgaGainL = str2num(sprintf('%s',s(:,10)));
    VgaGainR = str2num(sprintf('%s',s(:,11)));
    LScale = str2num(sprintf('%s',s(:,12)));
    RScale = str2num(sprintf('%s',s(:,13)));
    DigitalGain = str2num(sprintf('%s',s(:,14)));
    ObsStartFreq = str2num(sprintf('%s',s(:,15)));
    ObsCenterFreq = str2num(sprintf('%s',s(:,16)));
    ObsBandwidth = str2num(sprintf('%s',s(:,17)));
    SamplingTime = str2num(sprintf('%s',s(:,18)));
    Az = sprintf('%s',s(:,19));
    El = sprintf('%s',s(:,20));
    Ra = sprintf('%s',s(:,21));
    Dec = sprintf('%s',s(:,22));
    SamplingFreq = str2num(sprintf('%s',s(:,23)));
    FFTNum = str2num(sprintf('%s',s(:,24)));
    AccNum = str2num(sprintf('%s',s(:,25)));
    PPSResetTime = sprintf('%s',s(:,26));
    BitMode = str2num(sprintf('%s',s(:,27)));
    StartCh = str2num(sprintf('%s',s(:,28)));
    StopCh = str2num(sprintf('%s',s(:,29)));
    CenterFreq = str2num(sprintf('%s',s(:,30)));
    SideBand = sprintf('%s',s(:,31));
    
    % sometimes,we only record some valid channel data, not all the data
    % so we need to re-calculate the ChannelNum, ObsStartFreq, ObsCenterFreq and ObsBandwidth here.
    df = ObsBandwidth/ChannelNum;
    ChannelNum = StopCh - StartCh + 1;
    ObsCenterFreq = ObsStartFreq + (StartCh + StopCh + 1)/2 * df;
    ObsStartFreq = ObsStartFreq + StartCh * df;
    ObsBandwidth = ChannelNum * df;
    
    % initialize 
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
end


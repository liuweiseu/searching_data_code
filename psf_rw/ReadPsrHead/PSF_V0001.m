function PSF_V0001(fp)
% This is for the original file format.
% We call it file format version 0.01.
PsrGlobals;    
    
    % 1.source name
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    SourceName = deblank(p);
    % 2.save time
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    SaveTime = 60 * str2num(deblank(p));
    % 26.define observer
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    Observer = deblank(p);
    % 3.obs date
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    ObsDate = deblank(p);
    % 4.obs time
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    ObsTime = deblank(p);
    % 5.receiver
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    Receiver = deblank(p);
    % 6.obs mode
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    Mode = deblank(p);
    if(Mode == 'SINGLE')
        ObsMode = 1;
    else
        ObsMode = 2; % ??
    end
    % 7.Channel num
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    ChannelNum = str2num(deblank(p));
    % 8.vga gain l
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    VgaGainL = str2num(deblank(p));
    % 9.vga gain r
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    VgaGainR = str2num(deblank(p));
    % 10.l scale
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    LScale = str2num(deblank(p));
    % 11.r scale
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    RScale = str2num(deblank(p));
    % 12.digital gain
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    DigitalGain = str2num(deblank(p));
    % 13.obs center freq
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    ObsCenterFreq = str2num(deblank(p));
    % 14.obs bandwidth
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    ObsBandwidth = str2num(deblank(p));
    % 15.obs start freq
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    ObsStartFreq = str2num(deblank(p));
    % 16.sampling time
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    SamplingTime = str2num(deblank(p));
    % 17.az
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    Az = deblank(p);
    % 18.el
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    El = deblank(p);
    % 19.ra
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    Ra = deblank(p);
    % 20.dec
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    Dec = deblank(p);
    % 21.samplingfreq
    fread(fp,20,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    clkfreq = str2num(deblank(p));
    SamplingFreq = clkfreq * 8;    
    % 22.acc_num
    fread(fp,100,'*uint8');
    p = fread(fp,60,'*uint8');
    p = sprintf('%s',p);
    AccNum = str2num(deblank(p))+1;
    % 23.define fft num
    FFTNum = ChannelNum * 2;
    % 24.define start_ch
    StartCh = 0;
    % 25.define stop_ch
    StopCh = ChannelNum-1;
    % 27.define sideband
    SideBand = 'USB';
    % 28.define bitmode
    BitMode = 8;
    % 29.define center freq
    CenterFreq = ObsStartFreq + ObsBandwidth/2;
    
    % 30.pps reset time
    fread(fp,20,'*uint8');
    s = sprintf('%s',p);
    if strncmp(s, 'PPSRSTTIME',10)%if have PPSRSTTIME
        PPSResetTime = fread(fp,60,'uint8');
    else
        fseek(fp,-20,'cof');
        PPSResetTime = '00000000000000';
    end
end


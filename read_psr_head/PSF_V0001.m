function PSF_V0001(fp)
% This is for the original file format.
% We call it file format version 0.01.
PsrGlobals;    
    Type = 3; 
    r=2080;
    
    fread(fp,80*7+20-20,'*uint8');%skip the unused head    
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ChannelNum=str2num(p);%数据通道数；
    
    fread(fp,80*5+20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ObsCenterFreq=str2num(p);%中心频率；
    
    fread(fp,20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ObsBandwidth=str2num(p);%带宽；
    
    ObsStartFreq = ObsCenterFreq-(ObsBandwidth/2);
    ObsStopFreq = ObsCenterFreq+(ObsBandwidth/2);
    
    fread(fp,6*80+20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ClockFPGA=str2num(p);%FPGA工作频率；
    
    fread(fp,20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    PARA=str2num(p);%PARA??单通道FFT通道数；
    
    SamplingFreq=ClockFPGA*2*ChannelNum/PARA;
    
    fread(fp,20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ACCNum=str2num(p)+1;%功率谱累积次数；
    
    p=fread(fp,20,'uint8');
    s=sprintf('%s',p);
    
    if strncmp(s, 'PPSRSTTIME',10)%if have PPSRSTTIME
        PPSResetTime = fread(fp,60,'uint8');
    else
        fseek(fp,-20,'cof');
        PPSResetTime = '0'
    end
    FrameLen = r;
    Type = 3; 
end


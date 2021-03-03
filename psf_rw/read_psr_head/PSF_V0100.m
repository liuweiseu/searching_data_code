function PSF_V0100_2048(fp)
PsrGlobal;
    Type = 1;    
    s=fread(fp,[16,32],'uchar');
    ObsMode=str2num(sprintf('%s',s(:,8)));
    if(ObsMode==1)
        FrameLen=2080;
    elseif(ObsMode==2)
        FrameLen=4128;
    elseif(ObsMode==4)
        FrameLen=8224;
    end
    ChannelNum=str2num(sprintf('%s',s(:,9)));
    ObsCenterFreq=str2num(sprintf('%s',s(:,16)));
    ObsBandwidth=str2num(sprintf('%s',s(:,17)));
    SamplingFreq=str2num(sprintf('%s',s(:,23)));
    ACCNum=str2num(sprintf('%s',s(:,25)))+1;
    PPSResetTime=[sprintf('%s',s(:,26)),sprintf('%s',s(:,27))];
    ObsStartFreq = ObsCenterFreq-(ObsBandWidth/2);
    ObsStopFreq = ObsCenterFreq+(ObsBandWidth/2);
end


function [d,t]=ReadPsrData(fp)
%read the data from psr file
%   return ; d--the data
PsrGlobals
% check if memory buffer is empty
if(PsfDataCnt == 0)
    PsfPointer = 1;
    [PsfDataBuf,PsfDataCnt] = fread(fp,[FrameLen,FrameNumOneTime],DataType);
    PsfDataBuf = PsfDataBuf';
end

% check if we still have frame los
if(LostFrames > 0)
    d = zeros(ObsMode,ChannelNum);
    TimeInfoNext = TimeInfoPrevious + AccNum;
    t = TimeInfoNext;
    TimeInfoPrevious = TimeInfoNext;
    return;
end

% read frame head first, and get timeinfo
%tmp = fread(fp,8,'uint32');
tmp = PsfDataBuf(PsfPointer:(PsfPointer+FrameHeaderSize-1),1);
PsfPointer = PsfPointer + FrameHeaderSize;
PsfDataCnt = PsfDataCnt -  FrameHeaderSize;

if (DataType == 'uchar')
    TimeInfoNext = tmp(28)*2^24 + tmp(27)*2^16 + tmp(26)*2^8 + tmp(25);
elseif(DataType == 'uint16')
    TimeInfoNext = tmp(14)*2^16 + tmp(13);
end
% check delta_t
dt = TimeInfoNext - TimeInfoPrevious;
if(dt == AccNum)
    %d = fread(fp,[ObsMode,ChannelNum],DataType);
    tmp = PsfDataBuf(PsfPointer:(PsfPointer + ObsMode*ChannelNum - 1),1);
    PsfPointer = PsfPointer + ObsMode * ChannelNum;
    PsfDataCnt = PsfDataCnt - ObsMode * ChannelNum;
    d = reshape(tmp,ObsMode,ChannelNum);
    t = TimeInfoNext;
    TimeInfoPrevious = TimeInfoNext;
else 
    LostFrames = dt/AccNum - 1;
    TotalLost(length(TotalLost)+1) = LostFrames;
    d = zeros(ObsMode,ChannelNum);
    TimeInfoNext = TimeInfoPrevious + AccNum;
    t = TimeInfoNext;
    TimeInfoPrevious = TimeInfoNext;
    %fseek(fp,-32,0);
    PsfPointer = PsfPointer - FrameHeaderSize;
    PsfDataCnt = PsfDataCnt + FrameHeaderSize;
end
end


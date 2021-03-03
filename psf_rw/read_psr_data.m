function [d,t]=read_psr_data(fp)
%read the data from psr file
%   return ; d--the data
PsrGlobals
% check if we still have frame los
if(LostFrames > 0)
    d = zeros(ObsMode,ChannelNum);
    TimeInfoNext = TimeInfoPrevious + AccNum;
    t = TimeInfoNext;
    TimeInfoPrevious = TimeInfoNext;
    return;
end

% read frame head first, and get timeinfo
tmp = fread(fp,8,'uint32');
TimeInfoNext = tmp(7);
% check delta_t
dt = TimeInfoNext - TimeInfoPrevious;
if(dt == AccNum)
    d = fread(fp,[ObsMode,ChannelNum],DataType);
    t = TimeInfoNext;
    TimeInfoPrevious = TimeInfoNext;
else 
    LostFrames = dt/AccNum - 1;
    TotalLost(length(TotalLost)+1) = LostFrames;
    d = zeros(ObsMode,ChannelNum);
    TimeInfoNext = TimeInfoPrevious + AccNum;
    t = TimeInfoNext;
    TimeInfoPrevious = TimeInfoNext;
    fseek(fp,-32,0);
end
end


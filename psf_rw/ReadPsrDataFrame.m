function [d,t]=ReadPsrDataFrame(fp,len)

%---------------------------------------
% Description:
% The function will return the len frames.
%---------------------------------------
len = uint64(len);
PsrGlobals
% check if the size of the buffer is large enough
% if not, let's enlarge the buffer size
if(len>FrameNumOneTime)
    FrameNumOneTime = len;
end
% check if there is enough data in the buffer
remaining = 1 + PsfDataCnt - PsfPointer;
if(remaining < len)
    % move the data in the buffer from the buffer end to the head
    PsfDataBuf = PsfDataBuf(PsfPointer:PsfDataCnt,:);
    PsfTimeInfoBuf = PsfTimeInfoBuf(PsfPointer:PsfDataCnt,:);
    PsfPointer = 1;
    PsfDataCnt = remaining;
    % check if it's the end of the file
    if(feof(fp))
        d = {};
        t = [];
        return;
    end
    % read new data from psf file
    [DataBuf] = fread(fp,[FrameLen,FrameNumOneTime],DataType);
    % it will be faster to do data processing with matrix transpose
    DataBuf = DataBuf';
    [tmp_d, tmp_t, tmp_cnt] = CheckMemTimeInfo(DataBuf);
    PsfDataBuf = [PsfDataBuf; tmp_d];
    PsfTimeInfoBuf = [PsfTimeInfoBuf; tmp_t];
    PsfDataCnt = PsfDataCnt + tmp_cnt;
end

% return d and t
try
    tmp = PsfDataBuf(PsfPointer:(PsfPointer + len -1),:);
    t = PsfTimeInfoBuf(PsfPointer:(PsfPointer + len -1),:);
    PsfPointer = PsfPointer + len;
catch
    tmp = PsfDataBuf(PsfPointer:PsfDataCnt,:);
    t = PsfTimeInfoBuf(PsfPointer:PsfDataCnt,:);
    PsfPointer = PsfDataCnt + 1;
end

% we have 3 obs modes, so we need to think more on the format of output data  
for i = 1:ObsMode
    d{i} = tmp(:,((i-1)*ChannelNum+1):(i*ChannelNum));
end

end


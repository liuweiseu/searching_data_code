function [d,t]=ReadPsrDataFrame(fp,len)

%---------------------------------------
% Description:
% The function will return the len frames.
%---------------------------------------

PsrGlobals
% check if there is enough data in the buffer
remaining = PsfDataCnt - PsfPointer + 1;
if(remaining < len)
    % move the data in the buffer from the buffer end to the head
    PsfDataBuf = PsfDataBuf(PsfPointer:PsfDataCnt,:);
    PsfTimeInfoBuf = PsfTimeInfoBuf(PsfPointer:PsfDataCnt,:);
    PsfPointer = 1;
    PsfDataCnt = remaining;
    % read new data from psf file
    DataBuf = fread(fp,[FrameLen,FrameNumOneTime],DataType);
    % it will be faster to do data processing with matrix transpose
    DataBuf = DataBuf';
    [tmp_d, tmp_t, tmp_cnt] = CheckMemTimeInfo(DataBuf);
    PsfDataBuf = [PsfDataBuf; tmp_d];
    PsfTimeInfoBuf = [PsfTimeInfoBuf; tmp_t];
    PsfDataCnt = PsfDataCnt + tmp_cnt;
end

% return d and t
d = PsfDataBuf(PsfPointer:(PsfPointer + len -1),:);
t = PsfTimeInfoBuf(PsfPointer:(PsfPointer + len -1),:);
PsfPointer = PsfPointer + len;
end


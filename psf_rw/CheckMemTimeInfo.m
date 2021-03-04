function [d,cnt] = CheckmMemTimeInfo(buf)
PsrGlobals;  
    [r,c] = size(buf);
    % get time info
    if(DataType == 'uchar')
        t = buf(:,28)*2^24 + buf(:,27)*2^16 + buf(:,26)*2^8 + buf(:,25);
    elseif(DataType == 'uint16')
        t = buf(:,14)*2^16 + buf(:,13);
    end

end


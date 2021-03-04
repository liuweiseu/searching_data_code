function [d,cnt] = CheckmMemTimeInfo(buf)

%----------------------------------------
% Description:
% In this function, we will check the timeinfo in the mem buffer, so that we will know if there is frame loss.
% If we have frame loss, correct timeinfo and zeros will be added for compensation.
%----------------------------------------

PsrGlobals;  
    [r,c] = size(buf);
    % get time info
    if(DataType == 'uchar')
        t = buf(:,28)*2^24 + buf(:,27)*2^16 + buf(:,26)*2^8 + buf(:,25);
    elseif(DataType == 'uint16')
        t = buf(:,14)*2^16 + buf(:,13);
    end
frameloss = diff(t)/AccNum-1;

if(max(frameloss) == 1)
    % no frame loss, that's great!
    d = buf;
    cnt = r;
else
    for i = 1:length(frameloss)
        if(frameloss(i) > 0)
            % record the frame lost first
                TotalLost(length(TotalLost)+1) = frameloss(i);
            % then, create the lost frames 
                tmp = [buf(i,1:32),zeros(1,ChannelNum)];
                framecomp = repmat(tmp,frameloss(i),1);
                index = i + sum(TotalLost);
                if(DataType == 'uchar')
                    t = buf(index,28)*2^24 + buf(index,27)*2^16 + buf(index,26)*2^8 + buf(index,25);
                elseif(DataType == 'uint16')
                    t = buf(index,14)*2^16 + buf(index,13);
                end
                for j = 1:length(frameloss(i))
                    timeinfotmp = t + j * AccNum;
                    if(DataType == 'uchar')
                        framecomp(i,25) = bitand(timeinfotmp,255);
                        framecomp(i,26) = bitand(bitshift(timeinfotmp,-8),255);
                        framecomp(i,27) = bitand(bitshift(timeinfotmp,-16),255);
                        framecomp(i,28) = bitand(bitshift(timeinfotmp,-24),255);
                    elseif(DataType == 'uint16')
                        framecomp(i,13) = bitand(timeinfotmp,65535);
                        framecomp(i,14) = bitand(bitshift(timeinfotmp,-16),65535);
                    end
                % put the data back to the frame.
                
                end
                
        end
    end
end

end


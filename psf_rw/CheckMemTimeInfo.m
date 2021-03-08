function [d,t,cnt] = CheckmMemTimeInfo(buf)

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
    d = buf(:,33:FrameLen);
    cnt = r;
elseif(DataType == 'uint16')
    t = buf(:,14)*2^16 + buf(:,13);
    d = buf(:,17:FrameLen);
    cnt = r;
end

% first, check the whole data
frameloss = diff(t)/AccNum-1;
loss = 0;
if(max(frameloss) == 0)
    % no frame loss, that's great!
    d = d;
    t = t;
    cnt = cnt;
else
    for i = 1:length(frameloss)
        if(frameloss(i) > 0)
            % first, create the lost frames
            index = i + loss;
            timeinfo = t(index);
            [tmp_d,tmp_t] = CompensateLoss(timeinfo,frameloss(i));
            % put the data back to the frame.
            d = [d(1:index,:);tmp_d;d(index:cnt,:)]; 
            t = [t(1:index,1);tmp_t;t(index:cnt,:)];
            cnt = cnt + frameloss(i);
            % record the frame lost
            TotalLost(length(TotalLost)+1) = frameloss(i);
            loss = loss + frameloss(i);
        end
    end
end

% then, check the timeinfo from the beginning of the file
TimeInfoNext = t(1);
lost = (TimeInfoNext - TimeInfoPrevious)/AccNum - 1;
if(lost > 0)
    % record the frame lost first
    TotalLost(length(TotalLost)+1) = lost;
    [loss_d, loss_t] = CompensateLoss(TimeInfoPrevious,lost);
    d = [loss_d; d];
    t = [loss_t, t];
    cnt = cnt + lost;
end
TimeInfoPrevious = t(cnt);

end


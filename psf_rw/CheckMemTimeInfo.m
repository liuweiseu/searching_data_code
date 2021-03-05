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
   
frameloss = diff(t)/AccNum-1;

if(max(frameloss) == 1)
    % no frame loss, that's great!
    d = d;
    t = t;
    cnt = cnt;
else
    for i = 1:length(frameloss)
        if(frameloss(i) > 0)
            % record the frame lost first
            TotalLost(length(TotalLost)+1) = frameloss(i);
            % then, create the lost frames 
            tmp_d = zeros(frameloss(i),ChannelNum);
            index = i + sum(TotalLost);
            timeinfo = t(index);
            tmp_t = zeros(frameloss(i),1);
            for j = 1:length(frameloss(i))
                tmp_t(j,1) = timeinfo + j * AccNum;
            end
            % put the data back to the frame.
            upframeno = i + sum(TotalLost);
            downframeno = cnt-upframeno;
            d = [d(1:upfameno,:);tmp_d;d(downframeno:cnt,:)]; 
            t = [t(1:upframeno,1);tmp_t;t(downframeno:cnt,:)];
            cnt = cnt + frameloss(i);
        end
    end
end

end


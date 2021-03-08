function [d,t] = CompensateLoss(timeinfo,len)

%-------------------------------------------
% Description:
% this function is used for conpensating for the data frame loss
% it will return the data frames with correct timeinfo and all-zero data
%-------------------------------------------

PsrGlobals;

d = zeros(len,ChannelNum*ObsMode);
t = zeros(len,1);
for i = 1:length(len)
    t(i,1) = timeinfo + i * AccNum;
end

end


function [ lost, data_out ] = CheckData( data_in, delt)
%lost-------表明这一包数据中丢包多少帧
%data_out---表明返回的数据
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [frame_len , N] = size(data_in);
    data_out = zeros(frame_len,N);
%     temp_data=reshape(data,frame_len,N);
    time_array=data_in(25:32,:);
    time_temp=CalTime(time_array);
    diff_time = diff(time_temp);
    sum_diff_time = sum(diff_time);
    X = (sum_diff_time/delt);
    Y = mod(sum_diff_time,delt);
    if(Y~=0)
        lost = -1;          %时标错误
        data_out = zeros(frame_len,N);
    elseif(X == (N-1))      %正常情况（可能出现了时标错误，但是一段错误之后又回归正常了，并且在错误的状态下依旧保持连续）
        lost = 0;
        data_out = data_in;
    elseif(X >(N-1))
        lost = X-(N-1);
        data_out = zeros(frame_len,N);
        figure;
        plot(diff_time);
    elseif(X < (N-1))
        lost = -2;          %时标异常
        data_out = zeros(frame_len,N);
        plot(diff_time);
    end
end


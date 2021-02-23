function [ lost, data_out ] = CheckData( data_in, delt)
%lost-------������һ�������ж�������֡
%data_out---�������ص�����
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
        lost = -1;          %ʱ�����
        data_out = zeros(frame_len,N);
    elseif(X == (N-1))      %������������ܳ�����ʱ����󣬵���һ�δ���֮���ֻع������ˣ������ڴ����״̬�����ɱ���������
        lost = 0;
        data_out = data_in;
    elseif(X >(N-1))
        lost = X-(N-1);
        data_out = zeros(frame_len,N);
        figure;
        plot(diff_time);
    elseif(X < (N-1))
        lost = -2;          %ʱ���쳣
        data_out = zeros(frame_len,N);
        plot(diff_time);
    end
end


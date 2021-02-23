function [ time ] = CalTime(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [r,c]=size(data);
    time(1:c) = data(1,1:c)+data(2,1:c)*256+data(3,1:c)*256^2+data(4,1:c)*256^3+data(5,1:c)*256^4+data(6,1:c)*256^5+data(7,1:c)*256^6+data(8,1:c)*256^7;
end


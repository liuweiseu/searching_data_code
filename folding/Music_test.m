clear;
clc;
[y,Fs] = audioread('������ - �㲻�������Ŀ���.mp3');
%���Ŷ��������
p = audioplayer(y,Fs);
play(p);
a = input('�����������ַ���');
stop(p);
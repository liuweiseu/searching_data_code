clear;
clc;
[y,Fs] = audioread('五月天 - 你不是真正的快乐.mp3');
%播放读入的数据
p = audioplayer(y,Fs);
play(p);
a = input('请输入任意字符：');
stop(p);
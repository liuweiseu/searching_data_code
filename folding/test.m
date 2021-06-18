for i = 0:9
    tmp(i+1,:)=sum(data(600*i+1:600*(i+1),:));
end
y_tmp=1:10;
figure
colormap(jet(128));
h = pcolor(x,y_tmp,tmp);
set(h,'edgecolor','none','facecolor','interp');
colorbar;
xlabel('Time/ms');
ylabel('Freq/MHz');
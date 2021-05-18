function [data_out]=DeDispersion(data_in,Start_Freq,Bandwidth,DM,dt,offset_array)
    if(length(offset_array)~=0)
        Use_Array = 1;
    else
        Use_Array = 0;
    end
    [row,colum]=size(data_in);
    data_out=zeros(row,colum);
    data_out=data_in;
    delt_freq=Bandwidth/double(row);
    for i=1:row
        Stop_Freq_temp=Start_Freq+double(i-1)*delt_freq;
        if(Use_Array == 0)
            dtn = floor(DM*4.15*10^6*(1/(Start_Freq)^2-1/(Stop_Freq_temp)^2)/dt/1000);
        else
            dtn = offset_array(i); 
            dtn = rem(dtn,colum);
        if(dtn~=0)
            data_in_temp=data_in(i,:);
            data_out(i,(dtn+1):(colum))=data_in_temp(1:(colum-dtn));
            data_out(i,1:dtn)=data_in_temp((colum-dtn+1):colum);
        else
            data_out(i,:)=data_in(i,:);
        end
    end
end
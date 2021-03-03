function [d,t,pps]=read_psr_data(fp,len)
%read the data of psr file according to the psr type
%   return ; d--the data
PsrGlobals
per_len = (len-32)/Mode;
if feof(fp)
    t=-1;
    d=-1;
    pps=-1;
else
    frame_head=fread(fp,6,'uint32'); %24
    t=fread(fp,1,'uint64');% 8
    if(Type ==2) 
        pps=frame_head(3); 
    else
        pps=0;
    end
    if (ChannelNo == 2048)
        if (Frame_Len == 2080 || Frame_Len == 4128 )
            d=fread(fp,len-32,'uint8');
        elseif(Frame_Len == 8224)
            d(1:(2*per_len))=fread(fp,Frame_Len-32-2*per_len,'int8');
            d((2*per_len+1):(per_len*4))=fread(fp,2*per_len,'int8');
        end
    elseif(ChannelNo == 512)
        if(Frame_Len == 544 || Frame_Len == 1056 )
            d=fread(fp,len-32,'uint8');
        elseif(Frame_Len == 2080)
            d(1:1024)=fread(fp,Frame_Len-32-1024,'int8');
            d(1025:2048)=fread(fp,1024,'int8');
        end
    elseif(ChannelNo == 65536)
        d=fread(fp,len-32,'uint8');
    else
        d=0;
        t=0;
        pps=0;
    end
end


function r=read_psr_head(fp)
%read the head of psr file according to the psr type
%   return ; r--the length of the data package

PsrGlobals  %define the global variable for useful parameter to be used in other program

[file_head,n]=fread(fp,20,'*uint8');

s=sprintf('%s',file_head);

%�������ļ�ͷ���������ݴ����йصĲ�����������Ҫ������ν���Щ�������ظ����ó����Ա����ݴ���ʱʹ��
%�����Ϊ���ز������������ݹ��ࡣ���Կ��ǽ��䶨��Ϊglobal������
    

if strncmp(s, 'PSF_V0100_2048',14)%psf format v1.0
    Type = 1;
    r=2080;
%    fread(fp,512-20,'*uint8');%skip the unused head

    fseek(fp,0,'bof');%return to top
    s=fread(fp,[16,32],'uchar');
    Mode=str2num(sprintf('%s',s(:,8)));%ģʽѡ��
    if(Mode==1)
        r=2080;
    elseif(Mode==2)
        r=4128;
    elseif(Mode==4)
        r=8224;
    end
    ChannelNo=str2num(sprintf('%s',s(:,9)));%����ͨ������
    CenterFreq=str2num(sprintf('%s',s(:,16)));%����Ƶ�ʣ�
    BandWidth=str2num(sprintf('%s',s(:,17)));%����
    SampFreq=str2num(sprintf('%s',s(:,23)));%������
    
    ACCNo=str2num(sprintf('%s',s(:,25)))+1;%�������ۻ�������32
    PPSRSTTIME=[sprintf('%s',s(:,26)),sprintf('%s',s(:,27))];
    Start_Freq = CenterFreq-(BandWidth/2);
    Stop_Freq = CenterFreq+(BandWidth/2);
    Frame_Len = r;
elseif strncmp(s, 'PSF_V0101_2048',14)%psf format v1.1
    Type = 2;
    r=2080;
%    fread(fp,512-20,'*uint8');%skip the unused head

    fseek(fp,0,'bof');%return to top
    s=fread(fp,[16,32],'uchar');
    Mode=str2num(sprintf('%s',s(:,8)));%ģʽѡ��
    if(Mode==1)
        r=2080;
    elseif(Mode==2)
        r=4128;
    elseif(Mode==4)
        r=8224;
    end
    ChannelNo=str2num(sprintf('%s',s(:,9)));%����ͨ������
    CenterFreq=str2num(sprintf('%s',s(:,16)));%����Ƶ�ʣ�
    BandWidth=str2num(sprintf('%s',s(:,17)));%����
    SampFreq=str2num(sprintf('%s',s(:,23)));%������
        
    ACCNo=str2num(sprintf('%s',s(:,25)))+1;%�������ۻ�������32
    PPSRSTTIME=[sprintf('%s',s(:,26)),sprintf('%s',s(:,27))];
    Start_Freq = CenterFreq-(BandWidth/2);
    Stop_Freq = CenterFreq+(BandWidth/2);
    Start_CH = str2num(sprintf('%s',s(:,28)))+1;
    Stop_CH = str2num(sprintf('%s',s(:,29)))+1;
    if(length(Start_CH) ~= 0)
       r = 32+(Stop_CH-Start_CH+1)*Mode;
    else
        Start_CH = 1;
        Stop_CH = 2048;
    end
    Frame_Len = r;
 elseif strncmp(s, 'PSF_V0101_65536',15)%psf format v1.1
    Type = 2;
    r=2080;
%    fread(fp,512-20,'*uint8');%skip the unused head

    fseek(fp,0,'bof');%return to top
    s=fread(fp,[16,32],'uchar');
    Mode=str2num(sprintf('%s',s(:,8)));%ģʽѡ��
    r=65536+32;
    ChannelNo=str2num(sprintf('%s',s(:,9)));%����ͨ������
    CenterFreq=str2num(sprintf('%s',s(:,16)));%����Ƶ�ʣ�
    BandWidth=str2num(sprintf('%s',s(:,17)));%����
    SampFreq=str2num(sprintf('%s',s(:,23)));%������
        
    ACCNo=str2num(sprintf('%s',s(:,25)))+1;%�������ۻ�������32
    PPSRSTTIME=[sprintf('%s',s(:,26)),sprintf('%s',s(:,27))];
    Start_Freq = CenterFreq-(BandWidth/2);
    Stop_Freq = CenterFreq+(BandWidth/2);
    Start_CH = 1;
    Stop_CH = 65536;
    Frame_Len = r;  
elseif strncmp(s, 'PSF_V0101_512',13)%psf format v1.1
    Type = 2;
%    fread(fp,512-20,'*uint8');%skip the unused head

    fseek(fp,0,'bof');%return to top
    s=fread(fp,[16,32],'uchar');
    Mode=str2num(sprintf('%s',s(:,8)));%ģʽѡ��
    if(Mode==1)
        r=544;
    elseif(Mode==2)
        r=1056;
    elseif(Mode==4)
        r=2080;
    end
    ChannelNo=str2num(sprintf('%s',s(:,9)));%����ͨ������
    CenterFreq=str2num(sprintf('%s',s(:,16)));%����Ƶ�ʣ�
    BandWidth=str2num(sprintf('%s',s(:,17)));%����
    SampFreq=str2num(sprintf('%s',s(:,23)));%������
        
    ACCNo=str2num(sprintf('%s',s(:,25)))+1;%�������ۻ�������32
    PPSRSTTIME=[sprintf('%s',s(:,26)),sprintf('%s',s(:,27))];
    Start_Freq = CenterFreq-(BandWidth/2);
    Stop_Freq = CenterFreq+(BandWidth/2);
    Frame_Len = r;
elseif strncmp(s, 'SOURCE_NAME',11)%old psf format,without version no,but has head information
    Type = 3; 
    r=2080;
    
    fread(fp,80*7+20-20,'*uint8');%skip the unused head    
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ChannelNo=str2num(p);%����ͨ������
    
    fread(fp,80*5+20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    CenterFreq=str2num(p);%����Ƶ�ʣ�
    
    fread(fp,20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    BandWidth=str2num(p);%����
    
    Start_Freq = CenterFreq-(BandWidth/2);
    Stop_Freq = CenterFreq+(BandWidth/2);
    
    fread(fp,6*80+20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ClockFPGA=str2num(p);%FPGA����Ƶ�ʣ�
    
    fread(fp,20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    PARA=str2num(p);%PARA??��ͨ��FFTͨ������
    
    SampFreq=ClockFPGA*2*ChannelNo/PARA;
    
    fread(fp,20,'*uint8');%skip the unused head
    p=fread(fp,60,'*uint8');
    p=sprintf('%s',p);
    ACCNo=str2num(p)+1;%�������ۻ�������
    
    p=fread(fp,20,'uint8');
    s=sprintf('%s',p);
    
    if strncmp(s, 'PPSRSTTIME',10)%if have PPSRSTTIME
        PPSRSTTIME=fread(fp,60,'uint8');
    else
        fseek(fp,-20,'cof');
        PPSRSTTIME='0'
    end
     Frame_Len = r;
    
else%unknow format, no head information,
    r=0;%% could be changed according to the type 
    fseek(fp,0,'bof');
end

%[file_head,n]=fread(fp,512,'*uint8')


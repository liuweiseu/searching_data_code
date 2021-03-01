function status=read_psr_head(fp)
%read the head of psr file according to the psr type
%   return ; r--the length of the data package

% add the func path
path(path,'read_psr_head');

[file_head,n]=fread(fp,16,'*uint8');

fseek(fp,0,'bof');%return to top

s=sprintf('%s',file_head);

status = 0;
%�������ļ�ͷ���������ݴ����йصĲ�����������Ҫ������ν���Щ�������ظ����ó����Ա����ݴ���ʱʹ��



if(strncmp(s,'PSF_V0100',9))
    PSF_V0100(fp);
elseif(strncmp(s,'PSF_V0101',9))
    PSF_V0101(fp);
elseif strncmp(s, 'SOURCE_NAME',11)%old psf format,without version no,but has head information
    PSF_V0001(fp);   
else%unknow format, no head information,
    fprintf("The file can't be recognized!");
    status = -1;
end


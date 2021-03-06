function status=ReadPsrHeader(fp)

%---------------------------------
% Description:
% We will get all the necessary parameters from the file header.
% Currently, here are three file formats can be supported.
% You can get more info about file header here:
% http://10.129.19.232/weiliu/searchingmode_fileformat.git
%---------------------------------

addpath('./ReadPsrHead');

[file_head,n]=fread(fp,16,'*uint8');

%return to top
fseek(fp,0,'bof');

s=sprintf('%s',file_head);

status = 0;

% Three file formats can be recognized here.
if(strncmp(s,'PSF_V0100',9))
    PSF_V0100(fp);
elseif(strncmp(s,'PSF_V0101',9))
    PSF_V0101(fp);
elseif strncmp(s, 'SOURCE_NAME',11)
    PSF_V0001(fp);   
else
    fprintf("The file can't be recognized!");
    status = -1;
end


function status = ClosePsrFile(fp)
   status = 0;
   try
       fclose(fp);
   catch
       status = -1;
   end
end


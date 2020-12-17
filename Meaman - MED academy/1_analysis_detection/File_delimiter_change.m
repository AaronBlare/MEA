



 [filename, pathname] = uigetfile('*.*','Select file') ;
 file_with_path_name = [pathname filename] ;
 
 
 fid  = fopen( file_with_path_name , 'r' ); 
  
tline = fgetl(fid);
k = strfind(tline, ',');

if ~isempty( k )

    lines2 = {};
    li = 1;


    while ischar(tline) 
        tline =strrep( tline ,',','.') ; 
        lines2{ li } =  tline   ;
        li = li + 1;
        tline = fgetl(fid);
    end

    fclose(fid);

    fid = fopen(file_with_path_name  , 'w');
    fprintf(fid, '%s \n', lines2{ :}  );
    fclose(fid);

else
fclose(fid);
end












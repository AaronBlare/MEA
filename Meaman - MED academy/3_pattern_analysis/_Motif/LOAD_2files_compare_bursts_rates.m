
% LOAD_2files_compare_bursts_rates
 
tic



[filename, pathname] = uigetfile('*.*','Select file') ;
 [filename2, pathname2] = uigetfile('*.*','Select file') ;
 cd( pathname ) ;   
    

% 
%              [pathname,name,ext,versn] =  fileparts( filename ) ; 
%              [pathname2,name,ext,versn] = fileparts( filename2 ) ; 
%             

            filename
            filename2
            if filename ~= 0 
            Init_dir = cd ;

              Compare2files_bursts_rates

            end
            
            
toc





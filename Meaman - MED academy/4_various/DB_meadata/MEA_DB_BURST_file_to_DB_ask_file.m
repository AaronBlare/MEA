


% MEA_DB_BURST_file_to_DB_ask_file


    [filename, pathname0] = uigetfile('*.*','Select file') ;
 
    if filename
       [pathname,name,ext,versn] = fileparts( filename ) ;
  
       if ext == '.mat' 
           
           Experiment_name = name ;
           
           MEA_DB_BURST_file_to_DB_from_file
            % Input:  pathname0  filename
            
           
       end  
        
       
    end
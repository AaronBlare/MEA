
% Process one file or file list
% ANALYSIS_ARG.Select_file - should be true for file dialog
% ANALYSIS_ARG.FILE_LIST_PROCESS - if true then choose txt file with file
% list

n_files = 1 ;
if ANALYSIS_ARG.FILE_LIST_PROCESS  
    [filename,PathName] = uigetfile('*.*','Select file');
    if filename ~= 0 
        fullname = [PathName filename ];  
        file_list = dataread('file', fullname , '%s', 'delimiter', '\n');
%         filename = [ filenames_med filenames_mcd ];
        n_files = size(file_list ) ;
        n_files = n_files(1) ;
    end 
end




for fi = 1 :1: n_files

%++++++++++++ Choose file +++++++++++++++++++++++
    if ANALYSIS_ARG.Select_file
        [filename, pathname] = uigetfile('*.*','Select file') ; 
    end

    if ANALYSIS_ARG.FILE_LIST_PROCESS
         filename = file_list{ fi}  
         [pathname,filename,ext,versn] =  fileparts( filename ) ; 
    end
%-----------------------------------------------------    

%++++++++++++ Load files +++++++++++++++++++++++
        load( [pathname filename] )
        if ~isempty( pathname )
            cd( pathname ) ;
        end
        [pathstr,name,ext,versn] = fileparts ( filename ) ;
        File_name_x =name;
%-----------------------------------------------------        
    
%++++++++++++ Process loaded data here +++++++++++

%-------------------------------------------------
                

% Colelct results for file list
     if ANALYSIS_ARG.FILE_LIST_PROCESS
         close all
         eval(['save ' name '_RSpercent_5_to_40.mat RS_threshold_value_all Learning_curve_all -mat']); 
     end


end









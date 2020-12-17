
%  MED_AWSR_Find_Bursts
function MED_AWSR_Find_Bursts_LOAD( TimeBin , AWSR_sig_tres , save_bursts_to_files , ANALYSIS_ARG , Search_Params)  

% input:
% ANALYSIS_ARG.FILE_LIST_PROCESS_defined
% ANALYSIS_ARG.FILE_LIST_PROCESS_file_list 

Pathname = [] ;

if nargin == 0
% if TimeBin == null
% TimeBin = 1000 ; % super burst
TimeBin = 50 ; % burst
AWSR_sig_tres = 1 ;
end

% MAX_SPIKES_PER_CHANNEL_AT_BURST = 1000 ;



if nargin == 0
ANALYSIS_ARG.FILE_LIST_PROCESS = false ; % 'y'-process list of files specefied in textfile
SIGMATRES = 8 ;
end


file_in = 'n' ;
    if ANALYSIS_ARG.FILE_LIST_PROCESS  ~= true
        [filename,Pathname] = uigetfile('*.*','Select file');
        if filename ~= 0
           file_in = 'y' ; 


            c_file = filename ;
            [pathstr,name,ext] = fileparts( c_file ) ;
            % DATA_TYPE = ext ;
            init_dir = cd ;
            cd(  Pathname );
            DIR =[ pathstr Pathname ];
            n_files = 1 ;
            Pathname ; 
        end
    else
    % file_list = textread(files ,'%s');
    init_dir = cd ;
    init_dir_list = cd ;
    
        if ANALYSIS_ARG.FILE_LIST_PROCESS_defined
            
            file_list = ANALYSIS_ARG.FILE_LIST_PROCESS_file_list;
            file_list{:}
            n_files = length(file_list )  
            file_in = 'y' ;
        else
        % [filename, PathName] = uigetfile('*.*','Select file', 'MultiSelect', 'on') ;
            files = uipickfiles
            if length( files) > 1
                file_in = 'y' ;
            else    
            % if filename(1) ~= 0
               file_in = 'y' ;
            % end 
            end

            if file_in == 'y' 
            init_dir = cd ;
            % file_list 
            file_list = files ;
            file_list{:}
            n_files = length(file_list )  
            end
        end

    end

if file_in == 'y' 
for k= 1:n_files %---------------------------------------------------
    
if ANALYSIS_ARG.FILE_LIST_PROCESS 
    c_file = char( file_list{ 1, k } ) 
    [Pathname,name,ext] = fileparts( c_file ) ;
    % DATA_TYPE = ext ;
    % init_dir = cd ;
    % cd(init_dir_list);
    cd(Pathname);
    dir = c_file( 1 : strfind(   c_file , '.') -1  ) ;
end   
c_file = [Pathname  c_file ] ;

Search_Params.Arg_file.Pathname = Pathname ;
 MED_AWSR_Find_Bursts( c_file ,  Search_Params)  ;
 if n_files > 1
    pause_seconds = 5
    pause(5)
     close all
    fclose('all') ;
    
 end
end



end

cd( init_dir ) ;
clear;

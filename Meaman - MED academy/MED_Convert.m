% PROGRAM MED_Convert
function MED_Convert( SIGMATRES , FILE_LIST_PROCESS , ARTEFACTS_ON , sigma_from_sec ,  sigma_to_ms ,Auto_burst_analysis  , ...
    PostStimulusResponse , Search_Params , Arg_plus  )

% input: .mcd, .med & .dat, .txt file with raw signals
% output: new folder Analyzed_x with x_Raster.txt and x_artifacts.txt
% (stimulation artifacts raster)
% Alex Pimashkin, October 2010, Neuro.nnov.ru


PosStim_Interval_start = PostStimulusResponse.PosStim_Interval_start  ;
PosStim_Interval_end = PostStimulusResponse.PosStim_Interval_end   ;
Artefact_channel = PostStimulusResponse.Artefact_channel  ;


Analyze_all_files_in_subfolders=  Arg_plus.Analyze_all_files_in_subfolders ;
if Analyze_all_files_in_subfolders
    FILE_LIST_PROCESS = 'y';
end

%  Auto_burst_analysis
AutoPostStimulusResponse = PostStimulusResponse.AutoPostStim ;
%  Analyze_all_files_in_subfolders

if nargin == 0
    FILE_LIST_PROCESS = 'n' ; % 'y'-process list of files specefied in textfile
    SIGMATRES = 8 ;
    ARTEFACTS_ON=false;
    sigma_from_sec=0;
    sigma_to_ms=0;
end

if nargin == 5
    TimeBin = 50 ;
    AWSR_sig_tres = 0.01;
    Auto_burst_analysis = false ;
end

Auto_burst_analysis;
AutoPostStimulusResponse;

MCD_converting = false;

init_dir = cd ;

file_in = 'n' ;

Arg_plus.FILE_LIST_PROCESS = false ;
if FILE_LIST_PROCESS  ~= 'y'
    [filename,PathName] = uigetfile('*.*','Select file');
    
    Arg_plus.filename = filename ;
    Arg_plus.PathName = PathName ;
    Arg_plus.FILE_LIST_PROCESS = false ;
    
    if filename ~= 0
        file_in = 'y' ;
        fullname = [PathName filename ];
        c_file = fullname ;
        %         c_file = filename ;
        [pathstr,name,ext ] = fileparts( c_file ) ;
        if strcmpi(ext,'.mcd') || strcmpi(ext,'.h5')
            MCD_converting=true ;
            newdirnameA = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_A' ] ;
            newdirnameB = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_B' ] ;
        end
        % DATA_TYPE = ext ;
        %         init_dir = cd ;
        cd(  PathName );
        newdirname = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES,'% 10.1f') '_sigma' ] ;
        %         mkdir(  newdirname  );
        %     cd(  newdirname );
        Dest_dir = newdirname;
        DIR =[ pathstr newdirname ];
        n_files = 1 ;
    end
else
    % list_files = textread(files ,'%s');
    %     init_dir = cd ;
    % Analyze_all_files_in_subfolders;
    if Analyze_all_files_in_subfolders == true
        folder_name = uigetdir ;
        filenames_med = dir2( folder_name ,'.med');
        filenames_mcd = dir2( folder_name ,'.mcd');
        filename = [ filenames_med filenames_mcd ];
        
        n_files = length(filename ) ;
        n_files
        for k= 1:n_files
            [pathstr,name,ext ] = fileparts( filename{ k } ) ;
            PathName_all_subfolders{k} = pathstr ;
        end
        init_dir_list = cd ;
        file_in = 'y' ;
        list_files = filename ;
        
    else
        
        init_dir_list = cd ;
        [filename, PathName] = uigetfile('*.*','Select file', 'MultiSelect', 'on') ;
        if length( filename) > 1
            file_in = 'y' ;
        else
            if filename(1) ~= 0
                file_in = 'y' ;
            end
        end
        
        if file_in == 'y'
            %         init_dir = cd ;
            % list_files
            list_files = filename ;
            list_path = PathName ;
            list_files{:}
            n_files = length(list_files ) ;
            Arg_plus.FILE_LIST_PROCESS = true ;
        end
        
    end
end

if file_in == 'y'
    for k= 1:n_files %---------------------------------------------------
        
        if FILE_LIST_PROCESS == 'y'
            c_file = char( list_files{ k } ) ;
            
            if Analyze_all_files_in_subfolders == true
                c_path = PathName_all_subfolders{k} ;
                PathName =  c_path ;
                fullname  =  c_file  ;
            else
                c_path = PathName ;
                fullname  =  [ c_path  c_file ] ;
            end
            c_path
            
            c_file = fullname ;
            [pathstr,name,ext ] = fileparts( c_file ) ;
            if strcmpi(ext,'.mcd') || strcmpi(ext,'.h5')
                MCD_converting=true ;
                newdirnameA = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_A' ] ;
                newdirnameB = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_B' ] ;
            end
            % DATA_TYPE = ext ;
            % init_dir = cd ;
            cd(init_dir_list);
            dir = c_file( 1 : strfind(   c_file , '.') -1  ) ;
            newdirname = [ 'Analyzed_' char(name) '_'  num2str(SIGMATRES,'% 10.1f') '_sigma' ] ;
            cd(  PathName  );
            %         mkdir(  newdirname  );
            %         cd( newdirname ) ;
        end
        
        Mea_flag = 'A';
        artefacts_trains_number = 0 ;
        if MCD_converting
            if Search_Params.analyze_A_mea
                Mea_flag = 'A';
                
                Arg_plus.Artefact_file = [] ;
                if Search_Params.ARTEFACTS_ON
                    
                    Arg_plus.filename = c_file ;
                    Arg_plus.PathName = [] ;
                    
                    
                    fffa = Arg_plus.Post_stim_potentials_collect ;
                    
                    Arg_plus.Post_stim_potentials_collect =false ;
                    
                    channel_to_analyze = Search_Params.channel_to_analyze ;
                    [ Artefact_file , artefacts_trains_number , ...
                        artefacts_files ,artefacts , Artefact_PathName ]   =  MED_Convert_1ch_artefact( SIGMATRES , 'n' , ...
                        ARTEFACTS_ON , sigma_from_sec ,  sigma_to_ms ,channel_to_analyze , Arg_plus )
                    Arg_plus.Post_stim_potentials_collect  = fffa ;
                    Arg_plus.Artefact_file = Artefact_file;
                    Arg_plus.Artefact_Path = Artefact_PathName;
                    Artefact_PathName
                    Artefact_file
                    Arg_plus.artefacts_all = artefacts ;
                end
                
                if artefacts_trains_number > 0
                    
                    
                    for ai = 1 : artefacts_trains_number
                        
                        Artefact_file = artefacts_files{ ai } ;
                        Artefact_file = c_file ;
                        Arg_plus.Artefact_file = Artefact_file;
                        
                        Figure_prefix_global = [ 'Part ' num2str( ai ) ', '] ;
                        Arg_plus.Figure_prefix_global = Figure_prefix_global;
                        Arg_plus.Post_stim_potentials_collect
                        
                        cd(  PathName  );
                        newdirnameA = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_A_part' num2str( ai ) ] ;
                        mkdir(  newdirnameA  );
                        cd( newdirnameA ) ;
                        [Result_MAT_file , Raster_file] = MED_Convert_file ( c_file , SIGMATRES , ARTEFACTS_ON , sigma_from_sec , ...
                            sigma_to_ms , newdirnameA , Mea_flag ,  Arg_plus   )   ;
                    end
                    
                    
                else
                    newdirnameA = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_A'] ;
                    if( length( newdirnameA )) > 100
                        namex = name( 1: 40 );
                        newdirnameA = [ 'Analyzed_' char(namex) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_A'] ;
                    end
                    cd(  PathName  );
                    mkdir(  newdirnameA  );
                    cd( newdirnameA )
                    
                    
                    if ~isempty( Arg_plus.Artefact_file  )
                        if isempty( Arg_plus.Artefact_Path )
                            cc = Arg_plus.Artefact_file    ;
                        else
                            cc = [ Arg_plus.Artefact_Path  '\' Arg_plus.Artefact_file  ];
                        end
                        
                        newdirnameA
                        Artefact_file_c = cc
                        curr_dir = cd
                        
                        copyfile( Artefact_file_c  , curr_dir )
                    end
                    
                    [Result_MAT_file , Raster_file] = MED_Convert_file( c_file , SIGMATRES , ARTEFACTS_ON , sigma_from_sec , ...
                        sigma_to_ms , newdirnameA , Mea_flag ,  Arg_plus   )   ;
                    
                    
                    
                    
                end
                
                
                if Auto_burst_analysis == true
                    MED_AWSR_Find_Bursts( Result_MAT_file , Search_Params )
                    close all
                end
                
                
                if AutoPostStimulusResponse == true
                    
                    %              from Meamanx...
                    %
                    %              Params.TimeBin = TimeBin ;
                    %             Params.AWSR_sig_tres = AWSR_sig_tres ;
                    %             Params.Search_Params = Search_Params ;
                    
                    %             Stim_response( Diap_ms , MAX_RESPONSE_DUR , Take_all_spikes_after_stim, ...
                    %                     DT_bin , Artefact_channel,0,true, checkbox5msBin  ,Params  );
                    
                    % Stim_response
                    %           PostStim = Search_Params.PostStim ;
                    
                    shows = true ;
                    if isfield( Arg_plus  , 'FILE_LIST_PROCESS' )
                        if Arg_plus.FILE_LIST_PROCESS
                            shows = false ;
                        end
                    end
                    
                    
                    
                    [ POST_STIM_RESPONSE ] =   Stim_response( Search_Params.PosStim_Interval_start  , Search_Params.PosStim_Interval_end ...
                        , Search_Params.Take_all_spikes_after_stim,Search_Params.DT_bin , Search_Params.Artefact_channel ...
                        ,Result_MAT_file, shows , Search_Params.checkbox5msBin  ,Search_Params  );
                    
                    
                    
                    %  [ POST_STIM_RESPONSE ] = Stim_response( Post_stim_interval_start ,Post_stim_interval_end , ...
                    %     Take_all_spikes_after_stim , DT_bin , ...
                    %       Artefact_channel, filename , SHOW_FIGURES , checkbox5msBin , Params )
                    
                    
                    %            Stim_response( PostStimulusResponse.PosStim_Interval_start ,PostStimulusResponse.PosStim_Interval_end ,...
                    %                true , PostStimulusResponse.DT_bin , PostStimulusResponse.Artefact_channel, Result_MAT_file , false ,false)
                    %             close all
                end
                
                
            end
            
            
            if Search_Params.analyze_B_mea
                Mea_flag = 'B';
                
                
                
                if Search_Params.ARTEFACTS_ON
                    fffa = Arg_plus.Post_stim_potentials_collect ;
                    
                    Arg_plus.Post_stim_potentials_collect =false ;
                    
                    channel_to_analyze = Search_Params.channel_to_analyze ;
                    [ Artefact_file , artefacts_trains_number , ...
                        artefacts_files ]   =  MED_Convert_1ch_artefact( SIGMATRES , 'n' , ...
                        ARTEFACTS_ON , sigma_from_sec ,  sigma_to_ms ,channel_to_analyze , Arg_plus )
                    Arg_plus.Post_stim_potentials_collect  = fffa ;
                    Arg_plus.Artefact_file = Artefact_file;
                end
                
                if artefacts_trains_number > 0
                    
                    
                    for ai = 1 : artefacts_trains_number
                        
                        Artefact_file = artefacts_files{ ai } ;
                        Artefact_file
                        Arg_plus.Artefact_file = Artefact_file;
                        
                        Figure_prefix_global = [ 'Part ' num2str( ai ) ', '] ;
                        Arg_plus.Figure_prefix_global = Figure_prefix_global;
                        
                        
                        cd(  PathName  );
                        newdirnameB = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_B_part' num2str( ai ) ] ;
                        mkdir(  newdirnameB );
                        cd( newdirnameB ) ;
                        [Result_MAT_file , Raster_file] = MED_Convert_file ( c_file , SIGMATRES , ARTEFACTS_ON , sigma_from_sec , ...
                            sigma_to_ms , newdirnameB , Mea_flag ,  Arg_plus   )   ;
                    end
                    
                    
                else
                    newdirnameB = [ 'Analyzed_' char(name) '_' num2str(SIGMATRES  ,'% 10.1f') '_sigma_B' ] ;
                    cd(  PathName  );
                    mkdir(  newdirnameB  );
                    cd( newdirnameB ) ;
                    [Result_MAT_file , Raster_file] = MED_Convert_file ( c_file , SIGMATRES , ARTEFACTS_ON , sigma_from_sec , ...
                        sigma_to_ms , newdirnameB , Mea_flag ,  Arg_plus   )   ;
                end
                
                
                if Auto_burst_analysis == true
                    MED_AWSR_Find_Bursts( Result_MAT_file , Search_Params )
                    close all
                end
                
                
                if AutoPostStimulusResponse == true
                    %            Stim_response( PostStimulusResponse.PosStim_Interval_start ,PostStimulusResponse.PosStim_Interval_end ,...
                    %                true , PostStimulusResponse.DT_bin , PostStimulusResponse.Artefact_channel, Result_MAT_file , false ,false)
                    %             close all
                    
                    [ POST_STIM_RESPONSE ] =   Stim_response( Search_Params.PosStim_Interval_start  , Search_Params.PosStim_Interval_end ...
                        , Search_Params.Take_all_spikes_after_stim,Search_Params.DT_bin , Search_Params.Artefact_channel ...
                        ,0,true, Search_Params.checkbox5msBin  ,Params  );
                    close all
                    
                end
                
            end
        end
        fclose('all') ;
    end
    
    
    
end

cd( init_dir ) ;
clear;

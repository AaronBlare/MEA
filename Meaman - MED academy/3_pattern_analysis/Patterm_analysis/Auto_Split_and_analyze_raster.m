% Auto_Split_and_analyze_raster

a = get(handles.edit33 ,'String'); 
split_interval = str2num( a )*1000;  % -ms

split_interval = 120 * 1000 ;

N = 64 ;

if (get(handles.checkboxInNewFoldeer,'Value') == get(handles.checkboxInNewFoldeer,'Max'))
    In_new_Dir =true ;
else
    In_new_Dir = false ;
end

if (get(handles.checkboAutoBurstsAnalysis,'Value') == get(handles.checkboAutoBurstsAnalysis,'Max'))
    Auto_Analyze_Bursts =true ;
else
    Auto_Analyze_Bursts = false ;
end
  
params.split_interval = split_interval ;


[filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;

 
if filename ~= 0
index_r0 = load( char( filename ) ) ;   

whos index_r 
split_interval=params.split_interval;
Tmax = max( index_r0( : , 1 ) ) ;

file_list = {} ;
All_files_data_TOTAL_cell = cell(1,1 ,1 );
All_files_data_TOTAL_cell_filed_names =[];

GLOBAL_CONSTANTS_load
    %--- Burst analysis parameters --------------------
    Find_bursts_GUI_input
    %     Search_Params.SsuperBurst_scale_sec  
    %     Search_Params.TimeBin  
    %     Search_Params.AWSR_sig_tres 
    %     Search_Params.save_bursts_to_files  
    %     Search_Params.List_files2 
    %     Search_Params.Arg_file 
    %---------------------------------------------------

file_number = 0 ;

Connects_min_tau_diff_THR = 0 ;
Strength_THR = 0 ;

for Ti = 0 : split_interval : Tmax+100 - split_interval ;
    Edit_from =  Ti  
    Edit_to = Ti + split_interval ;
    file_number
    params.add_prefix = [ '_' num2str( file_number ) '_' ] ;
    ss = find( index_r0( : , 1 ) >= Edit_from & index_r0( : , 1 ) < Edit_to ) ;
    if ~isempty( ss )
        index_r = []; 
        index_r = index_r0( ss , : )  ;
        index_r0( ss , : ) = [] ;
        
        file_number=file_number+1;
    
       File_string_prefix = [ '_' num2str( file_number ) '_' ] ;
     
       
%        index_r


       Search_Params.Analyze_Connectiv  = false ;
       params.show_figures = true ;
       Data_type = 'spontaneous' ;
       
       Find_bursts_from_raster
      % input:
      % index_r
      % Search_Params.show_figures
      % Search_Params.Simple_analysis
      % Search_Params.Filter_Superbursts
      % Search_Params.Filter_small_Superbursts
      % Search_Params.Simple_analysis                                    
      % output - ANALYZED_DATA ;
      
 
      
                                     bursts_absolute = ANALYZED_DATA.bursts_absolute ;
    %                                    bursts  = ANALYZED_DATA.bursts ;
                                       Spike_Rates = ANALYZED_DATA.Spike_Rates ;
                                       Firing_Rates_each_channel_mean = ANALYZED_DATA.Firing_Rates_each_channel_mean ;
                                       Spike_Rates_each_channel_mean = ANALYZED_DATA.Spike_Rates_each_channel_mean ;
                                       Nb = ANALYZED_DATA.Number_of_Patterns ;
                                       s = size( ANALYZED_DATA.Spike_Rates ) ;
                                       N = s( 2 ) ;

                                       if isfield( ANALYZED_DATA , 'Burst_Data_Ver' )
                                        Burst_Data_Ver = ANALYZED_DATA.Burst_Data_Ver ;
                                       end

                                        Patterns_analysis_connectivity 
      
                                        

                                        
                                        
                                        
    close all                                    
       
     All_files_data_TOTAL_cell{ 1 , file_number } = ANALYZED_DATA.Analysis_data_cell ;
     All_files_data_TOTAL_cell{ 2 , file_number } = ANALYZED_DATA.Connectiv_data ;     
     All_files_data_TOTAL_cell_filed_names  = ANALYZED_DATA.Analysis_data_cell_field_names ;
 
     clear ANALYZED_DATA    
 
    end
         


end


%----- test all N conn vs min tau and min strength ----------------
Connectiv_Test_all_Nconn_vs_mintau_minM

 
end


















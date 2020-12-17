
function [ Analysis_data_cell_buf , Connectiv_data_buf , Analysis_data_cell_field_names ]  = ...
                Split_raster_into_periods_and_analyze( RASTER_data , Global_flags )
% input : RASTER_data
% output:
% Analysis_data_cell_buf

index_r0 = RASTER_data.index_r  ;
file_list = {} ;
Connectiv_data_buf = [] ;
Analysis_data_cell_buf = [] ;

split_interval = Global_flags.Split_raster_period_min  ;
Tmax = Global_flags.Max_raster_time_min  ;

% translate to ms
split_interval = split_interval * 60 * 1000 ;
Tmax = Tmax * 60 * 1000 ;

 Burst_Data_Ver =  Global_flags.Burst_Data_Ver;
Search_Params = Global_flags.Find_bursts_GUI_input_Search_Params ;

% GLOBAL_CONSTANTS_load 

file_number = 0 ; 
 
for Ti = 0 : split_interval : Tmax+100 - split_interval ;
    Edit_from =  Ti  
    Edit_to = Ti + split_interval ;
%     file_number
%     params.add_prefix = [ '_' num2str( file_number ) '_' ] ;
    ss = find( index_r0( : , 1 ) >= Edit_from & index_r0( : , 1 ) < Edit_to ) ;
    if ~isempty( ss )
        index_r = []; 
        index_r = index_r0( ss , : )  ;
        index_r0( ss , : ) = [] ;
        
        file_number=file_number+1;
    
       File_string_prefix = [ '_' num2str( file_number ) '_' ] ;
     
       
%        index_r


       Search_Params.Analyze_Connectiv  = true ;
       params.show_figures = true ;
       Search_Params.Show_figures = true ;
       Data_type = 'spontaneous' ;
       Burst_flags.raster_start_time_min = Edit_from ;
       Burst_flags.raster_end_time_min = Edit_to ;
       TimeBin = Search_Params.TimeBin ;
       
       Find_bursts_from_raster
      % input:
      % index_r
      % Search_Params.show_figures
      % Search_Params.Simple_analysis
      % Search_Params.Filter_Superbursts
      % Search_Params.Filter_small_Superbursts
      % Search_Params.Simple_analysis                                    
      % output - ANALYZED_DATA ;
      
 
%       
%                                      bursts_absolute = ANALYZED_DATA.bursts_absolute ;
%     %                                    bursts  = ANALYZED_DATA.bursts ;
%                                        Spike_Rates = ANALYZED_DATA.Spike_Rates ;
%                                        Firing_Rates_each_channel_mean = ANALYZED_DATA.Firing_Rates_each_channel_mean ;
%                                        Spike_Rates_each_channel_mean = ANALYZED_DATA.Spike_Rates_each_channel_mean ;
%                                        Nb = ANALYZED_DATA.Number_of_Patterns ;
%                                        s = size( ANALYZED_DATA.Spike_Rates ) ;
%                                        N = s( 2 ) ;
% 
%                                        if isfield( ANALYZED_DATA , 'Burst_Data_Ver' )
%                                         Burst_Data_Ver = ANALYZED_DATA.Burst_Data_Ver ;
%                                        end
% 
%                                        Patterns_analysis_connectivity 
      
                                        

                                        
                                        
                                        
    close all                                    
       
    Analysis_data_cell_buf = [  Analysis_data_cell_buf     ANALYZED_DATA.Analysis_data_cell  ];
    Connectiv_data_buf = [ Connectiv_data_buf   ANALYZED_DATA.Connectiv_data  ]; 
    Analysis_data_cell_field_names = ANALYZED_DATA.Analysis_data_cell_field_names ;
     
     
      clear ANALYZED_DATA    
 
    end
         


end

file_number;



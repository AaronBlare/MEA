


function Comp_result_TOTAL_RATE = CONN_LIST_EX_Total_rate_Compare_2_data_sets( ALL_cell , file_1 , file_2   ,   Global_flags ) 
 %+++++++++++++++++++++++++++++
 

SpikeRate_patterns_field_names = {'Spike_Rates' ,  'TimeBin_Total_Spikes_mean'  , 'TimeBin_Total_Spikes_std'  , ... 
    'Spike_Rates_each_channel_mean' , 'Spike_Rates_each_channel_std' , 'Number_of_Patterns' , 'Spike_Rates_each_burst' , 'DT_bin' , 'Spike_Rate_Signature_1ms_smooth' ...
            'Spike_Rate_1ms_smooth_Max_corr_delay' , 'Spike_Rates_Signature' , 'burst_activation_mean' , ...
           'burst_activation_2_mean'  , 'burst_activation' , 'Spike_Rate_1ms_Max_corr_delay' , 'Spike_Rate_1ms_smooth_Max_corr_delay' , ...
         'burst_activation_3_smooth_1ms_mean' , 'burst_max_rate_delay_ms_mean' }  ;
% SpikeRate_patterns_field_names = ALL_cell.Analysis_data_cell_field_names;

Patterns1 = [] ;
for di = 1 : length( SpikeRate_patterns_field_names ) 
    Patterns1 = setfield( Patterns1 ,SpikeRate_patterns_field_names{ di }  , [] );
    Name_index = strmatch( SpikeRate_patterns_field_names{ di }  , ALL_cell.Analysis_data_cell_field_names , 'exact');           
    if ~isempty( Name_index )
    Patterns1.( SpikeRate_patterns_field_names{ di } )  = cell2mat( ALL_cell.Analysis_data_cell( file_1 , Name_index(1)  ))  ; 
    end
end
Patterns1.Channels_active = ones(  length( Patterns1.Spike_Rates_each_channel_mean ) ,1 )  ;

file_i =2 ;

Patterns2 = [] ;
for di = 1 : length( SpikeRate_patterns_field_names ) 
    Patterns2 = setfield( Patterns2 ,SpikeRate_patterns_field_names{ di }  , [] );
    Name_index = strmatch( SpikeRate_patterns_field_names{ di }  , ALL_cell.Analysis_data_cell_field_names , 'exact');   
    if ~isempty( Name_index )
    Patterns2.( SpikeRate_patterns_field_names{ di } )  = cell2mat( ALL_cell.Analysis_data_cell( file_2 , Name_index(1)  ) ) ; 
    end
end
Patterns2.Channels_active = ones(  length( Patterns2.Spike_Rates_each_channel_mean ) ,1 )  ;
Patterns1.Flags(1) = 1 ; 

        TOTAL_RATE = [] ;
        flags.Selectivity_figure_title = 'Burst analysis' ;
        flags.TOTAL_RATE = TOTAL_RATE;
        flags.Compare_channel_difference_spikes_min = Global_flags.Compare_channel_difference_spikes_min ;
        if isfield( Global_flags , 'buffer' )
        flags.Erase_some_channels = Global_flags.buffer.Erase_some_channels ;
        end
        
        if isfield( Global_flags , 'Min_spikes_per_channel_compare' )
           flags.Min_spikes_per_channel_compare = Global_flags.Min_spikes_per_channel_compare ;
        end
        
        OVERLAP_TRESHOLD = 25 ;
        STIM_RESPONSE_BOTH_INPUTS = 0 ;
        SHOW_FIGURES = Global_flags.show_figures_channle_spikerate_compare ;
        Count_zero_values = true ;
        
        [ Comp_result_TOTAL_RATE  ] ...
            = Selective_Channels_by_Rate_in_Patterns(Patterns1 , Patterns2 , OVERLAP_TRESHOLD , STIM_RESPONSE_BOTH_INPUTS , SHOW_FIGURES , ...
            Count_zero_values , flags );
        % output 
%         Comp_result_TOTAL_RATE

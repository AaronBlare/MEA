
% Connectivity_parameters_init


Simple_fitting = false ; % - true=poly fitting false=leFeber fitting
No_fitting = true ; % true-smooth curve and find peak
Interpolate_fitting = true ;
                          smooth_fit_type = 'loess' ; % 'rloess' 'loess' 'moving'
                          smooth_window = GLOBAL_const.Connectiv_smooth_spike_transfer_characteristic ;
                          measure_time_of_fitting = false ;
                          
Parralel_computing = true ; 
Mex_function_metod = 3 ; % 1-spike_transfer.cpp , 2-spike_transfer_fast01.cpp 3- Sp_trans_fast_01.cpp
% Mex_function_metod = 1 ;
Comp_type = 2 ; 
Use_mex_func = true ;
Show_fit_plot = false ;
tau_max_figure_thres = 0 ;
Test_different_smooth_filters = false ;
fit_only_where_spikes_many = true ;
 
Pause_on_first_M_of_tau = true ;
% dt = 10 ; % = 1/ 0.1 = 1/ ( 1/10000 Hz  * 1000 [ms] )
% dt=10 - best fits using Sp_trans_fast_02.cpp 

%  Nb= floor( Nb / 6 ) ;
%  Nb_erase_index = 1 : s(1) - Nb - 1;
%  whos bursts
%  bursts( Nb_erase_index  , : , : ) = [] ;
%  whos bursts
  
Extract_data_to_cells = true ;    
Multiply_all_spike_times_by_dt = false ; 



    Connectiv_data.params.Simple_fitting = Simple_fitting ;
    Connectiv_data.params.show_figures = true ;
    Connectiv_data.params.Conn_Spikes_num_min = GLOBAL_const.Connectiv_min_spikes_per_channel ;
    Connectiv_data.params.tau_delta = 1 ;
    Connectiv_data.params.tau_delta_interp = 0.1 ;
    Connectiv_data.params.tau_max = 100 ;
    Connectiv_data.params.tau_max_sign =  1 ; % if tau_max < 0 then analyze spikes recieved, otherwise -spikes transferred 
    Connectiv_data.params.tau_number = 1 + floor( Connectiv_data.params.tau_max /Connectiv_data.params.tau_delta );     
    Connectiv_data.params.epsilon_tau =  0.5  ; 
    Connectiv_data.params.use_burst_absolute = true ; % if true - take burst_absolute, otherwise - bursts
    Connectiv_data.params.Fit_Max_iterations = 300 ;
    Connectiv_data.params.Analyze_split_data = true ; % split all bursts into sequencies 
    Connectiv_data.params.MaxSpikesPerChannelPerBurst = 1000 ;
                    %of Bursts_in_Block and analyze each Block consequently
    Connectiv_data.params.Bursts_in_Block = 20000  ;
    Connectiv_data.params.Analysis_ver = GLOBAL_const.Connectiv_Analysis_ver ; % version of script
    Connectiv_data.params.Analysis_params.smooth_fit_type = smooth_fit_type ;
    Connectiv_data.params.Analysis_params.smooth_window = smooth_window ;
    
    ch_times_precomputed = false ;
    precise_spikes_construct = false ; % if true - look 282 for details   
    MAX_SPIKES_PER_CHANNEL_AT_BURST = 1000 ;
    

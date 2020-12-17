
%  Connectiv_get_N_connections_script 
 
%  input 
% var.default_params 
% var.Check_Spike_Rates 
% ( All_files_data_TOTAL_cell , Connects_min_tau_diff_THR , ...
%         Strength_THR , SpBur_thr )
% output Number_of_Connections Connection_delays
    
    
if var.default_params 
    Analysis_2_sets_init_parameters
    Connects_min_tau_diff_THR = Global_flags.Connects_min_tau_diff ;
    Strength_THR = Global_flags.Connects_min_M_strength ;
end

if var.Check_Spike_Rates 
   Check_Spike_Rates = true ;
else
   Check_Spike_Rates = false  ;
end

fi = var.Connectiv_data_index ;

    Number_of_Connections = 0 ;
    Connection_delays = []; 
    N = size( All_files_data_TOTAL_cell{ 2 , fi }.Connectiv_matrix_max_M ) ;
    N = N(1) ;
    for chi =1 : N
        for chj = 1 : N
            if chi ~= chj
%                 for M_i = 1 : length( All_files_data_TOTAL_cell{ 2 , fi }.Connectiv_matrix_max_M_vector )
    %                 zeroo_conn_both_files = find( M_i == Zero_delay_Connections_2files_index_for_1st_file );
                   M1 = All_files_data_TOTAL_cell{ 2 , fi }.Connectiv_matrix_max_M( chi , chj ) ;
                   tau1= All_files_data_TOTAL_cell{ 2 , fi }.Connectiv_matrix_tau_of_max_M( chi , chj  ); 
                   % - difference of connections which non-zero and tau is
                   % non-zero in both files  
%                    M1 = All_files_data_TOTAL_cell{ 2 , fi }.Connectiv_matrix_max_M_vector( M_i ) ;
%                    tau1= All_files_data_TOTAL_cell{ 2 , fi }.Connectiv_matrix_tau_of_max_M_vector( M_i ); 
                   is_Connection_OK_1 = M1 > Strength_THR ;
                   is_Connection_OK_1_delay_non_zero = tau1 >=  Connects_min_tau_diff_THR ;         
                        is_Connection_exists  = is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero  ;  
                        if Check_Spike_Rates && is_Connection_exists
                            
                            Enough_spike_both_channels = false; 
                            if All_files_data_TOTAL_cell{ 2 , fi }.Total_Spike_Rates( chi ) >= SpBur_thr && ...
                                    All_files_data_TOTAL_cell{ 2 , fi }.Total_Spike_Rates( chj ) >= SpBur_thr
                                Enough_spike_both_channels = true ;
                            end
                            is_Connection_exists =  Enough_spike_both_channels ;
                        end
                        Number_of_Connections= Number_of_Connections  + is_Connection_exists  ; 
                        if is_Connection_exists
                          Connection_delays=[Connection_delays tau1 ];
                        end
%                 end
            end
        end
    end
    Number_of_Connections ;
    
    Number_adequate_channels = 0 ;
%     All_files_data_TOTAL_cell{ 2 , fi }.Number_adequate_channels ;


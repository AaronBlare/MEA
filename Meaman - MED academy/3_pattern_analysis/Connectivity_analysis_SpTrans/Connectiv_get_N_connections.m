
function [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( Connectiv_data , Connects_min_tau_diff_THR , ...
        Strength_THR , Total_Spike_Rates_thr )

if nargin == 1
    meaDB_Global_init_parameters
    Connects_min_tau_diff_THR = Global_flags.Connects_min_tau_diff ;
    Strength_THR = Global_flags.Connects_min_M_strength ;
end

if nargin < 4
   Check_Spike_Rates = false ;
else
   Check_Spike_Rates = true  ;
end

    Number_of_Connections = 0 ;
    Connection_delays = []; 
    N = size( Connectiv_data.Connectiv_matrix_max_M ) ;
    N = N(1) ;
    for chi =1 : N
        for chj = 1 : N
            if chi ~= chj
%                 for M_i = 1 : length( Connectiv_data.Connectiv_matrix_max_M_vector )
    %                 zeroo_conn_both_files = find( M_i == Zero_delay_Connections_2files_index_for_1st_file );
                   M1 = Connectiv_data.Connectiv_matrix_max_M( chi , chj ) ;
                   tau1= Connectiv_data.Connectiv_matrix_tau_of_max_M( chi , chj  ); 
                   % - difference of connections which non-zero and tau is
                   % non-zero in both files  
%                    M1 = Connectiv_data.Connectiv_matrix_max_M_vector( M_i ) ;
%                    tau1= Connectiv_data.Connectiv_matrix_tau_of_max_M_vector( M_i ); 
                   is_Connection_OK_1 = M1 > Strength_THR ;
                   is_Connection_OK_1_delay_non_zero = tau1 >=  Connects_min_tau_diff_THR ;         
                        is_Connection_exists  = is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero  ;  
                        if Check_Spike_Rates && is_Connection_exists
                            
                            Enough_spike_both_channels = false; 
                            if Connectiv_data.Total_Spike_Rates( chi ) >= Total_Spike_Rates_thr && ...
                                    Connectiv_data.Total_Spike_Rates( chj ) >= Total_Spike_Rates_thr
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
%     Connectiv_data.Number_adequate_channels ;
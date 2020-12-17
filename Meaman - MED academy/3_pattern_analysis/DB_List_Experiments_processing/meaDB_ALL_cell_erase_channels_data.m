   % meaDB_ALL_cell_erase_channels_data 
%    Input : Global_flags ALL_cell channels_to_erase
   
    for file_i = 1 : Global_flags.Files_in_exeperiment
        
        if  Connectiv_data_present
            for i = 1 : N
                for j = 1 : N
                    fi = find( i == channels_to_erase ) ;
                    fj = find( j == channels_to_erase ) ;
                    erase_channel = ~isempty( fi ) ||  ~isempty( fj ) ;
                    if erase_channel
                     ALL_cell.Connectiv_data( file_i ).Connectiv_matrix_tau_of_max_M( ...
                          i , j ) = 0 ;
                    end
                
                end
            end
                

                    var.default_params  = true;
                    var.Check_Spike_Rates = false ;  

                     [ Number_of_Connections , Connection_delays ] = ...
                         Connectiv_get_N_connections_from_Connectiv( ALL_cell.Connectiv_data( file_i  , :)  , Global_flags , var) ;
                    %  input 
                    % var.default_params 
                    % var.Check_Spike_Rates 
                    % ( Connectiv_data , Connects_min_tau_diff_THR , ...
                    %         Strength_THR , Total_Spike_Rates_thr )
                    % output Number_of_Connections Connection_delays            

            ALL_cell.Connectiv_data( file_i  , :).Number_of_Connections =  Number_of_Connections ; 
        end
    end
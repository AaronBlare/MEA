


%  Connectiv_2_channels_connection
% Input: ch1 , ch2 , ch1_spikes_num , ch2_spikes_num , Nb , N
%     Connectiv_params.Conn_Spikes_num_min = 200 ;
%     Connectiv_params.tau_delta = 1;
%     Connectiv_params.tau_max = 40 ;
%     Connectiv_params.epsilon_tau = 0.2 ; 
%    
% Output: vector M_of_tau  ( size = Connectiv_params.tau_max /
% Connectiv_params.tau_delta  )


%             % chechk if enough spikes we have
%            if ch1_spikes_num > Connectiv_params.Conn_Spikes_num_min && ...
%                    ch2_spikes_num > Connectiv_params.Conn_Spikes_num_min
               
                
                    M_of_tau = zeros( Connectiv_params.tau_max / Connectiv_params.tau_delta  , 1 ) ;
                
                
%                 tau_all = []; 
                
                    tau_i=0;
                    for tau = 0 : Connectiv_params.tau_delta : Connectiv_params.tau_max
                        M = 0 ;
    %                     tau_all = [tau_all tau ];   
                        tau_i = tau_i + 1 ;

                        for Nb_i = 1 : Nb 
        %                 bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
                            ch1_times =  bursts( Nb_i  , ch1 , : ) ;
                            ch1_times( ch1_times==0 )=[];
                            ch2_times =  bursts( Nb_i  , ch2 , : ) ;
                            ch2_times( ch2_times==0 )=[];


                            for sp_i = 1 : length( ch1_times )
                               ss = find( ch1_times( sp_i ) >= ch2_times + tau - Connectiv_params.epsilon_tau & ...
                                   ch1_times( sp_i ) <= ch2_times + Connectiv_params.epsilon_tau  + tau) ;       
                               if ~isempty( ss )
                                  M = M + 1 ; 
                               end
                            end

                        end

                        M_of_tau( tau_i )  =  M / ch1_spikes_num   ;   
                    end 
                
                
%            end


% Bursts_AB_analyze_connectivity

index_r = Chambers.RASTER_data.index_r ;

% for ai = 1 :  ANALYZED_DATA_A.Number_of_Patterns
 ai = 1 ;
           ai_s = ANALYZED_DATA_A.burst_start( ai ) ;
           ai_e = ANALYZED_DATA_A.burst_end( ai ) ; 
 big_t_i =  find( index_r( : , 1 ) < ai_s );
 index_r( big_t_i , : ) = [] ;
 
 low_t_i =  find( index_r( : , 1 ) > ai_e );
 index_r( low_t_i , : ) = [] ;
 
 a=   [ index_r( : , 1 )  index_r( : , 2 ) ] ;
 
 figure
 plot( a(:,1) , a(:,2)  , '*')
 
%            Nb , N , bursts_absolute
%             Patterns_analysis_connectivity 
            % >>> Input: bursts or bursts_absolute , Spike_Rates , Nb , N ,
            % Burst_Data_Ver  
            % Output >>>: 
            % Connectiv_data struct :
            % Connectiv_matrix_M_on_tau ( N x N x Connectiv_data.params.tau_number ) 
            % Connectiv_matrix_max_M (NxN) , 
            % Connectiv_matrix_tau_of_max_M ( NxN )
            % max_M - Maximum % of spikes transferred , tau - delay of max_M
            % Connectiv_matrix_tau_of_max_M_vector 
            % Connectiv_matrix_tau_of_max_M_vector_non_zeros
            % Connectiv_matrix_max_M_vector
            % Connectiv_matrix_max_M_vector_non_zeros
            % Connectiv_data.params





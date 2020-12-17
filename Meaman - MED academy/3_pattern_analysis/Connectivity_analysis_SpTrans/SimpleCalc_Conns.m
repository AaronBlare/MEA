function Conn_struc = SimpleCalc_Conns( N ,Connectiv_data , Connectiv_matrix_M_on_tau_not_fitted , Total_Spike_Rates , Spike_Rates ) 
    Conn_struc.Connectiv_matrix_max_M_vector = [];
    Conn_struc.Connectiv_matrix_max_M_vector_non_zeros = [] ;
    Conn_struc.Connectiv_matrix_tau_of_max_M_vector = []; 
    Conn_struc.Connectiv_matrix_tau_of_max_M_vector_non_zeros = [];
    Conn_struc.Connectiv_matrix_max_M = zeros( N ,N ) ;
    Conn_struc.Connectiv_matrix_tau_of_max_M = zeros( N ,N ) ;
    Conn_struc.Total_Spike_Rates = Total_Spike_Rates;
    Conn_struc.Spike_Rates = Spike_Rates ;

    %% --- analyzing responses curves -------------
 
    M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ;
    for chi = 1 : N 
            for chj = 1 : N    
            if chi ~= chj    
                         
                M_of_tau = Connectiv_matrix_M_on_tau_not_fitted( chi ,chj , : )  ;
                M_max = max( M_of_tau );
                tau_max_index = find( M_of_tau == M_max ,1) ;            
                tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ; 
%                 if tau_max > 0
%                      figure
%                      M_of_tau=reshape(M_of_tau,[],1);
%                      plot( M_of_tau )
%                 end
                Conn_struc.Connectiv_matrix_max_M( chi , chj ) = M_max  / Total_Spike_Rates(chi) ; 
                Conn_struc.Connectiv_matrix_tau_of_max_M( chi , chj ) = tau_max ;    
                Conn_struc.Connectiv_matrix_max_M_vector  =[Conn_struc.Connectiv_matrix_max_M_vector   Conn_struc.Connectiv_matrix_max_M( chi , chj ) ];
                Conn_struc.Connectiv_matrix_tau_of_max_M_vector  = [Conn_struc.Connectiv_matrix_tau_of_max_M_vector ...   
                    Conn_struc.Connectiv_matrix_tau_of_max_M( chi , chj ) ];  
          % Take all connectivity values and delays and form vector
            if Conn_struc.Connectiv_matrix_max_M( chi , chj ) > 0
                Conn_struc.Connectiv_matrix_max_M_vector_non_zeros =[Conn_struc.Connectiv_matrix_max_M_vector_non_zeros ...
                    Conn_struc.Connectiv_matrix_max_M( chi , chj ) ];
                Conn_struc.Connectiv_matrix_tau_of_max_M_vector_non_zeros = [Conn_struc.Connectiv_matrix_tau_of_max_M_vector_non_zeros ...
                        Conn_struc.Connectiv_matrix_tau_of_max_M( chi , chj ) ];
            end                 
            end
            
            end
    end
%---------------------------------
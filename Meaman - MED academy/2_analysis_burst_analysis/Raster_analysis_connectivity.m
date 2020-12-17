

%  Raster_analysis_connectivity 
% Input: index_r

   N = max( index_r( : , 2 )) 
    
    
   figure
   
    Conn_Spikes_num_min = 200 ;
    tau_delta = 1;
    tau_max = 40 ;
    epsilon_tau = 0.2 ; 
    %------- Connectivity analysis
    for chi = 1 : N
        for chj = chi+1 : N
          if chi ~= chj
            
            
            ch1 = chi  
            ch2 = chj  
            ch1_index = find( index_r( : , 2 ) == ch1 );
            ch2_index = find( index_r( : , 2 ) == ch2 );
            ch1_spikes_num = length( ch1_index )
            ch2_spikes_num = length( ch2_index )

            % chechk if enough spikes we have
           if ch1_spikes_num > Conn_Spikes_num_min &&  ch2_spikes_num > Conn_Spikes_num_min
               
                M_of_tau = [];
                tau_all = [];
                ch1_times =  index_r( ch1_index , 1 ) ;
                ch2_times =  index_r( ch2_index , 1 ) ;
                for tau = 0 : tau_delta : tau_max
                    M = 0 ;
                    tau_all = [tau_all tau ];
                    for sp_i = 1 : ch1_spikes_num
                       ss = find( ch1_times( sp_i ) >= ch2_times + tau - epsilon_tau & ch1_times( sp_i ) <= ch2_times + epsilon_tau  + tau) ;       
                       if ~isempty( ss )
                          M = M + 1 ; 
                       end
                    end
                    M_of_tau = [ M_of_tau M / ch1_spikes_num  ] ;               
                end
                
                  
                 
                plot( tau_all , M_of_tau ) ;
                
           end
          end
        end
    end
    
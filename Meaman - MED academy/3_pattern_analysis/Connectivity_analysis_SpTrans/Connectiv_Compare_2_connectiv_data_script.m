% Connectiv_Compare_2_connectiv_data_script
% Input : Connectiv_data1, Connectiv_data2 , ANALYZED_DATA_1 ANALYZED_DATA_2 Global_flags
% Output: Comp_result

%             Comp_result.Number_of_common_Connections = 0 ;
%                Comp_result.Common_connections_index = [] ;
%             Comp_result.Number_of_Connections_file1 = 0 ;
%             Comp_result.Number_of_Connections_file2 = 0 ;
%             Comp_result.Number_of_appear_or_dissappear_Connections = 0 ;
%             Comp_result.Number_of_appear_Connections = 0 ;
%                Comp_result.Appear_Connections_index = [];
%             Comp_result.Number_of_dissappear_Connections = 0 ;
%                Comp_result.Dissappear_Connections_index=[];
%             Comp_result.Mean_M_abs_difference_common_connections
%             Comp_result.Mean_M_abs_difference_unstable_connections
%                 Comp_result.New_Diss_connes_percent_of_1s_file   
%             Comp_result.New_conns_percent_of_1st_file  
%             Comp_result.Dissapeared_conns_percent_of_1st_fil

%             Comp_result.New_conns_delays  
%             Comp_result.New_conns_mean_delay  
%             Comp_result.Dissapeared_conns_delays  
%             Comp_result.Dissapeared_conns_mean_delay


%            Global_flags.Connects_min_tau_diff = 10 ; % if delay of connection less than this, then this is not connection

%            Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( 3) = 4 ;
%            Connectiv_data1.Connectiv_matrix_max_M_vector( 3) = 4 ;

%          Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector_non_zeros( 3) = 4 ;           

 Compare_appeared_Individ_pair_conn = false ;
%  Compare_appeared_Individ_pair_conn = true ;

if isfield( Global_flags , 'Show_compare_figure' )
    Show_compare_figure = Global_flags.Show_compare_figure ;
else
    Show_compare_figure = true ;
end

            Comp_result = [];


         %/////////////////////////////////////////////////////////////////
            Comp_result.Number_of_common_Connections = 0 ;
               Comp_result.Common_connections_index = [] ;
            Comp_result.Number_of_Connections_file1 = 0 ;
            Comp_result.Number_of_Connections_file2 = 0 ;
            Comp_result.Number_of_appear_or_dissappear_Connections = 0 ;
            Comp_result.Number_of_appear_Connections = 0 ;
            Comp_result.Appear_Connections_index = [];
            Comp_result.Number_of_dissappear_Connections = 0 ;
            Comp_result.Dissappear_Connections_index=[];
%             Comp_result.Number_Spikes = sum( ANALYZED_DATA_1.Spike_Rates_each_burst )    ;
%             Comp_result.Number_Spikes2 = sum( ANALYZED_DATA_2.Spike_Rates_each_burst )    ;
            Comp_result.Number_Spikes =  ANALYZED_DATA_1.Total_spikes_number  ;
            Comp_result.Number_Spikes2 =  ANALYZED_DATA_2.Total_spikes_number    ;

            Comp_result.Number_of_Superbursts =  ANALYZED_DATA_1.Superbrsts.Number_of_Superbursts      ;
            Comp_result.Number_of_Superbursts2 =  ANALYZED_DATA_2.Superbrsts.Number_of_Superbursts      ;        
            
            Comp_result.Number_adequate_channels1 = Connectiv_data1.Number_adequate_channels ;
            Comp_result.Number_adequate_channels2 = Connectiv_data2.Number_adequate_channels ;
            
            %--- Vectors ----------------
            Comp_result.BurstDurations1 =  ANALYZED_DATA_1.BurstDurations    ;
            Comp_result.BurstDurations2 =  ANALYZED_DATA_2.BurstDurations    ;
            
            Comp_result.InteBurstInterval1 =  ANALYZED_DATA_1.InteBurstInterval    ;
            Comp_result.InteBurstInterval2 =  ANALYZED_DATA_2.InteBurstInterval    ;
            
            Comp_result.Spike_Rates_each_burst1 =  ANALYZED_DATA_1.Spike_Rates_each_burst    ;
            Comp_result.Spike_Rates_each_burst2 =  ANALYZED_DATA_2.Spike_Rates_each_burst    ;
            
            Comp_result.BurstDurations1 =  ANALYZED_DATA_1.BurstDurations    ;
            Comp_result.BurstDurations2 =  ANALYZED_DATA_2.BurstDurations    ;
            
            Comp_result.Spike_Rates_each_channel_mean1 =  ANALYZED_DATA_1.Spike_Rates_each_channel_mean    ;
            Comp_result.Spike_Rates_each_channel_mean2 =  ANALYZED_DATA_2.Spike_Rates_each_channel_mean    ;
            %----------------------------------
            
            
            Comp_result.BurstDurations_mean = mean( ANALYZED_DATA_1.BurstDurations  ) ;
            Comp_result.BurstDurations_std =   std( ANALYZED_DATA_1.BurstDurations  ) ;            
            Comp_result.InteBurstInterval_mean  = mean( ANALYZED_DATA_1.InteBurstInterval    ) ;                          
            Comp_result.InteBurstInterval_std  =   std( ANALYZED_DATA_1.InteBurstInterval    ) ; 
            Comp_result.Spike_Rates_each_burst_mean  = mean( ANALYZED_DATA_1.Spike_Rates_each_burst    ) ;                          
            Comp_result.Spike_Rates_each_burst_std  = std( ANALYZED_DATA_1.Spike_Rates_each_burst    ) ; 
                           
            Comp_result.BurstDurations_mean2 = mean( ANALYZED_DATA_2.BurstDurations  ) ;
            Comp_result.BurstDurations_std2 = std(   ANALYZED_DATA_2.BurstDurations  ) ;            
            Comp_result.InteBurstInterval_mean2  = mean( ANALYZED_DATA_2.InteBurstInterval    ) ;                          
            Comp_result.InteBurstInterval_std2  = std( ANALYZED_DATA_2.InteBurstInterval    ) ;   
            Comp_result.Spike_Rates_each_burst_mean2  = mean( ANALYZED_DATA_2.Spike_Rates_each_burst    ) ;                          
            Comp_result.Spike_Rates_each_burst_std2  = std( ANALYZED_DATA_2.Spike_Rates_each_burst    ) ;        
            
            if isfield( ANALYZED_DATA_1 , 'Small_bursts_number' )
            Comp_result.Small_bursts_number1 = ANALYZED_DATA_1.Small_bursts_number  ;
            end
            
            if isfield( ANALYZED_DATA_2 , 'Small_bursts_number' )
            Comp_result.Small_bursts_number2 = ANALYZED_DATA_2.Small_bursts_number  ;
            end
            
            if isfield( ANALYZED_DATA_1 , 'Analysis_data_cell' )
            Comp_result.Analysis_data_cell1 = ANALYZED_DATA_1.Analysis_data_cell  ;
            Comp_result.Analysis_data_cell_field_names1 = ANALYZED_DATA_1.Analysis_data_cell_field_names  ;
            
            end
            
            if isfield( ANALYZED_DATA_2 , 'Small_bursts_number' )
            Comp_result.Analysis_data_cell2 = ANALYZED_DATA_2.Analysis_data_cell  ;
            Comp_result.Analysis_data_cell_field_names2 = ANALYZED_DATA_2.Analysis_data_cell_field_names  ;
            end
            
            Firing_Rates_each_burst  = zeros( ANALYZED_DATA_1 .Number_of_Patterns ,1); 
            Firing_Rates_each_burst2   = zeros( ANALYZED_DATA_2.Number_of_Patterns ,1); 
            for i=1:  ANALYZED_DATA_1.Number_of_Patterns 
              Firing_Rates_each_burst(i) = sum( ANALYZED_DATA_1.Firing_Rates( i , :)); 
            end
            for i=1:  ANALYZED_DATA_2.Number_of_Patterns 
              Firing_Rates_each_burst2(i) = sum( ANALYZED_DATA_2.Firing_Rates( i , :));               
            end              
            Comp_result.Firing_Rates_each_burst_mean  = mean( Firing_Rates_each_burst    ) ;                          
            Comp_result.Firing_Rates_each_burst_std  = std( Firing_Rates_each_burst   ) ;  
            Comp_result.Firing_Rates_each_burst_mean2  = mean( Firing_Rates_each_burst2    ) ;                          
            Comp_result.Firing_Rates_each_burst_std2  = std( Firing_Rates_each_burst2   ) ;          
            
            Comp_result.Burst_rate_b_per_min =  60 * 1000 *( ANALYZED_DATA_1.Number_of_Patterns / ANALYZED_DATA_1.burst_end(end) ) ;
            Comp_result.Burst_rate_b_per_min2 =  60 *1000 *( ANALYZED_DATA_2.Number_of_Patterns / ANALYZED_DATA_2.burst_end(end) ) ;            
            Comp_result.Burst_rate_number =   ANALYZED_DATA_1.Number_of_Patterns   ;
            Comp_result.Burst_rate_number2 =   ANALYZED_DATA_2.Number_of_Patterns   ;              
         %/////////////////////////////////////////////////////////////////
          




           

           

           % Filter all connections that have 0 delay --------------
           zero_delays_index1 = find( Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector == 0 & ...
               Connectiv_data1.Connectiv_matrix_max_M_vector == 0 | ...
               Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector <= Global_flags.Connects_min_tau_diff  ) ;
%            Connectiv_data1.Connectiv_matrix_max_M_vector_non_zeros( zero_delays_index ) = [];
           zero_delays_index2 = find( Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector == 0 & ...
               Connectiv_data2.Connectiv_matrix_max_M_vector == 0 | ...
               Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector <= Global_flags.Connects_min_tau_diff  ) ;
            
           
%            Connectiv_data2.Connectiv_matrix_max_M_vector_non_zeros( zero_delays_index ) = [];
%            zero_delays_index_both_files = find( zero_delays_index1 == zero_delays_index2 ) ;
%            zero_delays_index_both_files - index from zero_delays_index1
%            vector
%            Number_of_zero_delay_Connections_2files = length( zero_delays_index_both_files ) 
           [C,ia,ib] = intersect(zero_delays_index1,zero_delays_index2);
           Number_of_zero_delay_Connections_2files = length( C ) ;
           
           Zero_delay_Connections_2files_index_for_1st_file =  ia ;
           Zero_delay_Connections_2files_index_for_2st_file = ib ;
           
           % find zero delays index of
            zero_delays_only_1file_1_index = zero_delays_index1 ;
            zero_delays_only_1file_1_index( Zero_delay_Connections_2files_index_for_1st_file ) = [];
            zero_delays_only_1file_2_index = zero_delays_index2 ;
            zero_delays_only_1file_2_index( Zero_delay_Connections_2files_index_for_2st_file ) = [];
            
            Number_of_unique_zero_delays_in_1st_file  = length( zero_delays_only_1file_1_index )  
            Number_of_unique_zero_delays_in_2nd_file  = length( zero_delays_only_1file_2_index )
            Comp_result.Number_of_unique_zero_delays_in_1st_file=Number_of_unique_zero_delays_in_1st_file;
            Comp_result.Number_of_unique_zero_delays_in_2nd_file=Number_of_unique_zero_delays_in_2nd_file;
            %-----------------------------------------------
            
            
            
            
   
                          
               
            for M_i = 1 : length( Connectiv_data1.Connectiv_matrix_max_M_vector )
%                 zeroo_conn_both_files = find( M_i == Zero_delay_Connections_2files_index_for_1st_file );
                
               % - difference of connections which non-zero and tau is
               % non-zero in both files
                Comp_result.M_i_diff_common( M_i ) = -1 ;

               M1 = Connectiv_data1.Connectiv_matrix_max_M_vector( M_i ) ;
               tau1= Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( M_i );
               M2 = Connectiv_data2.Connectiv_matrix_max_M_vector( M_i ) ;
               tau2=Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( M_i );
               
               if ~isfield( Global_flags ,'Connects_min_M_strength' )
                   Global_flags.Connects_min_M_strength = 0 ;
               end
               
               is_Connection_OK_1 = M1 > Global_flags.Connects_min_M_strength ;
%                is_Connection_OK_1 = M1 > 0 ;
               is_Connection_OK_1_delay_non_zero = tau1 >= Global_flags.Connects_min_tau_diff ;
               is_Connection_OK_2 = M2 > Global_flags.Connects_min_M_strength ;
%                is_Connection_OK_2 = M2 > 0 ;
               is_Connection_OK_2_delay_non_zero = tau2>= Global_flags.Connects_min_tau_diff ; % if true - M~=0 & tau~=0               
               
%                  
                    % if connections were in both files
                    if  is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero && ...
                            is_Connection_OK_2  * is_Connection_OK_2_delay_non_zero

                        Comp_result.Number_of_common_Connections = Comp_result.Number_of_common_Connections+1 ;
                        Comp_result.Common_connections_index=[Comp_result.Common_connections_index M_i ];
                        Comp_result.M_i_diff_common( M_i ) = M2 - M1 ;
%                         if M1-M2 > 0.6
%                             M1 ;
%                             M2 ;
%                         end

                    end
                    
                  Comp_result.M_i_diff_unstable( M_i ) = 0 ;   
                    % if connection was only in file
                    is_Connection_exists_1 = is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero  ;
                    is_Connection_exists_2 = is_Connection_OK_2 *  is_Connection_OK_2_delay_non_zero  ;                    
                    
                    Comp_result.Number_of_Connections_file2 = Comp_result.Number_of_Connections_file2 + is_Connection_exists_2 ;
                    Comp_result.Number_of_Connections_file1 = Comp_result.Number_of_Connections_file1 + is_Connection_exists_1 ;
                    
                    if  is_Connection_exists_1  > 0 || ...
                        is_Connection_exists_2  > 0 
                        if is_Connection_exists_2 > 0 && ...
                                is_Connection_OK_1_delay_non_zero == 0% newly appeared connection
                            
                            Comp_result.Number_of_appear_or_dissappear_Connections = Comp_result.Number_of_appear_or_dissappear_Connections+1 ; 
                            Comp_result.Number_of_appear_Connections = Comp_result.Number_of_appear_Connections+1 ;
                            Comp_result.Appear_Connections_index=[Comp_result.Appear_Connections_index M_i];
                            Comp_result.M_i_diff_unstable( M_i )= M2  ;
                        end
                        
                        if is_Connection_exists_1 > 0 && ...
                                is_Connection_OK_2_delay_non_zero == 0% newly appeared connection
                            
                            Comp_result.Number_of_appear_or_dissappear_Connections = Comp_result.Number_of_appear_or_dissappear_Connections+1 ; 
                            Comp_result.Number_of_dissappear_Connections=Comp_result.Number_of_dissappear_Connections+1;
                            Comp_result.Dissappear_Connections_index=[Comp_result.Dissappear_Connections_index M_i ];
                            Comp_result.M_i_diff_unstable( M_i ) = -M1  ;
                        end
                        
            

                    end
            end
                        
            %-- we don't erase differencies of common connection if that
            %diff == 0
             Comp_result.M_i_diff_common( Comp_result.M_i_diff_common == -1 ) = [] ;
             Comp_result.abs_M_i_diff_common = abs( Comp_result.M_i_diff_common ) ;
            
            Comp_result.Mean_M_abs_difference_common_connections = Mean( Comp_result.abs_M_i_diff_common ) ;            
            Mean_M_abs_difference_common_connections =  Comp_result.Mean_M_abs_difference_common_connections
            
            
            Comp_result.M_i_diff_unstable( Comp_result.M_i_diff_unstable == 0 ) = [] ;
            Comp_result.abs_M_i_diff_unstable = abs( Comp_result.M_i_diff_unstable ) ;
            Comp_result.Mean_M_abs_difference_unstable_connections = Mean( Comp_result.abs_M_i_diff_unstable ) ;  
            Mean_M_abs_difference_unstable_connections =  Comp_result.Mean_M_abs_difference_unstable_connections
            
            Number_of_appear_Connections = Comp_result.Number_of_appear_Connections
            Number_of_dissappear_Connections =  Comp_result.Number_of_dissappear_Connections
            Number_of_appear_or_dissappear_Connections = Comp_result.Number_of_appear_or_dissappear_Connections


            %----------------------------------
             
            Comp_result.New_Diss_connes_percent_of_1s_file  = 100* ( Comp_result.Number_of_appear_or_dissappear_Connections / ...
                        Comp_result.Number_of_Connections_file1 ) ;
                           
            Comp_result.New_conns_percent_of_1st_file  = 100*( Comp_result.Number_of_appear_Connections / Comp_result.Number_of_Connections_file1 );         
            Comp_result.Dissapeared_conns_percent_of_1st_file  = -100*(Comp_result.Number_of_dissappear_Connections /Comp_result.Number_of_Connections_file1 ); 
                 
            
            Comp_result.New_conns_delays = Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( ...
                Comp_result.Appear_Connections_index ) ;
            Comp_result.New_conns_mean_delay = mean( Comp_result.New_conns_delays ) ;           
            
            Comp_result.Dissapeared_conns_delays = Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( ...
                Comp_result.Dissappear_Connections_index ) ;
            Comp_result.Dissapeared_conns_mean_delay = mean( Comp_result.Dissapeared_conns_delays ) ;  
            
            
            %----------------------------------
            
            
            
            
            
            
            
            
            
            
            
            
            
            
       if Compare_appeared_Individ_pair_conn    
            Mi_thresh = 0.05;
            Conn_delay_for_appeared_conn= 20 ;
            Connectiv_data1.Connectiv_matrix_max_M_vector;
            Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector;
            
            
            N=60;
            
            %---------------------------- 1----------------------
N=60 ;
                             DT_bin = 4 ;
                             End_t = 300 ; %median(ANALYZED_DATA.BurstDurations) ;
                              fire_bins = floor((End_t - 0) / DT_bin) ;
                                DT_BINS_number =fire_bins;
                              var.Spike_Rates_each_burst = []; 
                              var.Burst_Data_Ver = ANALYZED_DATA_1.Burst_Data_Ver;
                              var.N = N ;
                              
                              [   TimeBin_Total_Spikes1 ,  TimeBin_Total_Spikes_mean1 , TimeBin_Total_Spikes_std1 , ...
                               Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
                               Data_Rate_Signature1_std ] ...
                                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,ANALYZED_DATA_1.Number_of_bursts  ,ANALYZED_DATA_1.bursts , ...
                                  0 ,  End_t  , DT_bin  ,ANALYZED_DATA_1.bursts_amps ,var );

 
  %---------------------------- 2----------------------
                             DT_bin = 4 ;
                             End_t = 300 ; %median(ANALYZED_DATA.BurstDurations) ;
                              fire_bins = floor((End_t - 0) / DT_bin) ;
                                DT_BINS_number =fire_bins;
                              var.Spike_Rates_each_burst = []; 
                              [   TimeBin_Total_Spikes2 ,  TimeBin_Total_Spikes_mean2 , TimeBin_Total_Spikes_std2 , ...
                               Data_Rate_Patterns2 ,  Data_Rate_Signature2 ,  ... 
                               Data_Rate_Signature2_std ] ...
                                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,ANALYZED_DATA_2.Number_of_bursts  ,ANALYZED_DATA_2.bursts , ...
                                  0 ,  End_t  , DT_bin  ,ANALYZED_DATA_2.bursts_amps ,var );
                              
            
          %---------------------------  
            for ti = 1:length( Comp_result.Appear_Connections_index )
                
                ti_a = Comp_result.Appear_Connections_index(ti); 
                
                ti_b = lin2d( ti_a );
            
                if Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( ti_a)==0 && Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( ti_a)> Conn_delay_for_appeared_conn
                % if pair has delay=0 before and now appeared ...
                   if  Connectiv_data1.Connectiv_matrix_max_M_vector(ti_a)> Mi_thresh && Connectiv_data2.Connectiv_matrix_max_M_vector(ti_a)> Mi_thresh
                    % if conn strength were in both cases - strong
%                     Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( ti_a)=300 ;
                      ti_a
                      ti_b
                      xi = floor( ti_b / 60 ) + 1  
                      yj = mod( ti_b , 60 ) + 1    
                      tau_max = Connectiv_data2.Connectiv_matrix_max_M_vector( ti_a)
                      tau_max2d = Connectiv_data2.Connectiv_matrix_max_M( xi , yj)
                      
                      M_on_tau1 = Connectiv_data1.Connectiv_matrix_M_on_tau( xi , yj , : ) ;
                      M_on_tau1=reshape(M_on_tau1 , [], 1);
                      M_on_tau2 = Connectiv_data2.Connectiv_matrix_M_on_tau( xi , yj , : ) ;
                      M_on_tau2=reshape(M_on_tau2 , [], 1);
                      
                      M_on_tau1_0 = Connectiv_data1.Connectiv_matrix_M_on_tau_not_fitted( xi , yj , : ) ;
                      M_on_tau1_0= reshape(M_on_tau1_0 , [], 1);
                      M_on_tau2_0 = Connectiv_data2.Connectiv_matrix_M_on_tau_not_fitted( xi , yj , : ) ;
                      M_on_tau2_0=reshape(M_on_tau2_0 , [], 1);                      
                      

%                       Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( x*60 + y + 1  )=350 ;

%                         ti_a - index of vector where connection appeared large
                       

                    %             subplot( 3,3,[ 3 6 9 ] )      
                                figure
                                subplot( 2 , 1 , 1 )
                                x=1: DT_BINS_number; y = 1:N;
                                Data_Rate_Signature2 = Data_Rate_Signature2';
                                bb= imagesc(  x * DT_bin  , y ,  Data_Rate_Signature2  ); 
                                title( ['Burst profile, spikes/bin (' num2str( DT_bin) ' ms)'] );
                                xlabel( 'Time offset, ms' )
                                ylabel( 'Electrode #' )
                                colorbar         
                                
                                subplot( 2 , 1 , 2 )                 
                                x=1: DT_BINS_number; y = 1:N;
                                Data_Rate_Signature1 = Data_Rate_Signature1';
                                bb= imagesc(  x * DT_bin  , y ,  Data_Rate_Signature1  ); 
                                title( ['Burst profile, spikes/bin (' num2str( DT_bin) ' ms)'] );
                                xlabel( 'Time offset, ms' )
                                ylabel( 'Electrode #' )
                                colorbar
                                
                                One_pair_i = xi ;
                                One_pair_j = yj ;
                                
                                
                           figure
                              hold on

                                plot( (M_on_tau1_0 /max(M_on_tau1_0 )) * max( M_on_tau1 ) ) 
                                plot( (M_on_tau2_0 / max(M_on_tau2_0))  * max( M_on_tau2 ) , 'r'  ) 
                                plot( M_on_tau1 , 'LineWidth',3 )  
                                plot( M_on_tau2  , 'r' ,'LineWidth',3 )
                                ylabel( 'Spike transferred')
                                xlabel( 'Delay, ms')
                                title( 'Spike transferred, original')
                                legend( 'Before' , 'After conn. appear' )
                              hold off
                                
                           figure
                                subplot( 2 , 1 , 1 )
                                hold on
                                    plot( x * DT_bin ,Data_Rate_Signature1(  One_pair_i , : )  )   
                                    plot( x * DT_bin ,Data_Rate_Signature1(  One_pair_j , : ) , 'r' )
                                    plot( x * DT_bin ,smooth( Data_Rate_Signature1(  One_pair_i , : ) ,55 , 'rloess' )  , 'LineWidth',3  )   
                                    plot( x * DT_bin ,smooth( Data_Rate_Signature1(  One_pair_j , : ) ,55 , 'rloess' ) , 'r' , 'LineWidth',3 )   
                                hold off
                                ylabel( 'Spikes per bin')
                                xlabel( 'Time offset, ms' )
                                legend( [ 'Channel '  num2str( One_pair_i ) ] , [ 'Channel '  num2str( One_pair_j ) ]); 
                                title( [ 'Burst profiles in 1st file' ] );                               
                              
                            
                             
                                subplot( 2 , 1 , 2 ) 
                                hold on
                                    plot( x * DT_bin , Data_Rate_Signature2(  One_pair_i , : ) )   
                                    plot( x * DT_bin , Data_Rate_Signature2(  One_pair_j , : ) , 'r'  )
                                    plot( x * DT_bin ,smooth( Data_Rate_Signature2(  One_pair_i , : ) ,55 , 'rloess' )  , 'LineWidth',3  )   
                                    plot( x * DT_bin ,smooth( Data_Rate_Signature2(  One_pair_j , : ) ,55 , 'rloess' ) , 'r' , 'LineWidth',3 )   
                                hold off
                                ylabel( 'Spikes per bin')
                                xlabel( 'Time offset, ms' )
                                legend( [ 'Channel '  num2str( One_pair_i ) ] , [ 'Channel '  num2str( One_pair_j ) ]); 
                                title( [ 'Burst profiles in 2nd file' ] ); 

                   end
                end
                
                
            end

             
            
%             Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( 1 )  
%                1;
            
            
       end % Compare_appeared_Individ_pair_conn
       
            
            
     if Show_compare_figure       
            

            figure
           Ny = 2 ; Nx = 4 ; N_bins = 20 ;
          h1 = subplot( Ny ,Nx , 1 );
                 hist( Comp_result.M_i_diff_common , N_bins );
                 xlabel( 'Strength diff')
                 ylabel('%')
                 title( 'Strength difference, stable conncetions') 
                 
           h2 = subplot( Ny ,Nx , 2 );
                 hist( abs( Comp_result.M_i_diff_common ) , N_bins );
                 xlabel( 'Strength diff')
                 ylabel('%')
                 title( 'Strength absolute differncies') 
                 
           h3 = subplot( Ny ,Nx , 3 );
                 hist( Comp_result.M_i_diff_unstable , N_bins );
                 xlabel( 'Strength')
                 ylabel('%')
                 title( 'Apeeared-dissappeared connections')      
                 
           h4 = subplot( Ny ,Nx , 4 );
                 plot( Connectiv_data1.Connectiv_matrix_max_M_vector( Comp_result.Common_connections_index ) ,...
                     Connectiv_data2.Connectiv_matrix_max_M_vector( Comp_result.Common_connections_index ) , '*' )
                 xlabel( 'Strength 1')
                 ylabel('Strength 2')
                 axis square
                 title( 'Stable connections dependence')          
                 
            h5 = subplot( Ny ,Nx , 5 );
                 plot( Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( Comp_result.Common_connections_index ) ,...
                     Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( Comp_result.Common_connections_index ) , '*' )
                 xlabel( 'Tau 1')
                 ylabel('Tau 2')
                 axis square
                 title( 'Stable connections dependence')        
                 
                 
%                subplot( Ny ,Nx , 6 )
%                  plot( Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( Appear_Connections_index ) ,...
%                      Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( Appear_Connections_index ) , '*' )
%                  xlabel( 'Tau 1')
%                  ylabel('Tau 2')
%                  axis square
%                  title( 'New connections dependence')   
%                  
%                subplot( Ny ,Nx , 7 )
%                  plot( Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( Dissappear_Connections_index ) ,...
%                      Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( Dissappear_Connections_index ) , '*' )
%                  xlabel( 'Tau 1')
%                  ylabel('Tau 2')
%                  axis square
%                  title( 'Dissapear connections dependence')            
                 
                subplot( Ny ,Nx , [ 6 7 8 ] )
                hold on
                     plot( Connectiv_data2.Connectiv_matrix_max_M_vector( Comp_result.Appear_Connections_index )  ,...
                         Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( Comp_result.Appear_Connections_index ) , '*' )
                     plot( - Connectiv_data1.Connectiv_matrix_max_M_vector( Comp_result.Dissappear_Connections_index )  ,...
                         Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( Comp_result.Dissappear_Connections_index ) , '*r' )
                 hold off
                 legend( 'Appeared' , 'Dissapeared' )
                 xlabel( 'Strength')
                 ylabel('Delay') 
                 title( 'Connections change dependence')                    

     end
%             %-- Leave only stable connections 
%             Connectiv_data1.Connectiv_matrix_tau_of_max_M_vector( Zero_delay_Connections_2files_index_for_1st_file ) = [];
%             Connectiv_data2.Connectiv_matrix_tau_of_max_M_vector( zero_delays_index_both_files ) = [];
           
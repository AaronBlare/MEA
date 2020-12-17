
%  Patterns_analysis_connectivity 
%
% >>> Input: bursts or bursts_absolute , Spike_Rates  
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



% bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
% Spike_Rates  = zeros(  Nb ,  N  );

Test_N_channels =  20  ;
 
Parralel_computing = true ; 

Comp_type = 2 ;
 
%  Nb= floor( Nb / 6 ) ;
%  Nb_erase_index = 1 : s(1) - Nb - 1;
%  whos bursts
%  bursts( Nb_erase_index  , : , : ) = [] ;
%  whos bursts
    
 

if Parralel_computing
    if matlabpool('size')== 0 
       matlabpool local 6
    end
%     matlabpool local 2
end
   
    Connectiv_data.params.show_figures = true ;
    Connectiv_data.params.Conn_Spikes_num_min = 50 ;
    Connectiv_data.params.tau_delta = 1;
    Connectiv_data.params.tau_max = 150 ;
    Connectiv_data.params.tau_number = 1 + floor( Connectiv_data.params.tau_max /Connectiv_data.params.tau_delta );     
    Connectiv_data.params.epsilon_tau = 0.3 ; 
    Connectiv_data.params.use_burst_absolute = true ; % if true - take burst_absolute, otherwise - bursts

    Connectiv_data.params.Analyze_split_data = true ; % split all bursts into sequencies 
                    %of Bursts_in_Block and analyze each Block consequently
    Connectiv_data.params.Bursts_in_Block = 400  ;
    ch_times_precomputed = false ;
        
    MAX_SPIKES_PER_CHANNEL_AT_BURST = 500 ;
    

    
    if  Connectiv_data.params.use_burst_absolute 
        s=size( bursts_absolute  );
    else
        s=size( bursts );
    end
    
    Nb = s(1); 
    N =  s(2) ; 

    if Test_N_channels > 0
       N= Test_N_channels  ;  
    end
    
    Connectiv_matrix_max_M = zeros( N ,N ) ;
    Connectiv_matrix_tau_of_max_M = zeros( N ,N ) ;
    

    
    % Calc how much Blocks will be ------------
    if Connectiv_data.params.Bursts_in_Block > Nb 
        Connectiv_data.params.Analyze_split_data = false ;
        Nb_blocks =1 ;
    end
    if Connectiv_data.params.Analyze_split_data
        Nb_blocks = ( Nb / Connectiv_data.params.Bursts_in_Block ) ;
        if floor( Nb_blocks ) == Nb_blocks 
            Nb_blocks = Nb_blocks ;
        else
            Nb_blocks = floor( Nb_blocks ) + 1 ;
        end
    else 
        Nb_blocks =1 ;
    end
    %----------------------------------------
    
    
    Connectiv_matrix_M_on_tau_Blocks = zeros( N ,N , Nb_blocks ,Connectiv_data.params.tau_number ) ; 
    Connectiv_matrix_M_on_tau  = zeros( N ,N , Connectiv_data.params.tau_number ) ; 
    Connectiv_matrix_M_on_tau_not_fitted  = zeros( N ,N , Connectiv_data.params.tau_number ) ; 
    for chi = 1 : N
        Total_Spike_Rates( chi ) = sum( Spike_Rates( : ,  chi ) );
    end
    
    
    
%------------------ Connectivity analysis ---------------
    tic
    
    %-- Copy Data to buffer ----------
    if Nb_blocks > 0
        if  Connectiv_data.params.use_burst_absolute 
           bursts_absolute_original = bursts_absolute ; 
        else
           bursts_original = bursts ; 
        end
        Nb0 = Nb ;
    end
    %---------------------------------
    
Number_of_splitted_blocks = Nb_blocks  

for Current_Data_Block = 1: Nb_blocks
    
    Nb_start = 1  ;
    Nb_end = Nb  ;
    % if analyze split blocks - then fill new block
    if Nb_blocks > 1
        Nb_start = 1 + (Current_Data_Block - 1 ) * Connectiv_data.params.Bursts_in_Block ;
        Nb_end = (Current_Data_Block  ) * Connectiv_data.params.Bursts_in_Block ;
        if Nb_end > Nb0
            Nb_end = Nb0 ;
        end

        Current_Data_Block
    end  
    
        if  Connectiv_data.params.use_burst_absolute 
%             bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
           bursts_absolute = bursts_absolute_original( Nb_start : Nb_end , : , : ) ;  
           Data_times = bursts_absolute_original( Nb_start : Nb_end , : , : ) ;   
        else
           bursts = bursts_original( Nb_start : Nb_end , : , : ) ; 
           Data_times = bursts_original( Nb_start : Nb_end , : , : ) ; 
        end
    
%     if  Connectiv_data.params.use_burst_absolute 
%         if ch_times_precomputed
%            ch_times_all = zeros( ( Nb_end - Nb_start ) * MAX_SPIKES_PER_CHANNEL_AT_BURST , N ) ;
%            ch_times_all_spikes_num = zeros( N ,1 );
%            for ch = 1 : N
%               ch_times = bursts_absolute( Nb_start : Nb_end  , ch  , : ) ;
%               ch_times = reshape( ch_times, 1 , []);
%               ch_times( ch_times==0 )=[]; 
%               ch_times_all( 1:length( ch_times ) , ch ) = ch_times ;
%               ch_times_all_spikes_num( ch ) = length( ch_times ) ;              
%            end
%         end
%     end
     Data_times_size =size( Data_times );    
     for chi = 1 : N 
         tic
        chi 
    
         parfor chj = 1 : N 
%           for chj = chi+1 : N
          if chi ~= chj
              
           
            ch1 = chi  ;
            ch2 = chj  ;  
            
            ch1_spikes_num = Total_Spike_Rates( ch1 ) ; 
            ch2_spikes_num = Total_Spike_Rates( ch2 ) ;
            
            
            % chechk if enough spikes we have
           if ch1_spikes_num > Connectiv_data.params.Conn_Spikes_num_min && ...
                   ch2_spikes_num > Connectiv_data.params.Conn_Spikes_num_min
               
               
%                  Connectiv_2_channels_connection
                % Input: ch1 , ch2 , ch1_spikes_num , ch2_spikes_num , Nb , N
                %     Connectiv_data.params.Conn_Spikes_num_min = 200 ;
                %     Connectiv_data.params.tau_delta = 1;
                %     Connectiv_data.params.tau_max = 40 ;
                %     Connectiv_data.params.epsilon_tau = 0.2 ; 
                %    
                % Output: vector M_of_tau  ( size = Connectiv_data.params.tau_max /
                % Connectiv_data.params.tau_delta  )
                  M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ; 
                     
                     
                    
                    if Comp_type == 2  
                                ch1_times = Data_times( :  , ch1 , : ) ;                                
% %                                 ch1_times = reshape( ch1_times, 1 , []);
                                ch1_times( ch1_times==0 )=[];  
                                
                                ch2_times =  Data_times( :  , ch2 , : ) ;
%                                 ch2_times = reshape( ch2_times, 1 , []);
                                ch2_times( ch2_times==0 )=[];                                  
                                 
                    end                    
                                
                    tau_i=0;
                    % Scan all tau and find how much spikes transfered
                    for tau = 0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max
                        M = 0 ;
                        tau_i = tau_i + 1 ;
                        
                        if  Connectiv_data.params.use_burst_absolute  
                                
%                             if Comp_type == 1
%                                 for Nb_i = 1 : Data_times_size(1) 
%                                    for sp_i = 1 : Data_times_size(3)
%                                        
%                                       sp_i_time = Data_times( Nb_i  , ch1 , sp_i )  ;  
%                                        if sp_i_time > 0    
%                                            ss = find( sp_i_time >= ch2_times + tau - Connectiv_data.params.epsilon_tau & ...
%                                                sp_i_time <= ch2_times + Connectiv_data.params.epsilon_tau  + tau) ;       
% %                                            ss = find( sp_i_time >= Data_times( Nb_i  , ch2 , : ) + tau - Connectiv_data.params.epsilon_tau & ...
% %                                                sp_i_time <= Data_times( Nb_i  , ch2 , : ) + Connectiv_data.params.epsilon_tau  + tau) ;                                               
%                                            if ~isempty( ss )
% %                                               ch2_times( ss ) = [] ;
%                                               M = M + 1 ; 
%                                            end
%                                        end                                       
%                                    end
%                                 end
%                             end
                            
                            if Comp_type == 2 
                                         
                                for sp_i = 1 : length( ch1_times )
                                   ss = find( ch1_times( sp_i ) >= ch2_times + tau - Connectiv_data.params.epsilon_tau & ...
                                       ch1_times( sp_i ) <= ch2_times + Connectiv_data.params.epsilon_tau  + tau) ;                                         
                                   if ~isempty( ss )
%                                       ch2_times( ss ) = [] ;
                                      M = M + 1 ; 
                                   end
                                end
                                        
                            end            

% 
%                         if Comp_type == 3
% % %                                 ch1_times = bursts_absolute( :  , ch1 , : ) ;
% %                                 ch1_times = Data_times( :  , ch1 , : ) ;                                
% % %                                 ch1_times = reshape( ch1_times, 1 , []);
% %                                 ch1_times( ch1_times==0 )=[];                           
% % %                                 ch2_times =  bursts_absolute( :  , ch2 , : ) ;
%                                 ch2_times =  Data_times( :  , ch2 , : ) ;
% %                                 ch2_times = reshape( ch2_times, 1 , []);
%                                 ch2_times( ch2_times==0 )=[];  
% 
%                                for sp_i = 1 : length( ch1_times )  
%                                    ss = find( ch1_times( sp_i ) >= ch2_times + tau - Connectiv_data.params.epsilon_tau & ...
%                                        ch1_times( sp_i ) <= ch2_times + Connectiv_data.params.epsilon_tau  + tau) ;                                      
%                                 
% %                                 for sp_i = 1 : length( ch1_times_loaded )    
% %                                    ss = find( ch1_times_loaded( sp_i ) >= ch2_times + tau - Connectiv_data.params.epsilon_tau & ...
% %                                        ch1_times_loaded( sp_i ) <= ch2_times + Connectiv_data.params.epsilon_tau  + tau) ;                                    
%                                    if ~isempty( ss )
%                                       ch2_times( ss ) = [] ;
%                                       M = M + 1 ; 
%                                    end
%                                 end
%                         end       
                            
%                             end

                        else %Connectiv_data.params.use_burst_absolute
%                             Nb=  Nb_end - Nb_start + 1 ;
%                             for Nb_i = 1 : Nb 
% %                                 ch1_times =  bursts( Nb_i  , ch1 , : ) ;
%                                 ch1_times =  Data_times( Nb_i  , ch1 , : ) ;  
%                                 ch1_times( ch1_times==0 )=[];
% %                                 ch2_times =  bursts( Nb_i  , ch2 , : ) ;
%                                 ch2_times =  Data_times( Nb_i  , ch2 , : ) ;
%                                 ch2_times( ch2_times==0 )=[]; 
% 
%                                 for sp_i = 1 : length( ch1_times )
%                                    ss = find( ch1_times( sp_i ) >= ch2_times + tau - Connectiv_data.params.epsilon_tau & ...
%                                        ch1_times( sp_i ) <= ch2_times + Connectiv_data.params.epsilon_tau  + tau) ;       
%                                    if ~isempty( ss )
%                                       M = M + 1 ; 
%                                    end
%                                 end
% 
%                             end  


%                             
                        end
                         
                        M_of_tau( tau_i )  =  M    ; 
%                     M_of_tau( tau_i )  =  M / Total_Spike_Rates( chi )   ;                        
                    end  % tau = 0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max
%                 
 
                    Connectiv_matrix_M_on_tau_Blocks( chi ,chj , Current_Data_Block , : ) =  M_of_tau  ;
                 

           else            
           end
              
     
           
          end % if chi ~= chj
        end
        
        toc
        figure
       M_of_tau =  Connectiv_matrix_M_on_tau_Blocks( chi ,2 , Current_Data_Block , : );
       M_of_tau = reshape( M_of_tau, 1 , []);
        plot( M_of_tau )
        
        a=1;
     end
end % for Current_Data_Block = 1: Cyn
    toc
    
    
    if Nb_blocks > 1 
        if  Connectiv_data.params.use_burst_absolute  
           bursts_absolute = bursts_absolute_original ;
        else
           bursts = bursts_original ;
        end
    end     
    
 %------------------ Connectivity analysis ---------------   
 %------------------------------------------------------
 
%      Connectiv_matrix_M_on_tau_Blocks = zeros( N ,N , Nb_blocks ,Connectiv_data.params.tau_number ) ; 
%     Connectiv_matrix_M_on_tau  = zeros( N ,N , Connectiv_data.params.tau_number ) ; 



%------------------ Connectivity characteristics fix - fit and store --------------- 
    Connectiv_matrix_max_M_vector = [];
    Connectiv_matrix_max_M_vector_non_zeros = [] ;
    Connectiv_matrix_tau_of_max_M_vector = []; 
    Connectiv_matrix_tau_of_max_M_vector_non_zeros = [];
    
    Fit_M_of_tau_with_func = true ; % if true - fit data with function 'M/(1+((x-T)/w).^2)+O'
    Show_fit_plot = true ;
    if Show_fit_plot 
        figure
    end
    
    
    tic
for chi = 1 : N
     parfor chj = 1 : N    
        if chi ~= chj    
         chi
         
          Total_Spike_Rates_chi = Total_Spike_Rates(chi);
          %-- Avoid devision by zero ----
          if Total_Spike_Rates( chi ) == 0
              Total_Spike_Rates_chi = 1 ;
          end
          
          M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ;  
          for Current_Data_Block = 1: Nb_blocks  
             M_of_tau_from_matrix = Connectiv_matrix_M_on_tau_Blocks( chi ,chj , Current_Data_Block , : ) ; 
             M_of_tau_from_matrix=reshape( M_of_tau_from_matrix , 1 ,[] );
               for tau_i = 1 : Connectiv_data.params.tau_number
                 M_of_tau(  tau_i )= M_of_tau(   tau_i ) + M_of_tau_from_matrix( tau_i ) ;
               end
          end 
          
          Connectiv_matrix_M_on_tau_not_fitted( chi ,chj , : )= M_of_tau / Total_Spike_Rates_chi ;
          
          tau_max = 0 ;
          M_max = 0 ;
          
          if max( M_of_tau ) > 0
              if Fit_M_of_tau_with_func

                      x=  0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ;
                      y = M_of_tau ;
                      ftype = fittype( 'M/(1+((x-T)/w).^2)+O') ; 
                      fresult = fit( x' ,y , ftype  );
%                       if fresult.T >10 
                      if    Show_fit_plot
                         plot( fresult, x , y )                         
                      end
                      tau_max = fresult.T ;
                      M_max = fresult.M ;
                      
                      % if M < 0 = bad fit, w - small = almost horizontal line
                      Connection_OK = false ;
                      if M_max > 0 
                       if abs( fresult.w) > 2  
                        if Total_Spike_Rates( chi ) > 0 && M_max  / Total_Spike_Rates( chi ) < 1
                             Connection_OK = true ;
                              for x_i = 1 : length( x )
                                M_of_tau( x_i ) = fresult.M / ( 1+( ( x(x_i)-fresult.T )/ fresult.w ).^2)+ fresult.O ;
                              end
                              
%                               if Show_fit_plot 
%                                 plot( fresult, x , M_of_tau )
%                               end

%                               Connectiv_matrix_M_on_tau_Blocks( chi ,chj , : )= M_of_tau /   Total_Spike_Rates( chi ) ;
                              tau_max = H( tau_max ) * tau_max ; 
                        end
                       end
                      end
                      
                      if ~Connection_OK
                          M_max = 0 ;
                          tau_max = 0 ;
                      end

              else
%                   Connectiv_matrix_M_on_tau_Blocks( chi ,chj , : )= M_of_tau / / Total_Spike_Rates( chi );
                  M_max = max( M_of_tau );  
                  tau_max_index = find( M_of_tau == M_max ,1) ;            
                  tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
              end
          end
          

          
          Connectiv_matrix_M_on_tau( chi ,chj , : )= M_of_tau / Total_Spike_Rates_chi ;
          
%                 if abs( tau_max ) > 10
%                     figure
%                     %------ Plot one channel pair M on tau ---------------- 
%                     tau_all = 0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ;
%                     M_of_tau = reshape( M_of_tau , 1 , []);
%                     plot( tau_all , M_of_tau ) ;
%                     %-----------------------------------------
%                 end
          
          Connectiv_matrix_max_M( chi , chj ) = M_max  / Total_Spike_Rates_chi ; 
          Connectiv_matrix_tau_of_max_M( chi , chj ) = tau_max ; 
          
          % Take all connectivity values and delays and form vector
            if Connectiv_matrix_max_M( chi , chj ) > 0
                Connectiv_matrix_max_M_vector_non_zeros =[Connectiv_matrix_max_M_vector_non_zeros   Connectiv_matrix_max_M( chi , chj ) ];
                Connectiv_matrix_tau_of_max_M_vector_non_zeros = [Connectiv_matrix_tau_of_max_M_vector_non_zeros ...
                        Connectiv_matrix_tau_of_max_M( chi , chj ) ];
            end 
            Connectiv_matrix_max_M_vector  =[Connectiv_matrix_max_M_vector   Connectiv_matrix_max_M( chi , chj ) ];
            Connectiv_matrix_tau_of_max_M_vector  = [Connectiv_matrix_tau_of_max_M_vector ...
                        Connectiv_matrix_tau_of_max_M( chi , chj ) ];            
            
            
        end
    end %  for chj = 1 : N   
end
toc


Connectiv_data.Connectiv_matrix_M_on_tau = Connectiv_matrix_M_on_tau ;
Connectiv_data.Connectiv_matrix_max_M = Connectiv_matrix_max_M ;
Connectiv_data.Connectiv_matrix_max_M_vector = Connectiv_matrix_max_M_vector ;
Connectiv_data.Connectiv_matrix_max_M_vector_non_zeros = Connectiv_matrix_max_M_vector_non_zeros ;
Connectiv_data.Connectiv_matrix_tau_of_max_M = Connectiv_matrix_tau_of_max_M ;
Connectiv_data.Connectiv_matrix_tau_of_max_M_vector = Connectiv_matrix_tau_of_max_M_vector ;
Connectiv_data.Connectiv_matrix_tau_of_max_M_vector_non_zeros = Connectiv_matrix_tau_of_max_M_vector_non_zeros ;
Connectiv_data.Connectiv_matrix_M_on_tau = Connectiv_matrix_M_on_tau ;



if Connectiv_data.params.show_figures
    
Connectiv_matrix_statistics_figures
    
  end  
    
    
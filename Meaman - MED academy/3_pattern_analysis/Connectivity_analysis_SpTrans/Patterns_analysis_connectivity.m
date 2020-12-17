
%  Patterns_analysis_connectivity 
%
% >>> Input: bursts or bursts_absolute , Spike_Rates  , Nb , N ,
% Burst_Data_Ver , [ Analyze_only_one_pair , One_pair_i , One_pair_j ]
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
%   [ One_pair.M_on_tau_not_fitted  ( One_pair_i ,One_pair_j , :);
%     One_pair.M_on_tau_One_pair ( One_pair_i ,One_pair_j , :);
%     One_pair.max_M - strength
%     One_pair.tau_of_max_M - delay

DT_bin_1ms = 1 ;


GLOBAL_CONSTANTS_load






% bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
% Spike_Rates  = zeros(  Nb ,  N  );

Test_N_channels = 0  ;

if ~exist( 'Analyze_only_one_pair' )
    Analyze_only_one_pair = false ;
end

bursts_exist = false ;
if ~exist( 'bursts' )
    bursts_exist = true ;
end

%     One_pair_i = 1 ;
%     One_pair_j = 2 ;

Connectivity_parameters_init


%     bursts_absolute( 60 :end,:,:) = [] ;
    
 if Parralel_computing && Comp_type == 2
    if matlabpool('size')== 0 
       num_cores = feature('numCores') ;
       if num_cores < 8
        matlabpool   
       else
%         matlabpool('local',num_cores - 1 )
        matlabpool('local', 4 )
%         matlabpool('local',num_cores - 7 )
       end
    end
%     matlabpool local 2
end

if Parralel_computing && Comp_type == 3
        jm = findResource('scheduler','configuration','local');

    pjob = jm.createParallelJob; 
%     set(pjob,'MaximumNumberOfWorkers',7 ); 
    set(pjob, 'FileDependencies', {'B:\Med64\Meaman\Connectivity_analysis_SpTrans'} );
%     Extract_data_to_cells=true ;
end

    if Test_N_channels > 0
       N= Test_N_channels  ;  
    end
    
if Analyze_only_one_pair 
   ch_i_start = One_pair_i;
   ch_i_end = One_pair_i;
   ch_j_start = One_pair_j;
   ch_j_end = One_pair_j; 
else
   ch_i_start = 1;
   ch_i_end = N;
   ch_j_start = 1;
   ch_j_end = N;  
end
   


    if  Connectiv_data.params.use_burst_absolute 
%         if Burst_Data_Ver == 1 
        s=size( bursts_absolute  );
%         else        
%         s=size( bursts_absolute{1} )
%         end
    else
        s=size( bursts );
    end
    
%     if Burst_Data_Ver == 1 
%         Nb = s(1); 
%         N =  s(2) ; 
%     end


    
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
    
%     figure
%     hold on
%     for bi = 1 : 1
%         for ch =1 : 6 
%        tt = bursts_absolute( bi , ch , : );
%        tt =reshape( tt ,1, [] );
%         plot(   tt , ch , '*')
%         end
%     end
%     hold off
    
    Connectiv_matrix_M_on_tau_Blocks = zeros( N ,N , Nb_blocks ,Connectiv_data.params.tau_number ) ; 
    Connectiv_matrix_M_on_tau  = zeros( N ,N , Connectiv_data.params.tau_number ) ; 
    Connectiv_matrix_M_on_tau_not_fitted  = zeros( N ,N , Connectiv_data.params.tau_number ) ; 
    
    for chi = 1 : N
         Total_Spike_Rates_all_channels( chi ) = sum( Spike_Rates( : ,  chi ) );
    end 
    
    if Connectiv_data.params.Analysis_ver > 3 
%         Total_Spike_Rates = Firing_Rates_each_channel_mean ; % Firing_Rates_each_channel_mean
        Total_Spike_Rates = Spike_Rates_each_channel_mean ; % Firing_Rates_each_channel_mean        
    else    
        for chi = 1 : N
            Total_Spike_Rates( chi ) = sum( Spike_Rates( : ,  chi ) );
        end
    end
    
Seconds_per_channel_analysis = zeros( N ,1 );  
%------------------ Connectivity analysis ---------------
tic
    
    %-- Copy Data to buffer ----------
    if Nb_blocks > 0
        if ~Extract_data_to_cells
            if  Connectiv_data.params.use_burst_absolute 
               bursts_absolute_original = bursts_absolute ; 
            else
               bursts_original = bursts ; 
            end
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
Nb_start
Nb_end
        Current_Data_Block
    end  
    

    
%     if  Connectiv_data.params.use_burst_absolute 
        if Extract_data_to_cells
            Spiketimes_all = cell(  N ,1); % each cell is array of spike times
            
            
                %find first spike time and take out from all other spikes so spike times will start from 0
                tic
                first_spikes = zeros( N,1); 
                for chv = 1 : N 
                    if Burst_Data_Ver == 1 
                          spike_ts =  (bursts_absolute( 1   , chv  , : )   );
                          spike_ts = reshape( spike_ts, 1 , []) ;
                              chv ;
                             [ f , i ] = find( spike_ts > 0 )  ;
                          if length( i )>0
                             first_spikes(chv) = min( spike_ts( i ));
                          end
                    else % if bursts_absolute is cell array
                        
                        if Nb_end > 0 
                        spike_ts =  bursts_absolute{ 1 }{ chv}  ;  
                        [ f , i ] = find( spike_ts > 0 )  ;
                          if length( i )>0
                             first_spikes(chv) = min( spike_ts( i ));
                          end 
                        end
                    end
                end

                first_spike_time_in_Blockburst = min( first_spikes );

                 
               
                 
               for ch = 1 : N
                   if precise_spikes_construct
                       ch_times = [] ;
                       ch_times_buf = [];
                   end
                   
                   if Burst_Data_Ver == 1 
                       for nbi = Nb_start  : Nb_end 
                          last_spikes = zeros( N,1); 
                          for chv = 1 : N  
                             last_spikes(chv) = max( bursts_absolute( nbi   , ch  , : ) );
                          end
    %                       max_time = max( bursts_absolute( nbi   , ch  , : ) );
                          ch_times_buf = bursts_absolute( nbi   , ch  , : )  ; 
                          ch_times_buf = reshape( ch_times_buf, 1 , []);
                          ch_times_buf( ch_times_buf==0 )=[]; 
                          ch_times_buf = ch_times_buf + max( last_spikes );
                          ch_times =[ ch_times ch_times_buf ];
                       end
                   else
                      
                       for nbi = Nb_start  : Nb_end 
                           
%                            tic
                           if precise_spikes_construct
                              last_spikes = zeros( N,1); 
                              for chv = 1 : N  
                                  chv;
                                 last_spike = max( bursts_absolute{ nbi }{ chv } ) ;
                                 if ~isempty( last_spike ) 
                                    last_spikes(chv) = last_spike ;
                                 end
                              end
                           end
%                           toc
                          
                           
% %                           max_time = max( bursts_absolute( nbi   , ch  , : ) );
                            %--WORKING   
%                           ch_times_buf = bursts_absolute{ nbi }{ ch }  ;  

                            %--WORKING 2
%                             ch_times_buf = bursts_absolute{ nbi }{ ch } + max( last_spikes );  
                            
% %                           ch_times_buf( ch_times_buf==0 )=[]; 
                            %--WORKING   
%                           ch_times_buf = ch_times_buf + max( last_spikes );

% tic

                            if precise_spikes_construct
                              Dt =  max( last_spikes );
                            else
                              Dt = 0 ;
                            end
                          Spiketimes_all{ ch } = [ Spiketimes_all{ ch }  ; bursts_absolute{ nbi }{ ch } + Dt    ] ;
                          
                          if precise_spikes_construct
                              if ~isempty( ch_times_buf )
                                  %--WORKING   
    %                             ch_times =[ ch_times ch_times_buf' ];

                                    %--WORKING  2
    %                             Spiketimes_all{ ch } = [ Spiketimes_all{ ch } ch_times_buf' ] ; 

                              end
                          end
% toc
                           
                       end
                       
                   end
                   
%--WORKING                   
%                    ch_times = ch_times - first_spike_time_in_Blockburst + 300 ; 

                Spiketimes_all{ ch } = Spiketimes_all{ ch } - first_spike_time_in_Blockburst + 300 ; 
                    

%                     ch_times =  Spiketimes_all{ ch } ;
%                   ch_times = reshape( ch_times, 1 , []);
%                   a=diff(ch_times);
%                   figure
%                   hold on
%                   plot(ch_times,'r')
%                   plot(a)
%                   hold off
%                   ch_times( ch_times==0 )=[];     
%                   d=diff(ch_times) ;
%                   min(d)

%--WORKING   
%                   Spiketimes_all{ ch } = ch_times ;
               end
                
             if Multiply_all_spike_times_by_dt 
               Spiketimes_all_dt = cell(  N ,1) ; % each cell is array of spike times 
               for ch = 1 : N 
                  Spiketimes_all_dt{ch} = Spiketimes_all{ch} * dt ; % each cell is array of spike times  
               end
             end              
               
               
               
% %             if Mex_function_metod == 3
%                Spiketimes_all_dt = cell(  N ,1) ; % each cell is array of spike times
%                Spiketrains_binary = cell(  N ,1) ;
%                for ch = 1 : N
%                   Spiketimes_all_dt{ch} = Spiketimes_all{ch} / dt ; % each cell is array of spike times
%                   spike_train_binary = zeros( 1,N );
%                   a = Spiketimes_all_dt{ch};
%                   spike_train_binary( floor( a ) )=1; 
%                   Spiketrains_binary{ ch } = spike_train_binary ;
%                end
% %             end
        else
            % if not using spike time in cell object and use raw burst data
                    if  Connectiv_data.params.use_burst_absolute 
            %             bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
                       bursts_absolute = bursts_absolute_original( Nb_start : Nb_end , : , : ) ;  
                       Data_times = bursts_absolute_original( Nb_start : Nb_end , : , : ) ;   
                    else
                       bursts = bursts_original( Nb_start : Nb_end , : , : ) ; 
                       Data_times = bursts_original( Nb_start : Nb_end , : , : ) ; 
                    end
        end
%     end
%      Data_times_size =size( Data_times );    
    
%% - Main cycle for alll channels using parfor -----------------------------------------    
  if  Comp_type == 2  
     for chi = ch_i_start : ch_i_end 
%          tic
        chi

%         if Comp_type == 2 ||   Comp_type == 3
%              ch1_times_loaded = Data_times( :  , chi , : ) ;                                
%     %          ch1_times = reshape( ch1_times, 1 , []);
%              ch1_times_loaded( ch1_times_loaded==0 )=[];  
%         end

%-============================================
%-============================================
%          for chj = ch_j_start : ch_j_end 
        parfor chj = ch_j_start : ch_j_end   
%-============================================
%-============================================
             
             
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
                  
                     
%                     if Comp_type == 1  
% %                                 ch1_times = Data_times( :  , ch1 , : ) ;                                
% %                                 ch1_times = reshape( ch1_times, 1 , []);
% %                                 ch1_times( ch1_times==0 )=[];  
%                                 
%                                 ch2_times =  Data_times( :  , ch2 , : ) ;
% %                                 ch2_times = reshape( ch2_times, 1 , []);
%                                 ch2_times( ch2_times==0 )=[];                                  
%                                  
%                     end 
                    
%++++
%                     if Comp_type == 2  
%                                 ch1_times = Data_times( :  , ch1 , : ) ;                                
% % %                                 ch1_times = reshape( ch1_times, 1 , []);
%                                 ch1_times( ch1_times==0 )=[];  
%                                 
%                                 ch2_times =  Data_times( :  , ch2 , : ) ;
% %                                 ch2_times = reshape( ch2_times, 1 , []);
%                                 ch2_times( ch2_times==0 )=[];                                  
%                                  
%                     end                    
%+++++++

                    
                    M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ; 
                    
                 if ~Use_mex_func
                    % Scan all tau and find how much spikes transfered
                    
%                     Nb_i = 1 ;
%                     
%                     for Nb_i = 1 : Nb 
% %                     ch1_times = Spiketimes_all{ ch1 } ;
%                         tau_i=0;
%                         ch1_times = bursts{ Nb_i }(ch1 ) ;
%                         ch1_times = cell2mat( ch1_times ) ;
%     %                     ch2_times = Spiketimes_all{ ch2 } ;
%                         ch2_times = bursts{ Nb_i }(ch2 ) ;
%                         ch2_times = cell2mat( ch2_times ) ;
% 
%                         ch2
%                         for tau = 0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max
%                             M = 0 ;
%                             tau_i = tau_i + 1 ;                                                         
%                                     for sp_i = 1 : length( ch1_times )
%                                         
%                                        ss = find( ch1_times( sp_i ) + tau - Connectiv_data.params.epsilon_tau <= ch2_times  & ...
%                                            ch1_times( sp_i ) + Connectiv_data.params.epsilon_tau  + tau >= ch2_times ) ;                                         
%                                        if ~isempty( ss )
%                                            a=1 ;
%                                           if exist( 'SpikeRate_burst_profile_1ms')
%                                              if tau > 2 
%                                                  
%                                              SRP1 = SpikeRate_burst_profile_1ms( floor( ch1_times( sp_i )  ) + 1);
%                                              SRP2 = SpikeRate_burst_profile_1ms( floor( ch2_times( ss(1) ) ) + 1);
%                                              SRP_diff = SRP2 / SRP1 ;
%                                              a= SRP_diff ;
%                                              end
%                                           end   
%                                           a=1 ;
%     %                                       ch2_times( ss ) = [] ;
%                                           M = M + 1 / a  ; 
%                                        end
%                                     end            
%                             M_of_tau( tau_i )  = M_of_tau( tau_i ) +M    ; 
%     %                     M_of_tau( tau_i )  =  M / Total_Spike_Rates( chi )   ;                        
%                         end  % tau = 0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max
%                     
%                     end
%                         
%                     figure
%                     hold on
%                     plot( M_of_tau )
%                     plot( smooth(M_of_tau, 40 , 'rloess' ) , 'r' ,'LineWidth',2 ));
%                     hold off
%                     title( ['Ch_i=' num2str(ch1) ',Ch_j=' num2str(ch2) ])  
%                     if exist( 'SpikeRate_burst_profile_1ms')
%                         
%                     end
                    
                 else
%++++++++++++++                     
%                         M_of_tau  = Spikes_transferred( ch1_times   , ch2_times   , ...
%                                 Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
%                                 Connectiv_data.params.epsilon_tau )  ;
%++++++++++++++
            if Mex_function_metod == 1
%                         M_of_tau  = Spikes_transferred( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                        M_of_tau  = Sp_trans_slow( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                                Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
                                Connectiv_data.params.epsilon_tau )  ;
            end
            if Mex_function_metod == 2
                        
 
                        M_of_tau  = Spikes_transferred_fast01( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                                Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
                                Connectiv_data.params.epsilon_tau )  ;      
            end
            if Mex_function_metod == 3
%                 
%                   Connectiv_data.tau_max = -1 ;
%                   dt = 100  ;
            
%                          M_of_tau1  = Sp_trans_slow( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
%                                 Connectiv_data.params.tau_delta ,  dt_sign* Connectiv_data.params.tau_max ,...
%                                 Connectiv_data.params.epsilon_tau )  ;
% %                             
%                         tic
%                         M_of_tau1   = Spikes_transferred_fast01( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
%                                 Connectiv_data.params.tau_delta ,   Connectiv_data.params.tau_max ,...
%                                 Connectiv_data.params.epsilon_tau )  ;
%                             toc

%                         tic
% %                         M_of_tau1   = Sp_trans_fast_01( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
% %                                 Connectiv_data.params.tau_delta ,   Connectiv_data.params.tau_max ,...
% %                                 Connectiv_data.params.epsilon_tau )  ;
%                          toc

%                          tic   
%                     Connectiv_data.params.tau_max_sign = -1 ; % if tau_max < 0 then analyze spikes recieved, otherwise -spikes transferred    
                       M_of_tau  = Sp_trans_fast_01( Spiketimes_all{ ch1 }'   , Spiketimes_all{ ch2 }'    , ...
                                Connectiv_data.params.tau_delta   , Connectiv_data.params.tau_max_sign*Connectiv_data.params.tau_max   ,...
                                Connectiv_data.params.epsilon_tau    )  ;  
%                           M_of_tau2 =   M_of_tau  ;
%                          toc    
%                        Strength_i_j = max( M_of_tau ) / Total_Spike_Rates( ch1 ) ;
%                        Strength_j_i = max( M_of_tau ) / Total_Spike_Rates( ch2 ) ;
%                  
%                         M_of_tau3  = Sp_trans_fast_01( Spiketimes_all{ ch1 } * dt  , Spiketimes_all{ ch2 } * dt   , ...
%                                 Connectiv_data.params.tau_delta * dt , dt_sign*Connectiv_data.params.tau_max * dt ,...
%                                 Connectiv_data.params.epsilon_tau * dt  )  ;  
%                          M_of_tau =   M_of_tau3 ;
                             
    %-------------------- Mex function ¹3 - fast02.cpp
%                   spike_train_binary = zeros( 1,N );
%                   a = Spiketimes_all_dt{ch2}; 
%                   spike_train_binary( floor( a ) )=1; 
%                   spike_train_binary=[spike_train_binary 0 0 0 ] ;
%                                   
%                         M_of_tau4  = Sp_trans_fast_02( Spiketimes_all_dt{ ch1 } , spike_train_binary , ...
%                                  Connectiv_data.params.tau_delta * dt , dt_sign *Connectiv_data.params.tau_max * dt ,...
%                                 Connectiv_data.params.epsilon_tau * dt  )  ;   
%                             M_of_tau =   M_of_tau4 ;
    %-----------------------------------------------------------                        
%                             figure
%                             tau_x = 0:Connectiv_data.params.tau_delta:Connectiv_data.params.tau_max ;
%                             hold on
%                             plot( tau_x , M_of_tau1 , '-*b') 
%                             plot( tau_x , M_of_tau2 , '-*r')  
% %                             plot( M_of_tau3 ,'g')  
% %                             plot( M_of_tau4 ,'--b')          
%                                 xlabel( 'Connectivity delay, ms')
%                                  ylabel( 'Connectivity strength, spikes')
%                         hold off   
% %                          legend( 'Spikes transferred','Spikes recieved','method 2 * dt', 'method 3 * dt' )
%                             legend( 'method 1','method 2','method 2 * dt', 'method 3 * dt' )

                              
                          
             end            
            

                            
                            
                 end
                    Connectiv_matrix_M_on_tau_Blocks( chi ,chj , Current_Data_Block , : ) =  M_of_tau  ;
                 

           else            
           end
           
           
%--- DEBUG--- SHOW SPIKE TRANSFERRED FOR EACH PAIR           
%        figure
%        M_of_tau =  Connectiv_matrix_M_on_tau_Blocks( chi ,chj , Current_Data_Block , : );
%        M_of_tau = reshape( M_of_tau, 1 , []);
%         plot( M_of_tau )
%--------------------------------------------        
           
          end % if chi ~= chj
        end
        
%         Seconds_per_channel_analysis( chi ) =  toc  ;
% %         Estimated_time_to_finish_sec = ( N - chi ) * mean( Seconds_per_channel_analysis )  
%         Elapsed_time_min = floor(  sum( Seconds_per_channel_analysis )  / 60 )
        

%         
%         a=1;
     end
  end
%% - Main cycle for all channels using tasks -----------------------------------------  

Connectiv_analysis_UsingTasks
    
  
end % for Current_Data_Block = 1: Cyn
    toc
%=========================================================================    
%=========================================================================
%=========================================================================
%=========================================================================


Time_to_analyze_all_raw_conns_sec = toc 

    if Nb_blocks > 1 
        if ~Extract_data_to_cells
            if  Connectiv_data.params.use_burst_absolute  
               bursts_absolute = bursts_absolute_original ;
            else
               bursts = bursts_original ;
            end
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
%     Show_fit_plot = true ;
    if Show_fit_plot 
        figure
    end
    
%     reset(RandStream.getDefaultStream);
%     tic
 

%% ---
%>>>>>>>>>> Analyze spikerate profiles
if ~Analyze_only_one_pair
               DT_bin = 1 ;
               End_t = 300 ; %median(ANALYZED_DATA.BurstDurations) ;
                 
                       
                              fire_bins = floor((End_t - 0) / DT_bin) ;
                              DT_BINS_number =fire_bins;
                              var.Spike_Rates_each_burst = []; 
                              var.Burst_Data_Ver = Burst_Data_Ver ;
                              var.N = N ;
                              var.Find_only_SpikeRate = true ;
                              
                              [   TimeBin_Total_Spikes1 ,  TimeBin_Total_Spikes_mean1 , TimeBin_Total_Spikes_std1 , ...
                               Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
                               Data_Rate_Signature1_std ] ...
                                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , Nb ...
                                  , bursts_absolute , ...
                                  0 ,  End_t  , DT_bin  , [] ,var );
                                 
                               
                              if isfield( Global_flags , 'Search_Params' )
                                  if isfield( Global_flags.Search_Params , 'Spike_Rate_Signature_1ms_smooth' )
                                      Spike_Rate_Signature_1ms_smooth = Global_flags.Search_Params.Spike_Rate_Signature_1ms_smooth ;
                                  end
                              else
                                  if isfield( Global_flags , 'Spike_Rate_Signature_1ms_smooth' )
                                  Spike_Rate_Signature_1ms_smooth = Global_flags.Spike_Rate_Signature_1ms_smooth ;
                                  end
                              end
                              
                                      
                          
                     Correlation_matrix_SR_max_corr_delay = zeros( N , N ) ;  
                     Correlation_matrix_SR_smooth_max_corr_delay = zeros( N , N ) ;
                     for ch_i = 1 : N 
                       for ch_j = 1 : N  
                         if ch_i ~= ch_j  
                                 data_i = Data_Rate_Signature1( :  , ch_i  );
                                 data_j = Data_Rate_Signature1( : ,  ch_j ); 
                                 
                                 smooth_prfile_channel_i = smooth( data_i , Spike_Rate_Signature_1ms_smooth , 'loess' );
                                 smooth_prfile_channel_j = smooth( data_j  ,Spike_Rate_Signature_1ms_smooth , 'loess' );  
                                   
                                % correlation spikerate profile smooth
                                 % ---------------------------
                                 max_corr_lag = floor(length( smooth_prfile_channel_j) /2 ) ;
                                 [c,lags] = xcorr( smooth_prfile_channel_i , smooth_prfile_channel_j , ...
                                     floor(length( smooth_prfile_channel_j) /2 ) , 'coeff' );
                                  
                                    [m,i]=max(c);
                                    if ~isempty( i ) && mean( smooth_prfile_channel_j )>0 && ...
                                        mean( smooth_prfile_channel_i ) > 0 
                                      Max_corr_delay_smooth = ( lags( i(1) ) ) * DT_bin_1ms ;
                                    else
                                      Max_corr_delay_smooth =0 ;
                                    end 
                                 Correlation_matrix_SR_smooth_max_corr_delay( ch_i , ch_j ) = Max_corr_delay_smooth ;     
                                 
                                 % correlation spikerate profile smooth
                                 [c,lags] = xcorr( data_i , data_j , ...
                                     floor(length( smooth_prfile_channel_j) /2 ) , 'coeff' );
                                 [m,i]=max(c);
                                    if ~isempty( i ) && mean( data_i )>0 && ...
                                        mean( data_j ) > 0 
                                      Max_corr_delay = ( lags( i(1) ) ) * DT_bin_1ms ;
                                    else
                                      Max_corr_delay =0 ;
                                    end
                                 % ---------------------------  
                                 Correlation_matrix_SR_max_corr_delay( ch_i , ch_j ) = Max_corr_delay ;    
                                 % ---------------------------  
                         end
                       end
                     end
           
end
%>>>>>>>>>>
%% ---





%% --- Fitting responses curves -------------

if Parralel_computing  
    if matlabpool('size')== 0 
       matlabpool 
    end
%     matlabpool local 2
end


tau_x =  0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ; %  delays for fitting ;
    x_normed = (max(tau_x)/2  - tau_x) / max(tau_x) ;
    x_normed=-x_normed; % delays for poly fit

for chi = ch_i_start : ch_i_end
    fitting_channel = chi 

    %>>>>>>>>>> for or parfor !!!!!!!!! >>>>>>>>>>>>>>>>>>>
      for chj = ch_j_start : ch_j_end    
%      parfor chj = ch_j_start : ch_j_end             
    %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<        
        if chi ~= chj    
  
%>>>>>>>>>>
 
%           Total_Spike_Rates_chi = Total_Spike_Rates(chi);
%           Total_Spike_Rates_chj = Total_Spike_Rates(chj);
          Total_Spike_Rates_chi = Total_Spike_Rates_all_channels(chi);
          Total_Spike_Rates_chj = Total_Spike_Rates_all_channels(chj);
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
          
          Connectiv_matrix_M_on_tau_not_fitted( chi ,chj , : )= M_of_tau  ;
          
          tau_max = 0 ;
          M_max = 0 ;
          

 
          if max( M_of_tau ) > 0
              chi ;
              chj ;
%                          if    Show_fit_plot
%                               
%                              plot( M_of_tau )   
%                              xlabel( 'Connectivity delay, ms')
%                              ylabel( 'Connectivity strength , spikes transferred')
%                              if Pause_on_first_M_of_tau
%                                  pause
%                              end
%                          end
          end
          
          if max( M_of_tau ) > 0
              if Fit_M_of_tau_with_func
                    
                  Analyze_trans_func = true ;
                  %-- if analyze only channels with enough spikes inside--
                  if fit_only_where_spikes_many 
                     if Total_Spike_Rates( chi ) > 0 &&  Total_Spike_Rates( chj ) > 0
                         Analyze_trans_func = true ;
                     else
                         Analyze_trans_func = false ;
                     end
                  end
                  %---------------------------------
                        % x defined before
%                       x=  0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ;
                      M_of_tau_original = M_of_tau ;
                      Connection_OK = false ;
                      
                 if Test_different_smooth_filters
                     M_of_tau_fit = smooth(M_of_tau_original, GLOBAL_const.Spike_Rate_Signature_1ms_smooth , 'loess' );    
                     M_max = max( M_of_tau_fit );  
                     tau_max_index = find( M_of_tau_fit == M_max ,1) ;            
                     tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
                     if tau_max >= tau_max_figure_thres && Analyze_trans_func
                         Analyze_trans_func = true ;
                     else
                         Analyze_trans_func = false ;                         
                     end
                         
                 end
                      
                      
                  if Analyze_trans_func    
                      
                      if ( ~Simple_fitting && ~No_fitting  ) || Test_different_smooth_filters
                          
%                           Fitting_Response_curve_LeFeber


                           ftype = fittype( 'M/(1+((x-T)/w).^2)+O') ;  
    %                       warning off
                          fresult = fit( tau_x' ,M_of_tau_original , ftype ,'Lower',[1 ,-100 , -300 , - 1000],'Upper',...
                              [Inf,1000 , 300 , 1000 ],'StartPoint',[1000 -5 0 3], 'MaxIter' , Connectiv_data.params.Fit_Max_iterations  );
    % fresult = fit( x' ,y , ftype ,'StartPoint',[1000 -5 0 3], 'MaxIter' , 3000,fitOptions  );                      
    %                       fitOptions = fitoptions( 'Method','CubicSplineInterpolant');
            %                           'NearestInterpolant'Nearest neighbor interpolation
            %                         'LinearInterpolant'Linear interpolation
            %                         'PchipInterpolant'Piecewise cubic Hermite interpolation (curves only)
            %                         'CubicSplineInterpolant'Cubic spline interpolation
            %                         'BiharmonicInterpolant'Biharmonic surface interpolation
            %                         'SmoothingSpline'Smoothing spline
            %                         'LowessFit'Lowess smoothing (surfaces only)
            %                         'LinearLeastSquares'Linear least squares
            %                         'NonlinearLeastSquares'Nonlinear least squares
    %                         warning on
                            tau_max = fresult.T ;
                            M_max = fresult.M ;
                            if M_max > 0 
                               if abs( fresult.w) > 2  
                                if Total_Spike_Rates( chi ) > 0 &&  Total_Spike_Rates( chj ) > 0
                                     Connection_OK = true ;
                                      for x_i = 1 : length( tau_x )
                                        M_of_tau( x_i ) = fresult.M / ( 1+( ( tau_x(x_i)-fresult.T )/ fresult.w ).^2)+ fresult.O ;
                                      end  
        %                               if Show_fit_plot 
        %                                 plot( fresult, x , M_of_tau )
        %                               end 
        %                               Connectiv_matrix_M_on_tau_Blocks( chi ,chj , : )= M_of_tau /   Total_Spike_Rates( chi ) ;
                                      tau_max = H( tau_max ) * tau_max ; 
                                      M_max = max( M_of_tau ) ;
                                end
                               end
                            end
                            
                            if Test_different_smooth_filters
                               M_of_tau_test_func_fit =  M_of_tau ;
                            end
                      end
                      if  Simple_fitting || Test_different_smooth_filters
                          
%                           Fitting_Response_curve_Polyfit

                          
                          ftype = fittype( 'poly6') ;  
    %                       warning off
                                 
                          fresult = fit( x_normed' ,M_of_tau_original , ftype );
                          p = [  fresult.p1 fresult.p2 fresult.p3 fresult.p4 fresult.p5  fresult.p6 fresult.p7 ];
                          M_of_tau_poly_fit = polyval(p,x_normed);
                          y_fit = M_of_tau_poly_fit ;
                          M_max = max( M_of_tau_poly_fit );  
                          tau_max_index = find( M_of_tau_poly_fit == M_max ,1) ;            
                           tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
                           if Total_Spike_Rates( chi ) > 0 &&  Total_Spike_Rates( chj ) > 0
                                     Connection_OK = true ;
                                    M_of_tau  =   M_of_tau_poly_fit ;
                           end   
                           
                           if Test_different_smooth_filters
                               M_of_tau_test_poly_fit =  M_of_tau_poly_fit ;
                            end
                           
                      end
                      
                      if  No_fitting
                          
%                           Fitting_Response_curve_Smooth

 
                          
                          %                            M_of_tau0 = M_of_tau ;

                          if measure_time_of_fitting 
                              tic
                          end
                          
                          %+++++++++++++++++++++++++++++++++++++++++++++
                          %+++++++++++++++++++++++++++++++++++++++++++++
                            M_of_tau_fit = smooth(M_of_tau_original, smooth_window , smooth_fit_type );
                          %+++++++++++++++++++++++++++++++++++++++++++++
                          %+++++++++++++++++++++++++++++++++++++++++++++
                          
                          test_smooth = zeros( 4 , 1) ;
                          test_smooth_window = zeros( 4 , 1) ;
                          
                          if Test_different_smooth_filters
                              
                               
                               test_smooth(1).str = 'loess' ;
                               test_smooth(2).str = 'loess' ;
                               test_smooth(3).str = 'loess' ;
                               test_smooth(4).str = 'rloess' ;
                               
                               test_smooth_window(1) = 40 ;
                               test_smooth_window(2) = 60 ;
                               test_smooth_window(3) = 80 ;
                               test_smooth_window(4) = 40 ;
                               
                               
                               M_of_tau_test_smooth_fit1 =  smooth(M_of_tau_original, test_smooth_window(1) , test_smooth(1).str );  
                               M_of_tau_test_smooth_fit2 =  smooth(M_of_tau_original, test_smooth_window(2) , test_smooth(2).str );  
                               M_of_tau_test_smooth_fit3 =  smooth(M_of_tau_original, test_smooth_window(3) , test_smooth(3).str );  
                               M_of_tau_test_smooth_fit4 =  smooth(M_of_tau_original, test_smooth_window(4) , test_smooth(4).str );  
                          end
                          
                          if measure_time_of_fitting 
                              toc
                          end
%                           y_fit = smooth(M_of_tau,55  );
%                           M_of_tau_fit = y_fit ;
                          M_max = max( M_of_tau_fit );  
                          tau_max_index = find( M_of_tau_fit == M_max ,1) ;            
                           tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
                           if Total_Spike_Rates( chi ) > 0 &&  Total_Spike_Rates( chj ) > 0
                                     Connection_OK = true ;
                                    M_of_tau  =   M_of_tau_fit ;
                                    
%                           x= ;y=;xi= ;  xs=  0 : 5 : Connectiv_data.params.tau_max ;         
                           end
                            
                      end     
 
% %                       fit_taumax_all = [fit_taumax_all tau_max];
% %                       fit_max_all = [fit_max_all M_max];
% %                   end
                      %------------ Plot fit results --------------------   
                        
                      
                      if tau_max >= tau_max_figure_thres  
                          if    Show_fit_plot
%                              figure
%                                  if Simple_fitting
                                     hold on
                                     Markersiz = 1.5 ;
                                     
                                   SR_i = Spike_Rates_each_channel_mean( chi) ;
%                                    SR_i = Total_Spike_Rates( chi ) ;
%                                      SR_i = Total_Spike_Rates_all_channels( chi) ;
                                 
                                   SR_j = Spike_Rates_each_channel_mean( chj) ;
%                                    SR_j = Total_Spike_Rates( chj ) ;
%                                      SR_j = Total_Spike_Rates_all_channels( chj) ;                                        
                                     
                                     
%                                      NormY = 1 ;
                                     % spikes transferred - spikes per burst
%                                      NormY = Nb ; 
                                     % spikes transferred - % spikes trans  
%                                      NormY = Spike_Rates_each_channel_mean( chi)  ;

                                     % spikes transferred - % spikes trans  
                                      NormY = Total_Spike_Rates_all_channels( chi)  ;
                                      
                                     
                                    plot(  tau_x , M_of_tau_original / NormY,'--ow', 'MarkerFaceColor' ,'k' , 'MarkerEdgeColor' ,'b' ,'MarkerSize' , Markersiz , 'LineWidth', 0.1    )   
                                     
                                    if Test_different_smooth_filters
                                        line_fat = 2 ;
                                       plot(  tau_x , M_of_tau_test_func_fit / NormY ,'g','LineWidth',line_fat )  
                                       plot(  tau_x , M_of_tau_test_poly_fit / NormY ,'r','LineWidth',line_fat  ) 
                                       plot(  tau_x , M_of_tau_test_smooth_fit1 / NormY,'b','LineWidth',line_fat ) 
                                       plot(  tau_x , M_of_tau_test_smooth_fit2 / NormY,'--b','LineWidth',line_fat ) 
                                       plot(  tau_x , M_of_tau_test_smooth_fit3 / NormY,'c' ,'LineWidth',line_fat ) 
                                       plot(  tau_x , M_of_tau_test_smooth_fit4 / NormY,'m','LineWidth',line_fat ) 
                                    else
                                       plot(  tau_x , M_of_tau / NormY ,'r','LineWidth',3 )   
                                    end
%                                     y2 = smooth(y,10);
%                                     plot( x , y2 , 'g','LineWidth',3  )
                                    hold off
%                                  else
% %                                     plot( fresult, x , y )  
%                                      hold on
%                                      plot(  tau_x , M_of_tau_original ,'--ow', 'MarkerFaceColor' ,'b' , 'MarkerEdgeColor' ,'b' ,'MarkerSize' , 1.5 , 'LineWidth', 0.1    )  
%                                     plot(  tau_x , M_of_tau , 'r' , 'LineWidth',3 )   
%                                     hold off
%                                  end
                                 xlabel( 'Connectivity delay, ms')
                                 ylabel( 'Spikes transferred per burst')

 
                                 title( ['Ch_i=' num2str(chi) ',Ch_j=' num2str(chj)   ', Delay=' ...
                                     num2str( tau_max) ' ms, SR_i=' ...
                                 num2str( SR_i ) ... 
                                  ',SR_j=' ...
                                 num2str(  SR_j )])  
                             if Test_different_smooth_filters
                                legend( 'Original data' , 'Fit function' , 'Polynomal fit' , ...
                                    [ test_smooth(1).str ' w=' num2str( test_smooth_window(1)) ] ,...  
                                        [ test_smooth(2).str ' w=' num2str( test_smooth_window(2)) ] ,... 
                                        [ test_smooth(3).str ' w=' num2str( test_smooth_window(3)) ] ,... 
                                        [ test_smooth(4).str ' w=' num2str( test_smooth_window(4)) ]  ) 
                             else
                                legend( 'Original data' , 'Fitted curve' ) 
                             end
                                
                               
                             if Pause_on_first_M_of_tau
                                 pause
                             end    
                             clf
                            end
                      end
   %---------------------------------------------------     
                   
% %                   figure
% %                   subplot( 2 , 1 , 1)
% %                     hist( fit_taumax_all )
% %                     xlabel( 'tau max')
% %                   subplot( 2 , 1 , 2)
% %                     hist( fit_max_all )
% %                     xlabel( 'M_max')
                      
                      % if M < 0 = bad fit, w - small = almost horizontal line
                      
%                       Strength =  M_max  / Total_Spike_Rates( chi ) ;
                      
                  end
                  
                      if ~Connection_OK
                          M_max = 0 ;
                          tau_max = 0 ;
                          M_of_tau( : ) =  0 ;
                      end

              else
%                   Connectiv_matrix_M_on_tau_Blocks( chi ,chj , : )= M_of_tau / / Total_Spike_Rates( chi );
                  M_max = max( M_of_tau );  
                  tau_max_index = find( M_of_tau == M_max ,1) ;            
                  tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
              end
          end
          
%>>>>>>>>>>
 
          

%>>>>>>>>>>
 

          Connectiv_matrix_M_on_tau( chi ,chj , : )= M_of_tau / Total_Spike_Rates_all_channels( chi );
           
          
%                 if abs( tau_max ) > 10
%                     figure
%                     %------ Plot one channel pair M on tau ---------------- 
%                     tau_all = 0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ;
%                     M_of_tau = reshape( M_of_tau , 1 , []);
%                     plot( tau_all , M_of_tau ) ;
%                     %-----------------------------------------
%                 end
          
          Connectiv_matrix_max_M( chi , chj ) = M_max  / Total_Spike_Rates_all_channels( chi ) ; 
          Connectiv_matrix_tau_of_max_M( chi , chj ) = tau_max ; 
          
%           % Take all connectivity values and delays and form vector
%             if Connectiv_matrix_max_M( chi , chj ) > 0
%                 Connectiv_matrix_max_M_vector_non_zeros =[Connectiv_matrix_max_M_vector_non_zeros   Connectiv_matrix_max_M( chi , chj ) ];
%                 Connectiv_matrix_tau_of_max_M_vector_non_zeros = [Connectiv_matrix_tau_of_max_M_vector_non_zeros ...
%                         Connectiv_matrix_tau_of_max_M( chi , chj ) ];
%             end 
%             Connectiv_matrix_max_M_vector  =[Connectiv_matrix_max_M_vector   Connectiv_matrix_max_M( chi , chj ) ];
%             Connectiv_matrix_tau_of_max_M_vector  = [Connectiv_matrix_tau_of_max_M_vector ...
%             Connectiv_matrix_tau_of_max_M( chi , chj ) ];            
%             
  
%>>>>>>>>>>
 
        end
    end %  for chj = 1 : N   
end

Correlation_matrix_SR_max_corr_delay_vector_non_zeros= [] ;
Correlation_matrix_SR_smooth_max_corr_delay_vector_non_zeros= [] ;
for chi = ch_i_start : ch_i_end 
   for chj = ch_j_start : ch_j_end    
        if chi ~= chj  
          % Take all connectivity values and delays and form vector
            if Connectiv_matrix_max_M( chi , chj ) > 0
                Connectiv_matrix_max_M_vector_non_zeros =[Connectiv_matrix_max_M_vector_non_zeros   Connectiv_matrix_max_M( chi , chj ) ];
                Connectiv_matrix_tau_of_max_M_vector_non_zeros = [Connectiv_matrix_tau_of_max_M_vector_non_zeros ...
                        Connectiv_matrix_tau_of_max_M( chi , chj ) ];
                    
                Correlation_matrix_SR_max_corr_delay_vector_non_zeros =[Correlation_matrix_SR_max_corr_delay_vector_non_zeros ...
                    Correlation_matrix_SR_max_corr_delay( chi , chj ) ];
                Correlation_matrix_SR_smooth_max_corr_delay_vector_non_zeros = [ Correlation_matrix_SR_smooth_max_corr_delay_vector_non_zeros ...
                     Correlation_matrix_SR_smooth_max_corr_delay( chi , chj ) ];
         end    
            Connectiv_matrix_max_M_vector  =[Connectiv_matrix_max_M_vector   Connectiv_matrix_max_M( chi , chj ) ];
            Connectiv_matrix_tau_of_max_M_vector  = [Connectiv_matrix_tau_of_max_M_vector ...
            Connectiv_matrix_tau_of_max_M( chi , chj ) ];   
        end
   end
end
%---------------------------------

var= []; 
 var.Total_Spike_Rates = Total_Spike_Rates ;
 var.Connectiv_matrix_max_M = Connectiv_matrix_max_M ;
 var.new_figure = true ;
 var.calc_bidirection = true ;
 var.background_1d_vector = false ;
 var.background_2d_data = Connectiv_matrix_max_M ;
%  Connectiv_data2 = Connectiv_Post_proc( Connectiv_matrix_tau_of_max_M , var) ;
 
 
%------------------ Connectivity characteristics Simple_calculation - find max M and store --------------- 
% Function_fit = Function_fit_Conns( N ,Connectiv_data , Connectiv_matrix_M_on_tau_not_fitted , Total_Spike_Rates , Spike_Rates ) ;


%--- calc number of conn using GLOBAL_const.Connects_min_tau_diff ------------
Number_of_Connections = 0 ;
Connection_delays = [] ;
            for M_i = 1 : length( Connectiv_matrix_max_M_vector )
%                 zeroo_conn_both_files = find( M_i == Zero_delay_Connections_2files_index_for_1st_file );
                
               % - difference of connections which non-zero and tau is
               % non-zero in both files  
               M1 = Connectiv_matrix_max_M_vector( M_i ) ;
               tau1= Connectiv_matrix_tau_of_max_M_vector( M_i ); 
               is_Connection_OK_1 = M1 > GLOBAL_const.Connects_min_M_strength ;
               is_Connection_OK_1_delay_non_zero = tau1 >= GLOBAL_const.Connects_min_tau_diff ;         
                    is_Connection_exists  = is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero  ;  
                    Number_of_Connections= Number_of_Connections  + is_Connection_exists  ; 
                    if is_Connection_exists
                        Connection_delays = [ Connection_delays tau1 ] ;
                    end
                        
            end
Number_of_Connections ;
%-------------------------------------------

%---- Number of adequate channels using Connectiv_data.params.Conn_Spikes_num_min
adq_chan_ind = find( Total_Spike_Rates > Connectiv_data.params.Conn_Spikes_num_min );
Number_adequate_channels = length( adq_chan_ind ) ;
%---------------------------------------------------------------
DateTime_created.Analysis_TimeAndDateAsVector = clock ;
DateTime_created.Analysis_DateAsString = date ;
Flags{ 1 }.version = GLOBAL_const.Connectiv_Analysis_ver ;
Flags{ 2 }.DateTime_created = DateTime_created ;
Flags{ 3 }.Search_Params = Search_Params ;


toc
 
Connectiv_data.Connectiv_matrix_M_on_tau_not_fitted = Connectiv_matrix_M_on_tau_not_fitted ;
Connectiv_data.Connectiv_matrix_M_on_tau = Connectiv_matrix_M_on_tau ;
Connectiv_data.Connectiv_matrix_max_M = Connectiv_matrix_max_M ;
Connectiv_data.Connectiv_matrix_max_M_vector = Connectiv_matrix_max_M_vector ;
Connectiv_data.Connectiv_matrix_max_M_vector_non_zeros = Connectiv_matrix_max_M_vector_non_zeros ;
Connectiv_data.Connectiv_matrix_tau_of_max_M = Connectiv_matrix_tau_of_max_M ;
Connectiv_data.Connectiv_matrix_tau_of_max_M_vector = Connectiv_matrix_tau_of_max_M_vector ;
Connectiv_data.Connectiv_matrix_tau_of_max_M_vector_non_zeros = Connectiv_matrix_tau_of_max_M_vector_non_zeros ;
Connectiv_data.Connectiv_matrix_M_on_tau = Connectiv_matrix_M_on_tau ;
Connectiv_data.Correlation_matrix_SR_max_corr_delay = Correlation_matrix_SR_max_corr_delay ;
Connectiv_data.Correlation_matrix_SR_smooth_max_corr_delay = Correlation_matrix_SR_smooth_max_corr_delay ;
Connectiv_data.Correlation_matrix_SR_max_corr_delay_vector_non_zeros= Correlation_matrix_SR_max_corr_delay_vector_non_zeros ;
Connectiv_data.Correlation_matrix_SR_smooth_max_corr_delay_vector_non_zeros = Correlation_matrix_SR_smooth_max_corr_delay_vector_non_zeros ;
% Connectiv_data.Spike_Rates = Spike_Rates ;
Connectiv_data.Total_Spike_Rates = Total_Spike_Rates ; % spike rate  criteria for connection analysis
% Connectiv_data.Total_Spike_Rates_all_channels = Total_Spike_Rates_all_channels ;  % total number of spikes per channel
% Connectiv_data.Spike_Rates_each_channel_mean = Spike_Rates_each_channel_mean ;
% Connectiv_data.Firing_Rates_each_channel_mean = Firing_Rates_each_channel_mean ;
Connectiv_data.Number_of_Connections = Number_of_Connections ;
Connectiv_data.Connection_delays = Connection_delays ; 
Connectiv_data.Connects_min_tau_diff = GLOBAL_const.Connects_min_tau_diff ;
Connectiv_data.Number_adequate_channels = Number_adequate_channels ;
Connectiv_data.Flags = Flags ;


% Connectiv_data.Function_fit = Function_fit ;


if Analyze_only_one_pair  
    x =  Connectiv_matrix_M_on_tau_not_fitted( One_pair_i ,One_pair_j , :);
    x = reshape( x , [] , 1 ) ;
    One_pair.M_on_tau_not_fitted = x ;
    x = Connectiv_matrix_M_on_tau( One_pair_i ,One_pair_j , :);
    x = reshape( x , [] , 1 ) ;
    One_pair.M_on_tau_One_pair =  x ;
    One_pair.max_M  = Connectiv_matrix_max_M( One_pair_i ,One_pair_j );
    One_pair.tau_of_max_M = Connectiv_matrix_tau_of_max_M( One_pair_i ,One_pair_j );
     
end

if Connectiv_data.params.show_figures
    
Connectiv_matrix_statistics_figures
drawnow
    
end  
    
    
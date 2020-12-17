
function [ burst_activation_2_mean , burst_activation_2 , burst_activation_3_smooth_1ms_mean , ...
     burst_max_rate_delay_ms , burst_max_rate_delay_ms_mean   ] = ... 
             SR_profile_Tact2_3_from_1msProfile( N , Nb , Calc_Spikerate_profile_1ms_bin ,  Burst_activation_based_smooth_find_all_bursts , ...
             Spike_Rate_Signature_max_duration_ms ,  DT_bin_1ms , Spike_Rate_Patterns_1ms , ...
             GLOBAL_const ,  T_activation_stat_threshold_param ,...
             Global_flags , Spike_Rate_Signature_1ms_smooth , burst_activation_mean , Spike_Rates_each_channel_mean  )  
% Search_Params.T_activation_stat_threshold_param 


Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature = Global_flags.figure_Tact_smooth_3types ;
% Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature = true ;

%         burst_activation_mean_based_on_STD = [];
%         if ~ Simple_analysis && Search_Params.Burst_activation_based_on_average_activity
        burst_activation_2_mean  = zeros( N,1);
        burst_activation_2 = zeros( Nb , N  ) ;
        burst_activation_3_smooth_1ms_mean = zeros( N,1);  
        burst_max_rate_delay_ms = zeros( Nb , N  ) ;
        burst_max_rate_delay_ms_mean = zeros( N,1);  
        

%             Spike_Rate_Signature = zeros( fire_bins  , N ); 
%             Spike_Rate_Signature_std = zeros( fire_bins  , N ); 
%             Spike_Rate_Patterns = zeros( fire_bins  , N , Nb );
Parralel_computing = true ;



if Parralel_computing 
    if matlabpool('size')== 0 
       num_cores = feature('numCores') ;
       if num_cores < 8
        matlabpool   
       else
%         matlabpool('local',num_cores - 1 )
        matlabpool('local', 3 )
%         matlabpool('local',num_cores - 7 )
       end
    end
%     matlabpool local 2
end
% figure
% for Thr = 2 : 0.5 : 8 ;
     
      %--------------------------------------       
      % find all burst_activation_2 patterns
       if   Calc_Spikerate_profile_1ms_bin 
           if  Burst_activation_based_smooth_find_all_bursts   
               tic
             parfor ch = 1 : N
                for Nb_i = 1 : Nb
                    bact = Spike_Rate_Patterns_1ms( :  , ch , Nb_i ); 
%                       bact = Spike_Rate_Signature( :  , ch ); 
%                     bact_max= max( bact );
                    
%                     bact_thres = std( bact ) * Search_Params.T_activation_stat_threshold_param ;
%                     bact_above_thres_i = find( bact >= bact_thres ,1);
                      first_spike_i = find( bact > 0 , 1);

%                       SummaryActivityVector = bact ;
%                       mf=3.5;
%                       Tsmooth = Global_flags.activation_patterns_smooth_window / DT_step ;
%                       wnd_super=normpdf([ -mf*Tsmooth : mf*Tsmooth ], 0 , Tsmooth ); 
%                       VectorS=conv(SummaryActivityVector,wnd_super);
%                       hsl=fix(length(wnd_super)/2);
%                       VectorS=VectorS(hsl:end-hsl - 1 ); 
%                       VectorS_mod = VectorS-VectorS(1) ;
                      VectorS_mod = smooth( bact , floor( GLOBAL_const.Spike_Rate_Signature_1ms_smooth / DT_bin_1ms ) , 'loess' );  
                      
                      VectorS_mod_thres = max( VectorS_mod ) * (  T_activation_stat_threshold_param  / 10 ) ;
                      bact_above_thres_i = find( VectorS_mod >= VectorS_mod_thres ,1);                      
                      if first_spike_i > bact_above_thres_i
                          bact_above_thres_i  = first_spike_i ;
                      end
                      
                      VectorS_mod = Spike_Rate_Signature_1ms_smooth(  Nb_i , ch   ) ; 
                      [ mm , mi ] = max( VectorS_mod ); 
                      burst_max_rate_delay_ms( Nb_i , ch  ) = mi * DT_bin_1ms ;
                      
%                       if max( SummaryActivityVector >1) && ch >6
%                          clf
%                         hold on
%                          bar( times_fire_bins ,SummaryActivityVector )
%                          plot( times_fire_bins , VectorS ,'r' )
%                          plot( [ bact_above_thres_i * DT_step  bact_above_thres_i * DT_step ] , [ 0 2 ] , 'm' )
%                          hold off
%                          legend( 'Number of spikes' , 'Smooth spike rate' , 'Activation time' )
%                          xlabel( 'time, ms')
%                          ylabel( 'Number of spikes per bin')
%                          title( ['Threshold = ' num2str( Search_Params.T_activation_stat_threshold_param * 10 ) ' % of maximum activity' ])
%                       end

                    
        %             bact_above_thres_i = find( bact > bact_thres0 ,1);
                    bact_t = 0 * DT_bin_1ms ;
                    if bact_above_thres_i > 0
                     bact_t = bact_above_thres_i * DT_bin_1ms   ;         
                    end            
                    burst_activation_2( Nb_i , ch  ) = bact_t ;
                end  
            end
            Burst_activation_based_smooth_find_all_bursts_PROC_TIME = toc
           end   
       
           %--------------------------------------
           % find burst_activation_2_mean  burst_max_rate_delay_ms_mean burst_activation_3_smooth_1ms_mean 
            parfor ch = 1 : N
                 
%                burst_activation_2_mean( ch ) = mean( burst_activation_2( : , ch ) ) ; 
%                 if floor( burst_activation_2_mean( ch ) / DT_step ) > 0
%                     Spike_Rate_Signature_mark_Tact_2( floor( burst_activation_2_mean( ch ) / DT_step ) , ch ) = 2 ;
%                 end 

%                 burst_activation_3_smooth_1ms_mean ;
                VectorS_mod = Spike_Rate_Signature_1ms_smooth(  : , ch   ) ;
                      VectorS_mod_thres = max( VectorS_mod ) * ... 
                        (  T_activation_stat_threshold_param  / 10 ) ;
                      VectorS_above_thres_i = find( VectorS_mod >= VectorS_mod_thres ,1);
                      bact_above_thres_i = VectorS_above_thres_i ;
%                       if first_spike_i > bact_above_thres_i
%                           bact_above_thres_i  = first_spike_i ;
%                       end
                      bact_t = 0 * DT_bin_1ms ;
                    if bact_above_thres_i > 0
                     bact_t = bact_above_thres_i * DT_bin_1ms   ;         
                    end     
                    burst_activation_3_smooth_1ms_mean( ch  ) = bact_t ;
                    
                    [maxrate , maxrate_time_ms ] = max( VectorS_mod );
                    burst_max_rate_delay_ms_mean( ch ) = maxrate_time_ms * DT_bin_1ms ;
                     

            if   Burst_activation_based_smooth_find_all_bursts     
                burst_activation_2_mean( ch  ) = mea_Mean_defined( burst_activation_2( : , ch ));  
            else
%                 burst_activation_2(ch) = [] ;
                burst_activation_2_mean( ch  ) = burst_activation_3_smooth_1ms_mean( ch  ) ; 
            end
%             Spike_Rate_Signature1burst_activation_2 = burst_activation_mean_based_on_STD ;

                
% end  
            
%             for ch = 1 : N
%                 for Nb_i = 1 : Nb
%                     bact = Spike_Rate_Signature( :  , ch ); 
%                     bact_max= max( bact );
%                     bact_thres = std( bact ) * Search_Params.T_activation_stat_threshold_param ;
%                     bact_above_thres_i = find( bact >= bact_thres ,1);
%         %             bact_above_thres_i = find( bact > bact_thres0 ,1);
%                     bact_t = 0;
%                     if bact_above_thres_i > 0
%                      bact_t = bact_above_thres_i * DT_step   ;
%                     end
%                     burst_activation_mean_based_on_STD( ch  ) = bact_t ;
%                 end 
%             end
            end
        %----------------------------------------------
               %--------------------------------------          
               
               
            if Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature
                Spike_Rate_Signature_mark_Tact_1 = Spike_Rate_Signature_1ms_smooth ;
                Spike_Rate_Signature_mark_Tact_2 = Spike_Rate_Signature_1ms_smooth ;
                Spike_Rate_Signature_mark_Tact_1ms_smooth = Spike_Rate_Signature_1ms_smooth ;
                MARK = 1.2 * max( max ( Spike_Rate_Signature_1ms_smooth ) )  ;
            end
            
          for ch = 1 : N  
              
              if Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature
                if floor( burst_activation_mean( ch )  ) > 0 
                    Spike_Rate_Signature_mark_Tact_1( floor( burst_activation_mean( ch ) / DT_bin_1ms   ) , ch ) =  MARK ;
                end
                
                if floor( burst_activation_3_smooth_1ms_mean( ch ) / DT_bin_1ms ) > 0
                    Spike_Rate_Signature_mark_Tact_1ms_smooth( floor( burst_activation_3_smooth_1ms_mean( ch ) / DT_bin_1ms ) , ch ) = ...
                        MARK ;
                end
                 
                if floor( burst_activation_2_mean( ch )   ) > 0
                        Spike_Rate_Signature_mark_Tact_2( floor( burst_activation_2_mean( ch ) / DT_bin_1ms  ) , ch ) = ...
                             MARK;
                end 
              end
              
               if Spike_Rates_each_channel_mean( ch )  < Global_flags.min_spikes_per_channel 
                    
                    if  Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature
                        Spike_Rate_Signature_mark_Tact_1( : , ch ) = 0 ; 
                        Spike_Rate_Signature_mark_Tact_2( : , ch ) = 0 ; 
                        Spike_Rate_Signature_mark_Tact_1ms_smooth( : , ch ) = 0 ; 
                    end
                     
                   burst_activation_2_mean( ch ) = 0 ;
                   burst_activation_2( : , ch ) = 0 ;
                     
                   Spike_Rate_Signature_1ms_smooth( : , ch ) = 0 ;   
                   burst_activation_3_smooth_1ms_mean( ch ) = 0 ;   
                   burst_max_rate_delay_ms( ch ) = 0 ;   
               end
          end
        
        if Test_figure_draw_Tact_3type_of_with_Tact_on_1msSignature
                figure
                  Nx = 3 ; Ny = 1 ;
                  f1 = subplot( Ny , Nx , 1 );
                  
                  fire_bins_1ms = 1 : floor( Global_flags.Stim_Search_Params.Spike_Rate_Signature_1ms_smooth / DT_bin_1ms );
                  
                    x=1:fire_bins_1ms; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature_mark_Tact_1';
                    bb= imagesc(  x *DT_bin_1ms  , y ,  Spike_Rate_Signature2    ); 
                    title( ['T_a_c_t (1), spikes/bin (' num2str(DT_bin_1ms) ' ms)'] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar
                    
                 f2 = subplot( Ny , Nx ,  2 );
                    x=1:fire_bins_1ms; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature_mark_Tact_2';
                    bb= imagesc(  x *DT_bin_1ms  , y ,  Spike_Rate_Signature2    ); 
                    title( ['T_a_c_t (2), spikes/bin (' num2str(DT_bin_1ms) ' ms)'] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar
                  
                 f3 = subplot( Ny , Nx ,  3 );
                    x=1:fire_bins_1ms ; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature_mark_Tact_1ms_smooth';
                    bb= imagesc(  x *DT_bin_1ms  , y ,  Spike_Rate_Signature2    ); 
                    title( ['T_a_c_t (3 smooth), spikes/bin (' num2str(DT_bin_1ms) ' ms)'] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar
                 
                    linkaxes( [ f1 f2 f3 ] , 'xy' )
        end
                
       else
%            burst_activation_2_mean= [] ;
%            burst_activation_2 =[] ;
%                      
           Spike_Rate_Signature_1ms_smooth=[] ; 
%            burst_activation_3_smooth_1ms_mean=[] ; 
       end
       

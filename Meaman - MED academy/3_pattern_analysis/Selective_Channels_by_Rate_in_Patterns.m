function   [ TOTAL_RATE ] ...
      = Selective_Channels_by_Rate_in_Patterns(  Patterns1 , Patterns2 , OVERLAP_TRESHOLD , ...
      STIM_RESPONSE_BOTH_INPUTS ,Show_Figures , Count_zero_values , flags )
  % takes two sets of patterns and compares difference of Spike_Rates
  % Low active channels should be erased before this . 
  % Result goes to TOTAL_RATE struct :
%  TOTAL_RATE.total_number_of_active_electrodes  
%  TOTAL_RATE.Stat_selective_electrodes_num  
%  TOTAL_RATE.Stat_Selective_electrodes_precent  
%  TOTAL_RATE.Selective_electrodes_lin_div_num  
%  TOTAL_RATE.Selective_electrodes_lin_div_precent  
%  TOTAL_RATE.Overlaps_lin_div 
%  TOTAL_RATE.Channels_overlap   
%  TOTAL_RATE.Channels_is_selective  
%  TOTAL_RATE.Channel_is_active  
  
Value_label = 'Spikerate' ;
x_label_values = 'Stimulus #' ;

show_patters_spike_rate_signatures = false ;
Show_Figures_sample_distribs = false ;
if isfield( flags, 'SHOW_FIGURES_sample' )
    show_patters_spike_rate_signatures = flags.SHOW_FIGURES_sample ;
end


  Show_spike_rates_good_channel = false ;
TOTAL_RATE =   flags.TOTAL_RATE ;
  
% STIM_RESPONSE_BOTH_INPUTS = 0 ;  
OVERLAP_NOT_RESPOND_TO_BOTH = 100 ;
Show_8x8_figures = false ;

N = length( Patterns1.Spike_Rates_each_channel_mean  );
Nb = Patterns1.Number_of_Patterns  ;
Nb2 = Patterns2.Number_of_Patterns  ;

Selective_electrodes_lin_div_num=0 ;
Selective_electrodes_lin_div_precent=0;
PVAL_Threshold = 0.05 ;
OVERLAP_TRES = OVERLAP_TRESHOLD ;
Stat_selective_electrodes_num = 0 ; 
total_number_of_active_electrodes = 0 ; 
Overlaps_lin_div=[];
Channels_overlap = zeros(  N ,1 );
Channels_is_selective= zeros(  N ,1 );
Channel_is_active = zeros(  N ,1 );
Channel_difference_mean = zeros(  N ,1 );
Channel_difference_mean_ratio = zeros(  N ,1 );
% N = 40 ;
ttt = 0; 
Erase_some_channels = []; Erase_some_channels_ext= []; 

Patterns1 = Patterns_Recalc_Channel_stats( Patterns1 );
Patterns2 = Patterns_Recalc_Channel_stats( Patterns2 );

active_channels_num = N ;
%-- Erase channels --------------------
if isfield( flags , 'Erase_some_channels' )
 Erase_some_channels_ext =   flags.Erase_some_channels ;
[ Patterns1  ] = Erase_Some_Channels_inPatterns( Patterns1 ,  flags.Erase_some_channels ) ;
[ Patterns2  ] = Erase_Some_Channels_inPatterns( Patterns2 ,  flags.Erase_some_channels ) ;
end

if isfield( flags , 'Min_spikes_per_channel_compare' )
  Erase_some_channels  = find( Patterns1.Spike_Rates_each_channel_mean <= flags.Min_spikes_per_channel_compare ) ;
 [ Patterns1  ] = Erase_Some_Channels_inPatterns( Patterns1 ,  Erase_some_channels ) ;   
  Erase_some_channels2  = find( Patterns2.Spike_Rates_each_channel_mean <= flags.Min_spikes_per_channel_compare ) ;
  Erase_some_channels = [ Erase_some_channels ; Erase_some_channels2 ] ;
 [ Patterns2  ] = Erase_Some_Channels_inPatterns( Patterns2 ,  Erase_some_channels ) ;  
 Erase_some_channels = Erase_some_channels' ; 
 Erase_some_channels = [ Erase_some_channels Erase_some_channels_ext ] ;
  erased_channels = unique( Erase_some_channels );
  active_channels_num = N - length( erased_channels ) ;
end 
%-------------------------------------- 


Spike_Rate_Signature_diff =  Patterns2.Spike_Rates_Signature - Patterns1.Spike_Rates_Signature  ;

Spike_Rate_Signature_1ms_smooth_diff = [] ;
if isfield( Patterns1 , 'Spike_Rate_Signature_1ms_smooth' ) && isfield( Patterns2 , 'Spike_Rate_Signature_1ms_smooth' )
    Spike_Rate_Signature_1ms_smooth_diff =  Patterns2.Spike_Rate_Signature_1ms_smooth - Patterns1.Spike_Rate_Signature_1ms_smooth  ;
end

Spike_Rate_1ms_smooth_Max_corr_delay_diff = [] ;
if isfield( Patterns1 , 'Spike_Rate_1ms_smooth_Max_corr_delay' ) && isfield( Patterns2 , 'Spike_Rate_1ms_smooth_Max_corr_delay' )
    Spike_Rate_1ms_smooth_Max_corr_delay_diff =  Patterns2.Spike_Rate_1ms_smooth_Max_corr_delay - Patterns1.Spike_Rate_1ms_smooth_Max_corr_delay  ;
end

Max_corr_delay_diff_vector = [] ;
Max_corr_delay_diff_vector_non_smooth= [] ;
if isfield( Patterns1 , 'Spike_Rate_1ms_Max_corr_delay' )&& isfield( Patterns2 , 'Spike_Rate_1ms_Max_corr_delay' )
    Spike_Rate_1ms_Max_corr_delay_diff =  Patterns2.Spike_Rate_1ms_Max_corr_delay - Patterns1.Spike_Rate_1ms_Max_corr_delay  ;
    Max_corr_delay_diff_vector = MNDB_2d_matrix_get_vector( Spike_Rate_1ms_smooth_Max_corr_delay_diff ) ;
    Max_corr_delay_diff_vector_non_smooth = MNDB_2d_matrix_get_vector( Spike_Rate_1ms_Max_corr_delay_diff ) ; 

end



% Plot8x8Data( Patterns2.burst_activation_3_smooth_1ms_mean , true );

Activation_mean_Interchan_diff_vector = MNDB_Compare_2sets_matrix_diff(  Patterns2.burst_activation_mean  , Patterns1.burst_activation_mean  ) ;

Activation_2_mean_Interchan_diff_vector = [] ;
Mean_distance_burst_activation_2_mean = [];
if isfield( Patterns1 , 'burst_activation_2_mean' )&& isfield( Patterns2 , 'burst_activation_2_meanburst_activation_2_mean' )
   Activation_2_mean_Interchan_diff_vector = MNDB_Compare_2sets_matrix_diff( Patterns2.burst_activation_2_mean  , Patterns1.burst_activation_2_mean ) ;
  
   Mean_distance_burst_activation_2_mean =  pdist(  [ Patterns1.burst_activation_2_mean'  ;  Patterns2.burst_activation_2_mean' ] )  ;
end
  TOTAL_RATE.Mean_distance_burst_activation_2_mean = Mean_distance_burst_activation_2_mean ;

  
  Mean_distance_burst_activation_3_smooth_1ms_mean = [];
  Activation_3_smooth_1ms_mean_Interchan_diff_vector = [] ;
if isfield( Patterns1 , 'burst_activation_3_smooth_1ms_mean' )&& isfield( Patterns2 , 'burst_activation_3_smooth_1ms_mean' )
    Activation_3_smooth_1ms_mean_Interchan_diff_vector = MNDB_Compare_2sets_matrix_diff( Patterns2.burst_activation_3_smooth_1ms_mean ...
    , Patterns1.burst_activation_3_smooth_1ms_mean ) ;
   Mean_distance_burst_activation_3_smooth_1ms_mean =  pdist(  [ Patterns1.burst_activation_3_smooth_1ms_mean'  ;  Patterns2.burst_activation_3_smooth_1ms_mean' ] )  ;
end
TOTAL_RATE.Mean_distance_burst_activation_3_smooth_1ms_mean =  Mean_distance_burst_activation_3_smooth_1ms_mean ;

burst_max_rate_delay_Interchan_diff_vector = []; 
if isfield( Patterns1 , 'burst_max_rate_delay_ms_mean' )&& isfield( Patterns2 , 'burst_max_rate_delay_ms_mean' )    
    burst_max_rate_delay_Interchan_diff_vector = MNDB_Compare_2sets_matrix_diff( Patterns2.burst_max_rate_delay_ms_mean  ...
        , Patterns1.burst_max_rate_delay_ms_mean ) ;
end
% Max_corr_delay_diff_vector = []; 
%  for chi = 1 : N 
%      for chj = 1 : N 
%         if chj > chi
% %           chi_erased = find( Erase_some_channels == chi );
% %           chi_erased = find( Erase_some_channels == chi );
%         Max_corr_delay_diff_vector = [ Max_corr_delay_diff_vector ; Spike_Rate_1ms_smooth_Max_corr_delay_diff( chi , chj ) ]; 
%         end
%      end
%  end
  
 
if show_patters_spike_rate_signatures
        Ny = 2;
    Nx= 3 ;
    figure
    subplot( Ny , Nx ,1)
    image_h =  plot_burst_signature(  Patterns1.Spike_Rates_Signature  ,  Patterns1.DT_bin )
    title( 'Profile #1')
    subplot( Ny , Nx ,2)
    image_h =  plot_burst_signature(  Patterns2.Spike_Rates_Signature  ,  Patterns1.DT_bin )
    title( 'Profile #2')
    subplot( Ny , Nx ,3)
    image_h =  plot_burst_signature(  Spike_Rate_Signature_diff  ,  Patterns1.DT_bin )
    title( 'Profile #2-#1')

        s=size( Spike_Rate_1ms_smooth_Max_corr_delay_diff ) ;
        x=1: s( 2) ; y = 1: s(1) ;
     if ~isempty( Spike_Rate_1ms_smooth_Max_corr_delay_diff )  
        subplot( Ny , Nx ,4)
        image_h = imagesc(  x    , y ,  Patterns1.Spike_Rate_1ms_smooth_Max_corr_delay  ); 
        colorbar
        title( 'Max rate delays #1')
        subplot( Ny , Nx ,5)
        image_h = imagesc(  x   , y ,  Patterns2.Spike_Rate_1ms_smooth_Max_corr_delay  ); 
        colorbar
        title( 'Max rate delays #2')
        subplot( Ny , Nx ,6)
        image_h = imagesc(  x   , y ,  Spike_Rate_1ms_smooth_Max_corr_delay_diff  ); 
        colorbar
        title( 'Max rate delays #2-#1')
     end
    
    Ny = 1;
    Nx=  1 ;
    figure
    subplot( Ny , Nx ,1)
        plot(  Patterns1.Spike_Rates_each_channel_mean , Patterns2.Spike_Rates_each_channel_mean , '*' )
        xlabel( 'TSR_1, spikes')
        xlabel( 'TSR_2, spikes')
        title( 'Total spike rates each channel (1 vs. 2')
end

%/////////// Compare patterns ------------- 
if numel( Patterns1.TimeBin_Total_Spikes_mean  ) ~= numel( Patterns2.TimeBin_Total_Spikes_mean  ) 
   a=0; 
end
  psth_diff_rms =  pdist(  [ Patterns1.TimeBin_Total_Spikes_mean  ;  Patterns2.TimeBin_Total_Spikes_mean ] )  ;
 TOTAL_RATE.psth_diff_rms = psth_diff_rms ;
  Mean_distance_burst_activation_mean =  pdist(  [ Patterns1.burst_activation_mean'   ;  Patterns2.burst_activation_mean'  ] )  ;
  TOTAL_RATE.Mean_distance_burst_activation_mean = Mean_distance_burst_activation_mean ;
  
 

  
  Mean_distance_Spike_Rates_each_channel_mean =  pdist(  [ Patterns1.Spike_Rates_each_channel_mean'  ;  Patterns2.Spike_Rates_each_channel_mean' ] )  ;
  TOTAL_RATE.Mean_distance_Spike_Rates_each_channel_mean = Mean_distance_Spike_Rates_each_channel_mean ;
  
%  TOTAL_RATE.psth_diff_sum =  sum( Patterns1.TimeBin_Total_Spikes_mean - Patterns2.TimeBin_Total_Spikes_mean )  ;
%  TOTAL_RATE.psth_diff_precent = 100* ((sum( Patterns2.TimeBin_Total_Spikes_mean ) - sum( Patterns1.TimeBin_Total_Spikes_mean ) ) ...
%      / sum( Patterns1.TimeBin_Total_Spikes_mean )) ; 
 psth_diff_precent = 100* (( ( mean(Patterns2.Spike_Rates_each_burst )  ) -  ( mean(Patterns1.Spike_Rates_each_burst )  ) ) / ...
     ( mean(Patterns1.Spike_Rates_each_burst )  )) ; 
 TOTAL_RATE.psth_diff_precent = psth_diff_precent ;
  
%////////////////////////////////////////////////////////


 for ch = 1 : N  
       
%  chan_rates1 = [] ;
%  chan_rates2 = [] ;  

       
%       for t = 1 : Nb       
%           chan_rates1 = [ chan_rates1 Patterns1.Spike_Rates( t , ch ) ] ;
% %           
%       end
%       for t = 1 : Nb2      
%           chan_rates2 = [ chan_rates2 Patterns2.Spike_Rates( t , ch ) ] ; 
%       end    

       
        chan_rates1  =  Patterns1.Spike_Rates( : , ch )' ;  
        chan_rates2  =  Patterns2.Spike_Rates( : , ch )'   ; 

      Channel_good_for_analysis = false ;
      
      
      chan_rates1_zero_values = find(chan_rates1==0);
      chan_rates1_zero_values = length( chan_rates1_zero_values );
      chan_rates2_zero_values= find(chan_rates2==0); 
      chan_rates2_zero_values = length( chan_rates2_zero_values );
      

      
      % if channel before AND after is active then use it
      if Count_zero_values == false
          NonZero_responses_fraction1 = (Patterns1.Number_of_Adequate_Patterns - chan_rates1_zero_values) / Patterns1.Number_of_Adequate_Patterns  ;
          NonZero_responses_fraction2 = (Patterns2.Number_of_Adequate_Patterns - chan_rates2_zero_values) / Patterns2.Number_of_Adequate_Patterns  ;
          
          chan_rates1_zero_NONvalues_fraction = (length( chan_rates1 ) - chan_rates1_zero_values)  / length( chan_rates1 ) ;
          chan_rates2_zero_NONvalues_fraction =(length( chan_rates2 ) - chan_rates2_zero_values) / length( chan_rates2 ) ;
          
          % Case 1 - check if non-zeros is rare from Adequate_Patterns (for
          % Low or High) 
          % Case 2 - check if non-zeros is rare from just spike rates 
          
          if chan_rates1_zero_NONvalues_fraction   >= STIM_RESPONSE_BOTH_INPUTS & ...
                        chan_rates2_zero_NONvalues_fraction   >= STIM_RESPONSE_BOTH_INPUTS & ...
                        Patterns1.Spike_Rates_each_channel_mean(ch)  > 0 && Patterns2.Spike_Rates_each_channel_mean(ch) > 0 & ...
                        Patterns1.Channels_active( ch ) == 1 & Patterns2.Channels_active( ch ) == 1
             Channel_good_for_analysis = true ;
          end
      else % if channel before OR after is not silent then use it
         if Patterns1.Spike_Rates_each_channel_mean(ch)  > 0
             Channel_good_for_analysis = true ;
         end
         if Patterns2.Spike_Rates_each_channel_mean(ch)  > 0
             Channel_good_for_analysis = true ;
         end
      end
%       Channel_good_for_analysis = true ;
      
      
   if Channel_good_for_analysis
    
    
%         if ch_r/Nb > MIN_RATE_PER_RESPONSE && ch_r2/Nb2 > MIN_RATE_PER_RESPONSE
      
    [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent...
    ,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , overlap_val_STABLE_Optim_Thres_precent , is_Stable_response ]= ...
          SelectiveValues( chan_rates1 , chan_rates2, PVAL_Threshold , OVERLAP_TRES , Count_zero_values ) ;
       
      Overlaps_lin_div = [Overlaps_lin_div overlap_values_Optim_Thres_precent ];     
      Selective_electrodes_lin_div_num = Selective_electrodes_lin_div_num + LinearyDifferent_if1 ;      
      total_number_of_active_electrodes = total_number_of_active_electrodes + 1 ;
      Stat_selective_electrodes_num = Stat_selective_electrodes_num + StatisitcallyDifferent_if1 ;
   
      Channel_is_active(ch) = 1 ;
      Channels_overlap(ch) = overlap_values_Optim_Thres_precent ;
      Channels_is_selective(ch) = StatisitcallyDifferent_if1 ;
      
%       OVERLAP_TRESHOLD = 45 ;
% StatisitcallyDifferent_if1
     if ( StatisitcallyDifferent_if1 &  ttt <4 ) | ( Show_spike_rates_good_channel  &  ttt < 3  )
%      if overlap_values_Optim_Thres_precent <= OVERLAP_TRESHOLD &  ttt <4
         ttt=ttt+1; 
%          && Zero_values_total_precent < 20
%          Patterns1.Channels_active( ch )
        if Show_Figures_sample_distribs
            
            if ~Count_zero_values 
               chan_rates1( chan_rates1==0)=[];
               chan_rates2( chan_rates2==0)=[];
            end
            
             xxx = max(max(chan_rates1),max(chan_rates2));
             xxx = 0: xxx/10 :xxx;
             chan_rates1' ;
             chan_rates2' ;
    %          xxx
               [n,x] = hist(chan_rates1 , xxx);
               n=100* n/ length( chan_rates1 );
                [n2,x2] = hist(chan_rates2 , xxx);
                n2=100* n2/ length( chan_rates2 );
                figure  
                subplot( 2,1,1);
                bar( [ x' x2' ],[ n' n2' ] )     
                xlabel( Value_label )
                ylabel( 'Probability' )
%                 plot(   x ,  n ,  x2,  n2   )       
                title( ['Selective channels ' Value_label ' , Overlap=' ...
                    num2str( overlap_val_STABLE_Optim_Thres_precent ) ])
                subplot( 2,1,2);
                 hold on
 
                  plot( chan_rates1 , '--' , 'MarkerSize'      , 6 ,'Marker'          , '.'  )
                  plot( chan_rates2, 'r','MarkerSize'      , 6 ,'Marker'          , '.'  )
                title( ['Channel ' int2str(ch)] )
                xlabel( x_label_values  );
                ylabel( Value_label );
                legend( 'Patterns #1' , 'Patterns #2' )
                hold off
%             pause
        end
     end
          
      else % if Channel_good_for_analysis
        Overlaps_lin_div = [Overlaps_lin_div OVERLAP_NOT_RESPOND_TO_BOTH  ]; 
        Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
        Channels_is_selective(ch) = 0 ;
        Channel_is_active(ch) = 0 ;
      end
      
 end %  for ch = 1 : N
 
%    Selective_electrodes_lin_div_num
  Selective_electrodes_lin_div_precent = 100 *( Selective_electrodes_lin_div_num / total_number_of_active_electrodes );
  Stat_Selective_electrodes_precent = 100 *( Stat_selective_electrodes_num / total_number_of_active_electrodes );
   
  
  
  
        %//////////////////////////////////// 
        %////////////////////////////////////  
        %//////////////////////////////////// 
        %//// Spike rate comparison for each channel ////////////////////  
        for ch=1:N
            
            %-- Difference of mean spike rate
            P1_mean = Patterns1.Spike_Rates_each_channel_mean(ch) ;
            P2_mean = Patterns2.Spike_Rates_each_channel_mean(ch) ;
            
            P1_mean = median( Patterns1.Spike_Rates( : , ch ));
            P2_mean = median( Patterns2.Spike_Rates( : , ch ));
            
            if Patterns1.Spike_Rates_each_channel_mean(ch) ~=  0
                Channel_difference_mean_ratio(ch) =100 *( (  P2_mean - P1_mean )   ...
                           /  P1_mean  ) ;
%                            / min( P1_mean , P2_mean ) ) ;
            else
                Channel_difference_mean_ratio(ch)  = 0 ;
            end
            
            
            %-- Difference of STD spike rate
            P1_std = Patterns1.Spike_Rates_each_channel_std(ch) ;
            P2_std = Patterns2.Spike_Rates_each_channel_std(ch) ;            
              
            if Patterns1.Spike_Rates_each_channel_std(ch) ~=  0
                Channel_difference_std_ratio(ch) = 100 *( (  P2_std - P1_std )   ...
                           /   P1_std   ) ;
%                        / min( P1_std , P2_std ) ) ;
            else
                Channel_difference_std_ratio(ch)  = 0 ;
            end
            
             Channel_difference_mean(ch) =( P2_mean - ...
                        P1_mean )  ;
                    
             Channel_difference_std(ch) =( Patterns2.Spike_Rates_each_channel_std(ch) - ...
                        Patterns1.Spike_Rates_each_channel_std(ch) )  ;                    
        end
        
        Channel_is_active_index = find(Channel_is_active==1);
        Channel_difference_mean_ratio_only_active =  Channel_difference_mean_ratio( Channel_is_active_index ) ; 
        Channel_difference_mean_only_active = Channel_difference_mean( Channel_is_active_index ) ;
        Channel_difference_std_ratio_only_active =  Channel_difference_std_ratio( Channel_is_active_index ) ; 
        Channel_difference_std_only_active =  Channel_difference_std( Channel_is_active_index ) ; 
        %//////////////////////////////////// 
        %////////////////////////////////////  
        %//////////////////////////////////// 
    Channels_overlap_only_active = Channels_overlap( Channel_is_active_index ) ;
    
    if Show_Figures_sample_distribs
    figure
        Plot8x8Data( Channel_difference_mean , false )  
        title( 'Channel_difference_mean' )
    end

%---- all channels comparison ---------------- 
 xxx =  0 : 5 : 100 ;
 [n_actual,xn] = hist(Overlaps_lin_div ,xxx); 
 n_percent=100* n_actual/ length( Overlaps_lin_div );
 
 
 
 
 
 TOTAL_RATE.total_number_of_active_electrodes =total_number_of_active_electrodes;
 TOTAL_RATE.Stat_selective_electrodes_num =Stat_selective_electrodes_num;
 TOTAL_RATE.Stat_Selective_electrodes_precent =Stat_Selective_electrodes_precent; 
 TOTAL_RATE.Selective_electrodes_lin_div_num =Selective_electrodes_lin_div_num;
 TOTAL_RATE.Selective_electrodes_lin_div_precent =Selective_electrodes_lin_div_precent; 
%  TOTAL_RATE.Overlaps_lin_div =Overlaps_lin_div;
 TOTAL_RATE.Channels_overlap =Channels_overlap; 
 TOTAL_RATE.Channels_overlap_only_active =Channels_overlap_only_active; 
 TOTAL_RATE.Channels_is_selective =Channels_is_selective; 
 TOTAL_RATE.Channel_is_active =Channel_is_active;
 
 
 
 TOTAL_RATE.Channel_difference_mean_ratio = Channel_difference_mean_ratio ;
 TOTAL_RATE.Channel_difference_mean_ratio_one_value = mean_or_median( Channel_difference_mean_ratio_only_active ) ;
 
 
 %--- find anly big differenies ---------------------
 
 minimum_difference = flags.Compare_channel_difference_spikes_min ;
 f= find( Channel_difference_mean_ratio_only_active > minimum_difference  );
 if length( f )>2
    %  difference_increase  = mean_or_median( Channel_difference_mean_ratio_only_active( ...
    %                 Channel_difference_mean_ratio_only_active >
    %                 minimum_difference )) ; 
    difference_increase  =  Channel_difference_mean_ratio_only_active(  Channel_difference_mean_ratio_only_active > minimum_difference )  ;
    difference_increase = 100 * length( difference_increase ) / active_channels_num ;  
 else
     difference_increase = 0 ; 
 end
 
  f= find( Channel_difference_mean_only_active > minimum_difference  );
 if length( f )>2 
    %  difference_increase_abs  = mean_or_median( Channel_difference_mean_only_active( ...
    %                 Channel_difference_mean_only_active >
    %                 minimum_difference )) ;   
    difference_increase_abs  =  Channel_difference_mean_only_active(Channel_difference_mean_only_active > minimum_difference );
    difference_increase_abs = 100 * length( difference_increase_abs ) / active_channels_num ; ; 
 else 
     difference_increase_abs = 0 ;
 end
  
 TOTAL_RATE.Channel_difference_increase_mean_ratio_one_value = difference_increase ;
  TOTAL_RATE.Channel_difference_increase_abs = difference_increase_abs ;
 
 f= find( Channel_difference_mean_ratio_only_active < -minimum_difference  );
 if length( f )>2
    %  difference_decrease  = mean_or_median( Channel_difference_mean_ratio_only_active( ...
    %                 Channel_difference_mean_ratio_only_active < minimum_difference )) ;     
    difference_decrease  =  Channel_difference_mean_ratio_only_active(  ... 
        Channel_difference_mean_ratio_only_active < -minimum_difference )  ;
    difference_decrease = 100 * length( difference_decrease )  / active_channels_num ;    
 else
     difference_decrease = 0 ; 
 end
 
  f= find( Channel_difference_mean_only_active < -minimum_difference  );
 if length( f )>2 
    %  difference_decrease_abs  = mean_or_median( Channel_difference_mean_only_active( ...
    %                 Channel_difference_mean_only_active <
    %                 minimum_difference )) ;  
    difference_decrease_abs  =  Channel_difference_mean_only_active(  ...
        Channel_difference_mean_only_active < -minimum_difference );
    difference_decrease_abs = 100 * length( difference_decrease_abs ) / active_channels_num ;     
 else 
     difference_decrease_abs = 0 ;
 end
  %--- find anly big differenies ---------------------

 
 
 
%  difference_decrease = Channel_difference_mean_ratio_only_active < 0 
 
 TOTAL_RATE.Channel_difference_decrease_mean_ratio_one_value = difference_decrease ;
 TOTAL_RATE.Channel_difference_decrease_abs = difference_decrease_abs ;
   
 TOTAL_RATE.Channel_difference_mean_ratio_only_active = Channel_difference_mean_ratio_only_active ;
 
 TOTAL_RATE.Channel_difference_mean = Channel_difference_mean ;
 TOTAL_RATE.Channel_difference_mean_one_value = mean_or_median( Channel_difference_mean_only_active ); 
 TOTAL_RATE.Channel_difference_mean_only_active = Channel_difference_mean_only_active ;
 
 TOTAL_RATE.Channel_difference_std_ratio = Channel_difference_std_ratio ;
 TOTAL_RATE.Channel_difference_std_ratio_only_active = Channel_difference_std_ratio_only_active ; 
 TOTAL_RATE.Channel_difference_std  = Channel_difference_std  ;
 TOTAL_RATE.Channel_difference_std_only_active = Channel_difference_std_only_active ; 
 
%  TOTAL_RATE.Spike_Rate_Signature_diff = Spike_Rate_Signature_diff ;
%  TOTAL_RATE.Spike_Rate_Signature_1ms_smooth_diff = Spike_Rate_Signature_1ms_smooth_diff ;
%  TOTAL_RATE.Spike_Rate_1ms_smooth_Max_corr_delay_diff = Spike_Rate_1ms_smooth_Max_corr_delay_diff ;
 TOTAL_RATE.DT_bin = Patterns1.DT_bin ;
  TOTAL_RATE.Max_corr_delay_diff_vector = Max_corr_delay_diff_vector   ; %Max_corr_delay_diff_vector ;
  TOTAL_RATE.Activation_mean_Interchan_diff_vector = Activation_mean_Interchan_diff_vector ;
  TOTAL_RATE.Activation_2_mean_Interchan_diff_vector = Activation_2_mean_Interchan_diff_vector ;
  TOTAL_RATE.Activation_3_smooth_1ms_mean_Interchan_diff_vector = Activation_3_smooth_1ms_mean_Interchan_diff_vector ;
  TOTAL_RATE.burst_max_rate_delay_Interchan_diff_vector = burst_max_rate_delay_Interchan_diff_vector ;
 
   %//// Use then only active channels characteristics 
%   TOTAL_RATE.Channel_difference_mean_ratio = Channel_difference_mean_ratio_only_active ; 
%   TOTAL_RATE.Channel_difference_mean = Channel_difference_mean_ratio_only_active ;  
%   TOTAL_RATE.Channels_overlap  =  TOTAL_RATE.Channels_overlap_only_active ;
  %///////////////////
 
 
 %///////////////////////////////////////////////////////
 %/////////////// Figures ////////////////////////////////////////
if Show_Figures 
    
     
  if  Patterns1.Flags(1) == 1   
       PlotY  = 5 ;
  else
       PlotY = 4 ; 
  end    
    
figure
    subplot(PlotY,2,1:2);
%  bar( [ Patterns1.Spike_Rates_each_channel_mean  Patterns2.Spike_Rates_each_channel_mean  ] )  
    x= (1:N ) ; 
    y= [ Patterns1.Spike_Rates_each_channel_mean Patterns2.Spike_Rates_each_channel_mean  ] ;
    e= [ Patterns1.Spike_Rates_each_channel_std   Patterns2.Spike_Rates_each_channel_std  ] ;
%     whos x
%     whos y
%     whos e
    ycolor= ['b','r'];
    ecolor= ['k','k'];
    % labels= {'1','2','3','4'};
    % barerror(x,y,e,1,ycolor,ecolor);
    %  barwitherr(cat(3,zeros(4,2),[Patterns1.Spike_Rates_each_channel_std' Patterns2.Spike_Rates_each_channel_std'])...
    %      , x ,[Patterns1.Spike_Rates_each_channel_mean' Patterns2.Spike_Rates_each_channel_meann'])
     barwitherr( e , x ,y ) 
     ylabel( 'Spikes')
     if  max( [ Patterns1.Spike_Rates_each_channel_mean' Patterns2.Spike_Rates_each_channel_mean'  ] ) > 0
      axis( [ min(x)-1 max(x)+1 0 1.2 * max( [ Patterns1.Spike_Rates_each_channel_mean' Patterns2.Spike_Rates_each_channel_mean'  ] ) ...
                         + max([ Patterns1.Spike_Rates_each_channel_std'   Patterns2.Spike_Rates_each_channel_std'  ]) ] )
     end
    title( [ 'Total Spike rate, 2 pattern sets (' flags.Selectivity_figure_title ')' ] ) 

    subplot(PlotY,2,3:4);
         hold on
         
         bar( Channels_is_selective*100  ,'r' )
         
        bar( Channels_overlap , 0.5 )
        ylabel( 'Overlap') 

        hold off
        axis( [ min(x)-1 max(x)+1 0 1.1 * max( Channels_overlap ) ] ) 
         title( 'Overlap, similar rates %' )
         legend( 'Stat different spikerates', 'Overlap',4 )
         
         
    subplot(PlotY,2,5:6);            
%         bar( Channel_difference_mean , 0.5 )
        bar( Channel_difference_mean_ratio , 0.5 )  
            ylabel( 'Ratio, %')
            title( 'Mean difference normalized') 
            if max( Channel_difference_mean_ratio ) - min( Channel_difference_mean_ratio ) > 0
                axis( [ min(x)-1 max(x)+1 1.1*min(Channel_difference_mean_ratio) 1.1 * max( Channel_difference_mean_ratio ) ] ) 
            end            
%             if max( Channel_difference_mean ) - min( Channel_difference_mean ) > 0
%                 axis( [ min(x)-1 max(x)+1 1.1*min(Channel_difference_mean) 1.1 * max( Channel_difference_mean ) ] ) 
%             end
     
     subplot(PlotY,2,7);
        bar(   xn   ,  n_actual     )
        ylabel( 'Channels')
         title( 'Total Spike rate Overlaps, %' )
         axis( [ min(xn)-0.1*(max(xn)) max(xn)+ 0.1*(max(xn)) 0 1.2 * max( n_actual ) ] )

    subplot(PlotY,2,8);
        bar(   xn   ,  n_percent     )
         ylabel( 'Count, %')
         title( 'Total Spike rate Overlaps, %' )
         axis( [ min(xn)- 0.1*(max(xn)) max(xn)+ 0.1*(max(xn)) 0 1.2 * max( n_percent ) ] )
         
         
  if  Patterns1.Flags(1) == 1         
     subplot(PlotY,2,9:10);
     
     Channels_zero_res_increase = [] ;
     if isfield( Patterns2 , 'Spike_Rates_each_channel_zero_values_num' )
        
         for ch=1:N
             Pzero2 = ...
             ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns2.NUMBER_OF_STIMULS_original ) ;         
             Pzero1 = ...
             ((Patterns1.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns1.NUMBER_OF_STIMULS_original ) ;

    %          if Pzero1 > 0
    %             Channels_zero_res_increase( ch ) = 100 * ( Pzero2 /  Pzero1 );
    %          else
    %             Channels_zero_res_increase( ch ) = 0 ; 
    %          end
             Channels_zero_res_increase( ch ) = 100 * ( Pzero2 -  Pzero1 );  
         end
     else
        Channels_zero_res_increase = zeros( N,1);
     end
        bar(  Channels_zero_res_increase  , 0.5 )
         ylabel( 'Difference, %')
         xlabel( 'Channel number')
         
         title( 'Zero responses increase, %' )
         if ( max(Channels_zero_res_increase) - min( Channels_zero_res_increase ) > 0 )
           axis( [ min(x)-1 max(x)+1    1.1*min(Channels_zero_res_increase) 1.1 * max( Channels_zero_res_increase ) ] )   
         end
  end   
         
%-----------------------------------------------   


%---- 8x8 figures os selectivity ----------------     
if Show_8x8_figures
figure
    subplot(1,2,1);
    Plot8x8Data( Overlaps_lin_div , false )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Overlaps spike rates' )
     
    subplot(1,2,2); 
    Plot8x8Data( Channels_is_selective , false )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Stat. different rates' )
%      colormap gray
 
     
     Overlaps_lin_div( Overlaps_lin_div >100 ) = [];
end
%-----------------------------------------------     
%-----------------------------------------------
%-----------------------------------------------
% Total statistics

figure


%                                    flags.Selectivity_figure_title = 'Normal Responses' ;
                                    Patterns1_to_draw = Patterns1 ;
                                    Patterns2_to_draw = Patterns2  ;
                                    flags.PlotY = 3 ;
                                    flags.PlotX = 4 ;
                                    flags.Draw_in_parent_figure = true ;
                                    flags.Draw_3_patterns = false ; 


  if  Patterns1.Flags(1) == 1   
       PlotY  = 4 ;
  else
       PlotY = 3 ; 
  end 
  PlotX = 4 ;
  PlotX_dx = 2 ;
  
  
   draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf
  
  
   diff1 =  subplot(PlotY, PlotX , PlotX_dx + 1); 
         NNN = 10 ;
        Channel_difference_mean_only_good =  Channel_difference_mean( find( abs(Channel_difference_mean ) > 0 ) );

        [n,xout] = hist( Channel_difference_mean_only_good  , NNN ) ;
        n2 = n / length( Channel_difference_mean_only_good  )* 100 ;    
             bar(xout , n2 )
            title( 'SRate diff, Ctr1-Ctrl2' )
            xlabel( 'Spikes')   
           ylabel( 'Count, %') 
       
       
           
if  Patterns1.Flags(1) == 1  
        subplot(PlotY, PlotX , PlotX_dx + PlotX  + 1 ); 
                 NNN = 10 ;
                Channels_zero_res_increase  = [] ;
                if isfield( Patterns1 , 'Spike_Rates_each_channel_zero_values_num' )
                     for ch=1:N
                         Pzero2 = ...
                         ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns2.NUMBER_OF_STIMULS_original ) ;         
                         Pzero1 = ...
                         ((Patterns1.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns1.NUMBER_OF_STIMULS_original ) ;

                         Channels_zero_res_increase( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
                     end
                     Channels_zero_res_increase_good = Channels_zero_res_increase( find( abs(Channels_zero_res_increase ) > 0 ) );

                    [n,xout] = hist( Channels_zero_res_increase_good  , NNN ) ;
                    n2 = n / length( Channels_zero_res_increase_good  )* 100 ;    
                
                        bar(xout , n2 )
                        
                        end
                        title( 'Zero resp increase, Ctr1-Ctrl2' )
                        xlabel( 'Diff, %')   
                       ylabel( 'Count, %') 
                
           
end



      
             [p,StatisitcallyDifferent_if1] = ranksum(Patterns1.Spike_Rates_each_burst , Patterns2.Spike_Rates_each_burst , PVAL_Threshold  );   
            if StatisitcallyDifferent_if1 == 1
               Stat_Selective_SpikeRates = '*' ; 
            else
               Stat_Selective_SpikeRates = '' ; 
            end     

        subplot(PlotY, PlotX , PlotX_dx + PlotX*2  +1 ); 
            XxX = 1:2 ;
            barwitherr( [std(Patterns1.Spike_Rates_each_burst) std(Patterns2.Spike_Rates_each_burst) ]...
                , XxX , ...
                [mean(Patterns1.Spike_Rates_each_burst) mean(Patterns2.Spike_Rates_each_burst) ] );  
                     title(  'Stat diff Spike rates'   )
                    xlabel( [ ' Ctr1-Effect (' Stat_Selective_SpikeRates ')' ])
                    ylabel( 'Spike rate')
            
          
subplot(PlotY, PlotX , PlotX_dx + PlotX*2  +2 ); 
  bar(  Stat_Selective_electrodes_precent   )
             title(  'Stat selective electrodes'   )
            xlabel( 'Ctrl-Effect')
            ylabel( 'Elcedtrodes, %')










end    
     
     
          
          
function   [ TOTAL_RATE  ] ...
      = Selective_Channels_by_Rate_in_3_Patterns(  Patterns1 , Patterns2 , Patterns3 , OVERLAP_TRESHOLD , ...
      STIM_RESPONSE_BOTH_INPUTS ,Show_Figures , Count_zero_values, flags  )
  % takes two sets of patterns and compares difference of Spike_Rates
  % Low active channels should be erased before this . 

% STIM_RESPONSE_BOTH_INPUTS = 0 ; 

MAX_FIGURES_data_compare_examples = 5 ;
Show_8x8_figures = true;

OVERLAP_NOT_RESPOND_TO_BOTH = 100 ;

TOTAL_RATE = flags.TOTAL_RATE  ;

N = length( Patterns1.Spike_Rates_each_channel_mean  );
Nb = Patterns1.Number_of_Patterns  ;
Nb2 = Patterns2.Number_of_Patterns  ;
Nb3 = Patterns3.Number_of_Patterns  ;
 
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
Channel_nonZero_difference_mean_ratio= zeros(  N ,1 );


    Selective_electrodes_lin_div_num2=0 ;
    Selective_electrodes_lin_div_precent2=0;  
    Stat_selective_electrodes_num2 = 0 ; 
    total_number_of_active_electrodes2 = 0 ; 
    Overlaps_lin_div2 =[];
    Channels_overlap2 = zeros(  N ,1 );
    Channels_is_selective2 = zeros(  N ,1 );
    Channel_is_active2 = zeros(  N ,1 );
    Channel_difference_mean2 = zeros(  N ,1 );
    Channel_difference_mean2_ratio = zeros(  N ,1 );
    Channel_nonZero_difference_mean_ratio2 = zeros(  N ,1 );
    
    Channel_nonZero_vals_percent = zeros(  N ,1 );
    Patterns1.Channel_nonZero_vals_percent = Channel_nonZero_vals_percent;
    Patterns2.Channel_nonZero_vals_percent = Channel_nonZero_vals_percent;
    Patterns3.Channel_nonZero_vals_percent = Channel_nonZero_vals_percent;
    
    
    
    Spike_Rate_Signature_diff =  Patterns2.Spike_Rates_Signature - Patterns1.Spike_Rates_Signature  ;
    Spike_Rate_Signature_diff2 =  Patterns3.Spike_Rates_Signature - Patterns2.Spike_Rates_Signature  ;

Spike_Rate_Signature_1ms_smooth_diff = [] ;
if isfield( Patterns1 , 'Spike_Rate_Signature_1ms_smooth' ) && isfield( Patterns2 , 'Spike_Rate_Signature_1ms_smooth' )
    Spike_Rate_Signature_1ms_smooth_diff =  Patterns2.Spike_Rate_Signature_1ms_smooth - Patterns1.Spike_Rate_Signature_1ms_smooth  ;
end

Spike_Rate_1ms_smooth_Max_corr_delay_diff = [] ;
if isfield( Patterns1 , 'Spike_Rate_1ms_smooth_Max_corr_delay' ) && isfield( Patterns2 , 'Spike_Rate_1ms_smooth_Max_corr_delay' )
    Spike_Rate_1ms_smooth_Max_corr_delay_diff =  Patterns2.Spike_Rate_1ms_smooth_Max_corr_delay - Patterns1.Spike_Rate_1ms_smooth_Max_corr_delay  ;
end

%--- 3 patterns show stats --------------
%     Ny = 1;
%     Nx= 3 ;
%     figure
% 
%  subplot( Ny , Nx ,1)
%         Plot8x8Data( Patterns1.burst_activation_mean , false)
%         title( 'Activation #1')
%     subplot( Ny , Nx ,2)
%     	 Plot8x8Data( Patterns2.burst_activation_mean  , false)
%         title( 'Activation #2')
%     subplot( Ny , Nx ,3)
%          Plot8x8Data( Patterns3.burst_activation_mean  , false)
%         title( 'Activation #3')

    Ny = 3;
    Nx= 3 ;
    figure
    subplot( Ny , Nx ,1)
        Plot8x8Data( Patterns1.Spike_Rates_each_channel_mean , false)
        title( 'SR Profile #1')
    subplot( Ny , Nx ,2)
    	 Plot8x8Data( Patterns2.Spike_Rates_each_channel_mean  , false)
        title( 'SR Profile #2')
    subplot( Ny , Nx ,3)
         Plot8x8Data( Patterns3.Spike_Rates_each_channel_mean  , false)
        title( 'SR Profile #3')
    
    subplot( Ny , Nx ,4)
    image_h =  plot_burst_signature(  Patterns1.Spike_Rates_Signature  ,  Patterns1.DT_bin )
    title( 'Profile #1')
    subplot( Ny , Nx ,5)
    image_h =  plot_burst_signature(  Patterns2.Spike_Rates_Signature  ,  Patterns1.DT_bin )
    title( 'Profile #2')
    subplot( Ny , Nx ,6)
        image_h =  plot_burst_signature(  Patterns3.Spike_Rates_Signature  ,  Patterns1.DT_bin )
        title( 'Profile #3')
    subplot( Ny , Nx ,7)    
        image_h =  plot_burst_signature(  Spike_Rate_Signature_diff  ,  Patterns1.DT_bin )
        title( 'Profile #2-#1')
     subplot( Ny , Nx ,8)    
        image_h =  plot_burst_signature(  Spike_Rate_Signature_diff2  ,  Patterns1.DT_bin )
        title( 'Profile #3-#2')
     
     if isfield( flags.electrode_sel_param , 'Selected_Stimulation_channel' )
        Stim_chan_marker = zeros( 1,N);
        Stim_chan_marker(  flags.electrode_sel_param.Selected_Stimulation_channel ) = 1 ;
        subplot( Ny , Nx ,9)
         Plot8x8Data( Stim_chan_marker  , false)
        title( 'Stimulation channel')
        
     end
     
     
 %------------------------------------    
            [p,StatisitcallyDifferent_if1] = ranksum(Patterns1.Spike_Rates_each_burst , Patterns2.Spike_Rates_each_burst , PVAL_Threshold  );   
            if StatisitcallyDifferent_if1 == 1
               Stat_Selective_SpikeRates = '*' ; 
            else
               Stat_Selective_SpikeRates = '' ; 
            end  

            [p,StatisitcallyDifferent_if1] = ranksum(Patterns2.Spike_Rates_each_burst , Patterns3.Spike_Rates_each_burst , PVAL_Threshold  );   
            if StatisitcallyDifferent_if1 == 1
               Stat_Selective_SpikeRates2 = '*' ; 
            else
               Stat_Selective_SpikeRates2 = '' ; 
            end          
    
% N = 40 ;
ttt = 0; 

 for ch = 1 : N  
       
%  chan_rates1 = [] ;
%  chan_rates2 = [] ;
%  chan_rates3 = [] ; 
%        
%       ch_r=0;
%       ch_r2 = 0;
%       for t = 1 : Nb      
%           chan_rates1 = [ chan_rates1 Patterns1.Spike_Rates( t , ch ) ] ; 
%       end
%       for t = 1 : Nb2       
%           chan_rates2 = [ chan_rates2 Patterns2.Spike_Rates( t , ch ) ] ;
%       end    
%       for t = 1 : Nb3       
%           chan_rates3 = [ chan_rates3 Patterns3.Spike_Rates( t , ch ) ] ;
%       end        
       
      
        chan_rates1  =  Patterns1.Spike_Rates( : , ch )' ;  
        chan_rates2  =  Patterns2.Spike_Rates( : , ch )'   ; 
        chan_rates3  =  Patterns3.Spike_Rates( : , ch )'   ; 
      
      chan_rates1_zero_values = find(chan_rates1==0);
      chan_rates1_zero_values = length( chan_rates1_zero_values );
      
      chan_rates2_zero_values= find(chan_rates2==0); 
      chan_rates2_zero_values = length( chan_rates2_zero_values );
      
      chan_rates3_zero_values= find(chan_rates3==0); 
      chan_rates3_zero_values = length( chan_rates3_zero_values );
      
      chan_rates1_zero_NONvalues_fraction = (length( chan_rates1 ) - chan_rates1_zero_values)  / length( chan_rates1 ) ;
      chan_rates2_zero_NONvalues_fraction =(length( chan_rates2 ) - chan_rates2_zero_values) / length( chan_rates2 ) ;
      chan_rates3_zero_NONvalues_fraction =(length( chan_rates3 ) - chan_rates3_zero_values) / length( chan_rates3 ) ;    
      
      Patterns1.Channel_nonZero_vals_percent( ch ) = 100*chan_rates1_zero_NONvalues_fraction ;
      Patterns2.Channel_nonZero_vals_percent( ch ) = 100*chan_rates2_zero_NONvalues_fraction ;
      Patterns3.Channel_nonZero_vals_percent( ch ) = 100*chan_rates3_zero_NONvalues_fraction ;
      
      Channel_good_for_analysis = false ;
      % if channel before AND after is active then use it
      if Count_zero_values == false
          if chan_rates1_zero_NONvalues_fraction   >= STIM_RESPONSE_BOTH_INPUTS & ...
                        chan_rates2_zero_NONvalues_fraction   >= STIM_RESPONSE_BOTH_INPUTS & ...
                        chan_rates3_zero_NONvalues_fraction >= STIM_RESPONSE_BOTH_INPUTS & ...
                        Patterns1.Spike_Rates_each_channel_mean(ch)  > 0  & Patterns2.Spike_Rates_each_channel_mean(ch) > 0 & ...
                        Patterns3.Spike_Rates_each_channel_mean(ch)  > 0  & ...
                        Patterns1.Channels_active( ch ) == 1 & Patterns2.Channels_active( ch ) == 1 ...
                        & Patterns3.Channels_active( ch ) == 1
             Channel_good_for_analysis = true ;
          end
      else % if channel before OR after is not silent then use it
         if Patterns1.Spike_Rates_each_channel_mean(ch)  > 0
             Channel_good_for_analysis = true ;
         end
         if Patterns2.Spike_Rates_each_channel_mean(ch)  > 0
             Channel_good_for_analysis = true ;
         end         
         if Patterns3.Spike_Rates_each_channel_mean(ch)  > 0
             Channel_good_for_analysis = true ;
         end         
      end
      
      
      
   if Channel_good_for_analysis
    
    
%         if ch_r/Nb > MIN_RATE_PER_RESPONSE && ch_r2/Nb2 > MIN_RATE_PER_RESPONSE
%         if Count_zero_values      
%             Count_zero_values = false ;
%         else
%             Count_zero_values = true ;
%         end

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
      
      %-- Compare 2nd and 3rd patterns
          [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent...
            ,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , overlap_val_STABLE_Optim_Thres_precent , is_Stable_response ]= ...
                  SelectiveValues( chan_rates2 , chan_rates3, PVAL_Threshold , OVERLAP_TRES , Count_zero_values ) ;

              Overlaps_lin_div2 = [Overlaps_lin_div2 overlap_values_Optim_Thres_precent ];     
              Selective_electrodes_lin_div_num2 = Selective_electrodes_lin_div_num2 + LinearyDifferent_if1 ;      
              total_number_of_active_electrodes2 = total_number_of_active_electrodes2 + 1 ;
              Stat_selective_electrodes_num2 = Stat_selective_electrodes_num2 + StatisitcallyDifferent_if1 ;

              Channel_is_active2(ch) = 1 ;
              Channels_overlap2(ch) = overlap_values_Optim_Thres_precent ;
              Channels_is_selective2(ch) = StatisitcallyDifferent_if1 ;
      
      %----------------------------
      
      
%       OVERLAP_TRESHOLD = 45 ;
     if overlap_values_Optim_Thres_precent <= OVERLAP_TRESHOLD &&  ttt < MAX_FIGURES_data_compare_examples && ...
         length( chan_rates1 )>2 && length(chan_rates2)>2 && max( [max(chan_rates2) max(chan_rates1) ] ) >0 
         ttt=ttt+1; 
%          && Zero_values_total_precent < 20
%          Patterns1.Channels_active( ch )
        if Show_Figures
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
%                 plot(   x ,  n ,  x2,  n2   )       
                title( ['Selective electrodes totalRate, overlap=' ...
                    num2str( overlap_val_STABLE_Optim_Thres_precent ) ])
                subplot( 2,1,2);
                 hold on

    %             bar( chan_rates1 , 'BarWidth',0.6)
    %             bar( chan_rates2, 'r','BarWidth',0.3)
                 plot( chan_rates1 , '--' , 'MarkerSize'      , 6 ,'Marker'          , '.'  )
                plot( chan_rates2, 'r','MarkerSize'      , 6 ,'Marker'          , '.'  )
                title( ['Channel ' int2str(ch)] )
                xlabel( 'Stimulus #');
                ylabel( 'Spike rate, spikes/response');
                hold off
%             pause
        end
     end
          
      else % if Channel_good_for_analysis
        Overlaps_lin_div = [Overlaps_lin_div OVERLAP_NOT_RESPOND_TO_BOTH  ]; 
        Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
        Channels_is_selective(ch) = 0 ;
        Channel_is_active(ch) = 0 ;
        
        Overlaps_lin_div2 = [Overlaps_lin_div2 OVERLAP_NOT_RESPOND_TO_BOTH  ]; 
        Channels_overlap2(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
        Channels_is_selective2(ch) = 0 ;
        Channel_is_active2(ch) = 0 ;        
      end
      
 end %  for ch = 1 : N
 
%    Selective_electrodes_lin_div_num
  Selective_electrodes_lin_div_precent = 100 *( Selective_electrodes_lin_div_num / total_number_of_active_electrodes );
  Stat_Selective_electrodes_precent = 100 *( Stat_selective_electrodes_num / total_number_of_active_electrodes );
  
  Selective_electrodes_lin_div_precent2 = 100 *( Selective_electrodes_lin_div_num2 / total_number_of_active_electrodes2 );
  Stat_Selective_electrodes_precent2 = 100 *( Stat_selective_electrodes_num2 / total_number_of_active_electrodes2 );
   
  
  
  
  
              %////////////////////////////////////  
              %//// Spike rate comparison for each channel ////////////////////  
            % Channel_difference_mean = Channels_is_selective ;
            for ch=1:N

            %         Patterns1.Spike_Rates_each_channel_mean( ch )  = median(Patterns1.Spike_Rates(  : , ch ));
            %         Patterns2.Spike_Rates_each_channel_mean( ch )  = median(Patterns2.Spike_Rates(  : , ch ));
            
                P1_mean = Patterns1.Spike_Rates_each_channel_mean(ch) ;
                P2_mean = Patterns2.Spike_Rates_each_channel_mean(ch) ;

                if P1_mean ~=  0
%                     Channel_difference_mean_ratio(ch) =100 *( (  P2_mean - P1_mean )   ...
%                                / min( P1_mean , P2_mean ) ) ;
                    Channel_difference_mean_ratio(ch)=100 *( (  P2_mean - P1_mean )   ...
                               /  P1_mean  ) ;
                else
                    Channel_difference_mean_ratio(ch)  = 0 ;
                end
             
                 Channel_difference_mean(ch) =( Patterns2.Spike_Rates_each_channel_mean(ch) - ...
                            Patterns1.Spike_Rates_each_channel_mean(ch) )  ;
                        
              %-- Difference of STD spike rate
                P1_std = Patterns1.Spike_Rates_each_channel_std(ch) ;
                P2_std = Patterns2.Spike_Rates_each_channel_std(ch) ;       
                if P1_std ~=  0
%                     Channel_difference_std_ratio(ch) = 100 *( (  P2_std - P1_std )   ...
%                                / min( P1_std , P2_std ) ) ;
                    Channel_difference_std_ratio(ch) = 100 *( (  P2_std - P1_std )   ...
                               /  P1_std   ) ;
                else
                    Channel_difference_std_ratio(ch)  = 0 ;
                end
                    Channel_difference_std(ch) =( Patterns2.Spike_Rates_each_channel_std(ch) - ...
                            Patterns1.Spike_Rates_each_channel_std(ch) )  ;
                        
                 %---- zeor values comp
                P1_mean = Patterns1.Channel_nonZero_vals_percent(ch) ;
                P2_mean = Patterns2.Channel_nonZero_vals_percent(ch) ; 
                if P1_mean ~=  0
%                     Channel_nonZero_difference_mean_ratio(ch) =100 *( (  P2_mean - P1_mean )   ...
%                                / min( P1_mean , P2_mean ) ) ;
                        Channel_nonZero_difference_mean_ratio(ch) =100 *( (  P2_mean - P1_mean )   ...
                               / P1_mean   ) ;
                else
                    Channel_nonZero_difference_mean_ratio(ch)  = 0 ;
                end        
                        
            end
            Channel_is_active_index = find(Channel_is_active==1);
            Channel_difference_mean_ratio_only_active =  Channel_difference_mean_ratio( Channel_is_active_index ) ;
            Channel_difference_mean_only_active =  Channel_difference_mean(  Channel_is_active_index ) ;
            Channel_difference_std_ratio_only_active =  Channel_difference_std_ratio( Channel_is_active_index ) ; 
            Channel_difference_std_only_active =  Channel_difference_std( Channel_is_active_index ) ; 
            
            
            
            
            
            
            % Channel_difference_mean2 = Channels_is_selective2 ;
            for ch=1:N
            %     Patterns1.Spike_Rates_each_channel_mean( ch )  = median(Patterns1.Spike_Rates(  : , ch ));
                P2_mean = Patterns2.Spike_Rates_each_channel_mean(ch) ;
                P3_mean = Patterns3.Spike_Rates_each_channel_mean(ch) ;

                if P2_mean ~=  0
%                     Channel_difference_mean2_ratio(ch) =100 *( (  P3_mean - P2_mean )   ...
%                                / min( P2_mean , P3_mean ) ) ;
                      Channel_difference_mean2_ratio(ch) =100 *( (  P3_mean - P2_mean )   ...
                               /   P2_mean   ) ;
                else
                    Channel_difference_mean2_ratio(ch)  = 0 ;
                end
                Channel_difference_mean2(ch) = ( Patterns3.Spike_Rates_each_channel_mean(ch) - ...
                            Patterns2.Spike_Rates_each_channel_mean(ch) )  ;
                        
                        
               %-- Difference of STD spike rate
                P2_std = Patterns2.Spike_Rates_each_channel_std(ch) ;
                P3_std = Patterns3.Spike_Rates_each_channel_std(ch) ;       
                if P2_std ~=  0
%                     Channel_difference_std2_ratio(ch) = 100 *( (  P3_std - P2_std )   ...
%                                / min( P2_std , P3_std ) ) ;
                    Channel_difference_std2_ratio(ch) = 100 *( (  P3_std - P2_std )   ...
                               /   P2_std   ) ;
                else
                    Channel_difference_std2_ratio(ch)  = 0 ;
                end
                    Channel_difference_std2(ch) =( Patterns3.Spike_Rates_each_channel_std(ch) - ...
                            Patterns2.Spike_Rates_each_channel_std(ch) )  ;        
                        
                        
             %---- zeor values comp
                P2_mean = Patterns2.Channel_nonZero_vals_percent(ch) ;
                P3_mean = Patterns3.Channel_nonZero_vals_percent(ch) ; 
                if P2_mean ~=  0
%                     Channel_nonZero_difference_mean_ratio2(ch) =100 *( (  P3_mean - P2_mean )   ...
%                                / min( P2_mean , P3_mean ) ) ;
                      Channel_nonZero_difference_mean_ratio2(ch) =100 *( (  P3_mean - P2_mean )   ...
                               /  P2_mean  ) ;
                else
                    Channel_nonZero_difference_mean_ratio2(ch)  = 0 ;
                end     
                
            end
            Channel_is_active_index2 = find(Channel_is_active2==1);
            Channel_difference_mean2_ratio_only_active  = Channel_difference_mean2_ratio( Channel_is_active_index2 )  ;
            Channel_difference_mean2_only_active  =  Channel_difference_mean2( Channel_is_active_index2 )  ;
            Channel_difference_std2_ratio_only_active =  Channel_difference_std2_ratio( Channel_is_active_index2 ) ; 
            Channel_difference_std2_only_active =  Channel_difference_std2( Channel_is_active_index2 ) ; 
            
            %//////////////////////////////////// 
            %////////////////////////////////////  
            %////////////////////////////////////  
    Channels_overlap_only_active = Channels_overlap( Channel_is_active_index ) ;
    Channels_overlap2_only_active = Channels_overlap2( Channel_is_active_index2 ) ;

%---- all channels comparison ---------------- 
 xxx =  0 : 5 : 100 ;
 [n_actual,xn] = hist(Overlaps_lin_div ,xxx); 
 n_percent=100* n_actual/ length( Overlaps_lin_div );
 
  xxx =  0 : 5 : 100 ;
 [n_actual2,xn2] = hist(Overlaps_lin_div2 ,xxx); 
 n_percent2=100* n_actual/ length( Overlaps_lin_div2 );
 
 
  TOTAL_RATE.total_number_of_active_electrodes =total_number_of_active_electrodes ;
  TOTAL_RATE.Stat_selective_electrodes_num = Stat_selective_electrodes_num ;
  TOTAL_RATE.Stat_Selective_electrodes_precent = Stat_Selective_electrodes_precent ;
  TOTAL_RATE.Selective_electrodes_lin_div_num= Selective_electrodes_lin_div_num ;
  TOTAL_RATE.Selective_electrodes_lin_div_precent= Selective_electrodes_lin_div_precent ;
%   TOTAL_RATE.Overlaps_lin_div= Overlaps_lin_div ;
  TOTAL_RATE.Channels_overlap= Channels_overlap ;
  TOTAL_RATE.Channels_overlap_only_active =Channels_overlap_only_active; 
  TOTAL_RATE.Channels_is_selective = Channels_is_selective ;
  TOTAL_RATE.Channel_is_active = Channel_is_active;
  TOTAL_RATE.Channel_difference_mean_ratio = Channel_difference_mean_ratio ;
  TOTAL_RATE.Channel_difference_mean_ratio_only_active = Channel_difference_mean_ratio_only_active ;
  TOTAL_RATE.Channel_difference_mean = Channel_difference_mean ;
  TOTAL_RATE.Channel_difference_mean_only_active = Channel_difference_mean_only_active ;
  
 TOTAL_RATE.Channel_difference_std_ratio = Channel_difference_std_ratio ;
 TOTAL_RATE.Channel_difference_std_ratio_only_active = Channel_difference_std_ratio_only_active ; 
 TOTAL_RATE.Channel_difference_std  = Channel_difference_std  ;
 TOTAL_RATE.Channel_difference_std_only_active = Channel_difference_std_only_active ; 
 TOTAL_RATE.Channel_nonZero_difference_mean_ratio  = Channel_nonZero_difference_mean_ratio  ;
  %//// Use then only active channels characteristics 
%   TOTAL_RATE.Channel_difference_mean_ratio = Channel_difference_mean_ratio_only_active ; 
%   TOTAL_RATE.Channel_difference_mean = Channel_difference_mean_ratio_only_active ;  
%   TOTAL_RATE.Channels_overlap  =  TOTAL_RATE.Channels_overlap_only_active ; 
%   TOTAL_RATE.Channel_difference_std_ratio = Channel_difference_std_ratio_only_active ; 
%   TOTAL_RATE.Channel_difference_std = Channel_difference_std_only_active ;   
  %///////////////////
  
  
 
  TOTAL_RATE.total_number_of_active_electrodes2 =total_number_of_active_electrodes ;
  TOTAL_RATE.Stat_selective_electrodes_num2 = Stat_selective_electrodes_num ;
  TOTAL_RATE.Stat_Selective_electrodes_precent2 = Stat_Selective_electrodes_precent ;
  TOTAL_RATE.Selective_electrodes_lin_div_num2= Selective_electrodes_lin_div_num ;
  TOTAL_RATE.Selective_electrodes_lin_div_precent2= Selective_electrodes_lin_div_precent ;
%   TOTAL_RATE.Overlaps_lin_div2= Overlaps_lin_div ;
  TOTAL_RATE.Channels_overlap2= Channels_overlap ;
  TOTAL_RATE.Channels_overlap2_only_active =Channels_overlap2_only_active; 
  TOTAL_RATE.Channels_is_selective2 = Channels_is_selective ;
  TOTAL_RATE.Channel_is_active2 = Channel_is_active;
  TOTAL_RATE.Channel_difference_mean2_ratio = Channel_difference_mean2_ratio ;
  TOTAL_RATE.Channel_difference_mean2_ratio_only_active = Channel_difference_mean2_ratio_only_active ;
  TOTAL_RATE.Channel_difference_mean2 = Channel_difference_mean2 ;
  TOTAL_RATE.Channel_difference_mean2_only_active = Channel_difference_mean2_only_active ;
 
 TOTAL_RATE.Channel_difference_std2_ratio = Channel_difference_std2_ratio ;
 TOTAL_RATE.Channel_difference_std2_ratio_only_active = Channel_difference_std2_ratio_only_active ; 
 TOTAL_RATE.Channel_difference_std2  = Channel_difference_std2  ;
 TOTAL_RATE.Channel_difference_std2_only_active = Channel_difference_std2_only_active ; 
 TOTAL_RATE.Channel_nonZero_difference_mean_ratio2  = Channel_nonZero_difference_mean_ratio2  ;
   %//// Use then only active channels characteristics 
%   TOTAL_RATE.Channel_difference_mean2_ratio = Channel_difference_mean2_ratio_only_active ; 
%   TOTAL_RATE.Channel_difference_mean2 = Channel_difference_mean2_only_active ;  
%   TOTAL_RATE.Channel_difference_std2_ratio = Channel_difference_std2_ratio_only_active ; 
%   TOTAL_RATE.Channel_difference_std2 = Channel_difference_std2_only_active ;     
%   TOTAL_RATE.Channels_overlap2  =   Channels_overlap2_only_active ;
  %///////////////////
 
 
 
 
 
 
 
 
 
 
 
%---- FIGURES ------------------------------------------------------ 
%---- FIGURES ------------------------------------------------------ 
if Show_Figures 
    GLOBAL_CONSTANTS_load
  %--------------------------------------      
  %---- Show Sspikerates for 3 patterns in color and plot
  %--------------------------------------      
  if  Patterns1.Flags(1) == 1   
       PlotY  = 5 ;
  else
       PlotY = 4 ; 
  end
  
  
      figure
      
      subplot(2,1,1)
            hold on 
               plot( 1:length( Patterns1.artefacts ) , Patterns1.Spike_Rates_each_burst , '-*' ) 
               dt = length( Patterns1.artefacts );
               plot( dt + 1: dt + length( Patterns2.artefacts ) , Patterns2.Spike_Rates_each_burst , 'r-*' );
               dt = dt + length( Patterns2.artefacts );
               plot( dt + 1: dt + length( Patterns3.artefacts ) , Patterns3.Spike_Rates_each_burst , 'g-*' );
               legend( 'Patterns 1', 'Patterns 2', 'Patterns 3')
                title( 'Spikes in responses' )
                xlabel( 'Stimulus number')   
               ylabel( 'Spikes #')   
            hold off
          
     subplot(2,1,2)
      x = 1:length( Patterns1.artefacts )+length( Patterns2.artefacts )... 
              +  length( Patterns3.artefacts ) ;
      y = 1:Patterns1.N_channels ; 
      SR = [ Patterns1.Spike_Rates' Patterns2.Spike_Rates' Patterns3.Spike_Rates'  ];
        bb = imagesc(  x , y ,  SR    ) ;
%         set( bb ,'alphadata',~isnan(mmm))
        title( 'Post-stimulus spikes #' )
        xlabel('Stimulus nummber')
        ylabel('Electrode #')
    colorbar
    
    
    %--------------------------------------    
    %--------------------------------------    
    %--------------------------------------    
    
    
figure
x= (1:N ) ; 
    
    %----- Ctrl1 - Ctrl2 - Selective + Overlap channels -------------
    subplot(PlotY,2,1:2);
         hold on 
         bar( Channels_is_selective*100  ,'r' ) 
        bar( Channels_overlap , 0.5 )
        ylabel( 'Overlap')  
        hold off
        axis( [ min(x)-1 max(x)+1 0 1.1 * max( Channels_overlap ) ] ) 
%          title( 'Overlap, similar rates %' )
         legend( 'Stat different spikerates', 'Overlap',4 ,'Box', 'off')
         title( [ 'Compare 3 pattern sets (' flags.Selectivity_figure_title ')' ] ) 
    %----- Ctrl1 - Ctrl2 - Channel mean SR difference % -------------     
    
    srdiff1 = subplot(PlotY,2,3:4);            
        hold on
        bar( Channel_difference_mean   )
         bar( Channel_difference_mean2 , 0.5 , 'r' )
        hold off
            ylabel( 'spikes')
            title( 'Spike Rate difference') 
            legend( 'Patterns 1-2' ,  'Patterns 2-3','Box', 'off')          
            if max( Channel_difference_mean ) - min( Channel_difference_mean ) > 0
                axis( [ min(x)-1 max(x)+1 1.1*min( [ min( Channel_difference_mean) min( Channel_difference_mean2) ]) 1.1 * max( ...
                        [ max(Channel_difference_mean) max(Channel_difference_mean2) ] ) ] ) 
            end
     
% 
%     subplot(PlotY,2,8);
%         bar(   xn   ,  n_percent     )
%          ylabel( 'Count, %')
%          title( 'Total Spike rate Overlaps, %' )
%          axis( [ min(xn)- 0.1*(max(xn)) max(xn)+ 0.1*(max(xn)) 0 1.2 * max( n_percent ) ] )
%          
         
  if  Patterns1.Flags(1) == 1        
      
         %----- Ctrl1 - Ctrl2 - Zero responses increase % ------------- 
         subplot(PlotY,2, 5:6 );

%          Channels_zero_res_increase = [] ;
%           Channels_zero_res_increase2 = [] ;
%          for ch=1:N
%              Pzero2 = ...
%              ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns2.NUMBER_OF_STIMULS_original ) ;         
%              Pzero1 = ...
%              ((Patterns1.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns1.NUMBER_OF_STIMULS_original ) ;
% 
%              Channels_zero_res_increase( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%              
%              Pzero2 = ...
%              ((Patterns3.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns3.NUMBER_OF_STIMULS_original ) ;         
%              Pzero1 = ...
%              ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns2.NUMBER_OF_STIMULS_original ) ;
% 
%              Channels_zero_res_increase2( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%          end
         hold on
%             bar(  Channels_zero_res_increase    )
%             bar(  Channels_zero_res_increase2  , 0.5 , 'r'   ) 
            bar(  Channel_nonZero_difference_mean_ratio    )
            bar(  Channel_nonZero_difference_mean_ratio2  , 0.5 , 'r'   ) 
             
            
            hold off
             ylabel( 'Difference, %')
    %          xlabel( 'Channel number')
                legend( 'Patterns 1-2' ,  'Patterns 2-3','Box', 'off')       
             title( 'Non-Zero responses increase, %' )
             xlim( [  min(x)-1 max(x)+1 ] );
%              if ( max(Channels_zero_res_increase) - min( Channels_zero_res_increase ) > 0 )
%                axis( [ min(x)-1 max(x)+1    1.1*min([ Channels_zero_res_increase Channels_zero_res_increase2 ]) 1.1 * ...
%                    max( [ Channels_zero_res_increase Channels_zero_res_increase2 ] ) ] )   
%              end
  end   
  
  %----- Ctrl1 - Effect - Selective + Overlap channels -------------
      subplot(PlotY,2, 7 :8 );
         hold on 
         bar( Channels_is_selective2*100  ,'r' ) 
        bar( Channels_overlap2 , 0.5 )
        ylabel( 'Overlap')  
        hold off
        axis( [ min(x)-1 max(x)+1 0 1.1 * max( Channels_overlap2 ) ] ) 
         title( 'Overlap, Patterns 2-3' )
         legend( 'Stat different spikerates', 'Overlap',4 )
         
    %----- Ctrl1 - Effect - Channel mean SR difference %  -------------     
   srdiff2 =  subplot(PlotY,2, 9: 10);            
        bar( Channel_difference_mean2 , 0.5 )
            ylabel( 'Spikes')
            title( 'Spike Rate difference') 
            if max( Channel_difference_mean2 ) - min( Channel_difference_mean2 ) > 0
                axis( [ min(x)-1 max(x)+1 1.1*min(Channel_difference_mean2 ) 1.1 * max( Channel_difference_mean2 ) ] ) 
            end
            
            linkaxes( [srdiff1 srdiff2] ,'xy');  
            
            
            
            
%       if  Patterns1.Flags(1) == 1        
%          %----- Ctrl1 - Effect - Zero responses increase % -------------
%          %----- Ctrl1 - Effect - Zero responses increase % ------------- 
%          subplot(PlotY,2, 11:12 );
% 
%          Channels_zero_res_increase2 = [] ;
%          for ch=1:N
%              Pzero2 = ...
%              ((Patterns3.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns3.NUMBER_OF_STIMULS_original ) ;         
%              Pzero1 = ...
%              ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns2.NUMBER_OF_STIMULS_original ) ;
% 
%              Channels_zero_res_increase2( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%          end
%             bar(  Channels_zero_res_increase2  , 0.5 )
%              ylabel( 'Difference, %')
% %              xlabel( 'Channel number')
% 
%              title( 'Zero responses increase, %' )
%              if ( max(Channels_zero_res_increase2 ) - min( Channels_zero_res_increase2 ) > 0 )
%                axis( [ min(x)-1 max(x)+1    1.1*min(Channels_zero_res_increase2 ) 1.1 * max( Channels_zero_res_increase2 ) ] )   
%              end
%       end         
            
  
    %----- Ctrl1 - Ctrl2 - Overlaps  -------------
       subplot(PlotY,2,9);
        bar( xn , n_actual )
        ylabel( 'Channels')
        xlabel( 'Overlap' )
         title( 'Ctrl1-Ctrl2' )
         axis( [ min(xn)-0.1*(max(xn)) max(xn)+ 0.1*(max(xn)) 0 1.2 * max( n_actual ) ] )
     %----- Ctrl1 - Effect - Overlaps  -------------    
       subplot(PlotY,2,10);
        bar(   xn2   ,  n_actual2     )
        ylabel( 'Channels')
        xlabel( 'Overlap' )        
         title( 'Ctrl2-Effect' )
         axis( [ min(xn2)-0.1*(max(xn2)) max(xn2)+ 0.1*(max(xn2)) 0 1.2 * max( n_actual2 ) ] )  
         
%-----------------------------------------------   

%-----------------------------------------------
%-----------------------------------------------
%---- 8x8 figures of selectivity ----------------     

if Show_8x8_figures
    figure
    subplot(2,2,1);
    Plot8x8Data( Overlaps_lin_div , false )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Overlaps spike rates' )
     
    subplot(2,2,2); 
    Plot8x8Data( Channels_is_selective , false )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Stat. different rates' )
%      colormap gray
 
        %---- Ctrl2 - Effect
            subplot(2,2,3);
            Plot8x8Data( Overlaps_lin_div2 , false )
            xlabel('Electrode #')
            ylabel('Electrode #')
                  title( 'Overlaps spike rates (Ctrl2-Effect)' )

            subplot(2,2,4); 
            Plot8x8Data( Channels_is_selective2 , false )
            xlabel('Electrode #')
            ylabel('Electrode #')
                  title( 'Stat. different rates (Ctrl2-Effect)' )

     
     Overlaps_lin_div( Overlaps_lin_div >100 ) = [];
end
%-----------------------------------------------     
    
 

%----------------------------------------------- 
%----------------------------------------------- 
% Total statistics

f=figure ;
figure_title = [ flags.Selectivity_figure_title ' , Channel=' num2str( flags.electrode_sel_param.stim_chan_to_extract ) ];

 set(f, 'name', figure_title  ,'numbertitle','off' )

%                                    flags.Selectivity_figure_title = 'Normal Responses' ;
                                    Patterns1_to_draw = Patterns1 ;
                                    Patterns2_to_draw = Patterns2  ;
                                    Patterns3_to_draw = Patterns3  ;
                                    flags.PlotY = 4 ;
                                    flags.PlotX = 4 ;
                                    flags.Draw_in_parent_figure = true ;
                                    flags.Draw_3_patterns = true ; 


  if  Patterns1.Flags(1) == 1   
       PlotY  = 4 ;
  else
       PlotY = 3 ; 
  end 
  PlotX = 4 ;
  PlotX_dx = 2 ;
  
  
                                    draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf
  
  subplot(PlotY, PlotX , PlotX_dx + 1); 
                 Channel_difference_mean_only_good =  Channel_difference_mean( find( abs(Channel_difference_mean ) > 0 )  )                  
                 Channel_difference_mean_only_good2 =  Channel_difference_mean2( find( abs(Channel_difference_mean2 ) > 0 ) );
                 Min_diff= min( [ min( Channel_difference_mean_only_good ) min( Channel_difference_mean_only_good2 ) ] );
                 MMax_diff= max( [ max( Channel_difference_mean_only_good ) max( Channel_difference_mean_only_good2 ) ] );                 
                 HStep = ( MMax_diff -  Min_diff )/ 10 ;
                 
            	 xxx =  Min_diff  : HStep: MMax_diff ;
                [n,xout] = histc( Channel_difference_mean_only_good  ,xxx) ;
                n2 = n / length( Channel_difference_mean_only_good  )* 100 ;
                                    
                [n3,xout3] = histc( Channel_difference_mean_only_good2  ,xxx) ;
                n4 = n3 / length( Channel_difference_mean_only_good2  )* 100 ;           
                
                
                hold on
                    
                    bar( xxx , n4 ,'r' ) 
                    bar( xxx , n2 , 0.4 )
                hold off
               legend( 'Ctrl-Effect' , 'Ctrl1-2' )
                    title( 'SRate diff, Ctr1-Ctrl2' )
                    xlabel( 'Spikes')   
                   ylabel( 'Count, %') 
                   
  
                   % spike difference only for highly active electrodes
  subplot(PlotY, PlotX , PlotX_dx + 2); 
  
                 SR_thresh_high = mean(Patterns1.Spike_Rates_each_channel_mean ) ;
                 [ x , ind ] = find( Patterns1.Spike_Rates_each_channel_mean > SR_thresh_high );
                 Channel_difference_mean( ind ) = 0 ;
                 Channel_difference_mean2( ind ) = 0 ;
                 
%                  Channel_difference_mean_only_good =  Channel_difference_mean( find( abs(Channel_difference_mean ) > 0 )  )                  
%                  Channel_difference_mean_only_good2 =  Channel_difference_mean2( find( abs(Channel_difference_mean2 ) > 0 ) );
                 Channel_difference_mean_only_good =  Channel_difference_mean ;                  
                 Channel_difference_mean_only_good2 =   Channel_difference_mean2 ;
                 
                 BINS_NUM = 10 ;
                 Data1 = Channel_difference_mean_only_good ;
                 Data2 = Channel_difference_mean_only_good2 ;
                 
                 
                     
                %  Input - BINS_NUM , Data1  , Data2 
                %  figure should be created before 
                SHOW_2_data_sets_hist
                
                legend( 'Ctrl-Effect' , 'Ctrl1-2' )
                    title( 'SRate diff, Ctr1-Ctrl2, High active el-s' )
                    xlabel( 'Spikes')   
                   ylabel( 'Count, %') 
                   
                   
                
%      subplot(PlotY, PlotX , PlotX_dx + 2 );            
%             Channel_difference_mean_only_good =  Channel_difference_mean( find( abs(Channel_difference_mean ) > 0 ) );
%             Channel_difference_mean_only_good_mean = mean(Channel_difference_mean_only_good);
%             Channel_difference_mean_only_good_std = std( Channel_difference_mean_only_good ) ;
%             Channel_difference_mean_only_good2 =  Channel_difference_mean2( find( abs(Channel_difference_mean2 ) > 0 ) );
%             Channel_difference_mean_only_good2_mean = mean(Channel_difference_mean_only_good2);
%             Channel_difference_mean_only_good2_std = std( Channel_difference_mean_only_good ) ;
%             if length( Channel_difference_mean_only_good )>1 && length( Channel_difference_mean_only_good2 )>1
%             [p,StatisitcallyDifferent_if1] = ranksum(Channel_difference_mean_only_good , Channel_difference_mean_only_good2 , PVAL_Threshold  );   
%                 if StatisitcallyDifferent_if1 == 1
%                    StatDiff = '*' ; 
%                 else
%                    StatDiff = '' ; 
%                 end
%             else
%                StatDiff = '' ;  
%             end
% 
% 
%            
%                 XxX = 1:2 ;
%                 barwitherr( [Channel_difference_mean_only_good_std Channel_difference_mean_only_good2_std], XxX , ...
%                     [Channel_difference_mean_only_good_mean Channel_difference_mean_only_good2_mean] ); 
%                          title( [ 'Mean SR difference (' StatDiff ')'] )
%                         xlabel( ' Ctr1-Ctr2, Ctr2-Effect')
%                         ylabel( 'Spikes')         
                   
                   
                                    
% % %            diff1 =  subplot(PlotY, PlotX , PlotX_dx + 1); 
% % %                  NNN = 10 ;
% % %                 Channel_difference_mean_only_good =  Channel_difference_mean( find( abs(Channel_difference_mean ) > 0 ) );
% % % 
% % %                 [n,xout] = hist( Channel_difference_mean_only_good  , NNN ) ;
% % %                 n2 = n / length( Channel_difference_mean_only_good  )* 100 ;    
% % %                      bar(xout , n2 )
% % %                     title( 'SRate diff, Ctr1-Ctrl2' )
% % %                     xlabel( 'Spikes')   
% % %                    ylabel( 'Count, %') 
% % % 
% % % 
% % %            diff2 = subplot(PlotY,PlotX , PlotX_dx + 2); 
% % %                  NNN = 10 ;
% % %                 Channel_difference_mean_only_good2 =  Channel_difference_mean2( find( abs(Channel_difference_mean2 ) > 0 ) );
% % % 
% % %                 [n,xout] = hist( Channel_difference_mean_only_good2  , NNN ) ;
% % %                 n2 = n / length( Channel_difference_mean_only_good2  )* 100 ;    
% % %                     bar(xout , n2 )
% % %                     title( 'SRate diff, Ctr2-Effect' )
% % %                     xlabel( 'Spikes')   
% % %                    ylabel( 'Count, %') 
 
           
%     linkaxes( [diff1 diff2] ,'xy');       
  

%--- Zero pesponses increase
if  Patterns1.Flags(1) == 1  
    
    
    subplot(PlotY, PlotX , PlotX_dx + PlotX  + 1 ); 
%                   Channels_zero_res_increase2 = [] ;
%                  for ch=1:N
%                      Pzero2 = ...
%                      ((Patterns3.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns3.NUMBER_OF_STIMULS_original ) ;         
%                      Pzero1 = ...
%                      ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns2.NUMBER_OF_STIMULS_original ) ;
% 
%                      Channels_zero_res_increase2( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%                  end
%                  Channels_zero_res_increase2_good = Channels_zero_res_increase2( find( abs(Channels_zero_res_increase2 ) > 0 ) );
                 
                 Channels_zero_res_increase2_good = Channel_nonZero_difference_mean_ratio2( find( abs(Channel_nonZero_difference_mean_ratio2 ) > 0 ) );
                 
    
                 
%                     Channels_zero_res_increase  = [] ;
%                  for ch=1:N
%                      Pzero2 = ...
%                      ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns2.NUMBER_OF_STIMULS_original ) ;         
%                      Pzero1 = ...
%                      ((Patterns1.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns1.NUMBER_OF_STIMULS_original ) ;
% 
%                      Channels_zero_res_increase( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%                  end
%                  Channels_zero_res_increase_good = Channels_zero_res_increase( find( abs(Channels_zero_res_increase ) > 0 ) );
                  
                 Channels_zero_res_increase_good = Channel_nonZero_difference_mean_ratio( find( abs(Channel_nonZero_difference_mean_ratio ) > 0 ) );

                 
                 Min_diff= min( [ min( Channels_zero_res_increase_good ) min( Channels_zero_res_increase2_good ) ] );
                 MMax_diff= min( [ max( Channels_zero_res_increase_good ) max( Channels_zero_res_increase2_good ) ] );                 
                 HStep = ( MMax_diff -  Min_diff )/ 10 ;
                 
                 
                	 xxx =  Min_diff  : HStep: MMax_diff ;
                [n,xout] = histc( Channels_zero_res_increase_good  ,xxx) ;
                n2 = n / length( Channels_zero_res_increase_good  )* 100 ;
                                    
                [n3,xout3] = histc( Channels_zero_res_increase2_good  ,xxx) ;
                n4 = n3 / length( Channels_zero_res_increase2_good  )* 100 ;           
                
                
                hold on
                    
                    bar( xxx , n4 ,'r' ) 
                    bar( xxx , n2 , 0.5 )
                hold off 
                legend( 'Ctrl-Effect' , 'Ctrl1-2' )
                    title( 'Non-Zero resp increase' )
                     xlabel( 'Diff, %')    
                   ylabel( 'Count, %') 
                   
    
    subplot(PlotY, PlotX , PlotX_dx + PlotX   +2 );               
              Channels_zero_res_increase_good_mean = mean(  Channels_zero_res_increase_good );
            Channels_zero_res_increase_good_std = std( Channels_zero_res_increase_good ) ; 
            Channels_zero_res_increase2_good_mean = mean( Channels_zero_res_increase2_good );
            Channels_zero_res_increase2_good_std = std( Channels_zero_res_increase2_good ) ;
            [p,StatisitcallyDifferent_if1] = ranksum(Channels_zero_res_increase_good , Channels_zero_res_increase2_good , PVAL_Threshold  );   
            if StatisitcallyDifferent_if1 == 1
               StatDiff = '*' ; 
            else
               StatDiff = '' ; 
            end


            XxX = 1:2 ;
            barwitherr( [Channels_zero_res_increase_good_std Channels_zero_res_increase2_good_std], XxX , ...
                [Channels_zero_res_increase_good_mean Channels_zero_res_increase2_good_mean] ); 
                     title( [ 'Non-Zero resp increase ('  StatDiff ')' ] )
                    xlabel(  ' Ctr1-Ctr2, Ctr2-Effect'  )
                    ylabel( 'Diff, %')         
    
%         subplot(PlotY, PlotX , PlotX_dx + PlotX  + 1 ); 
%                  NNN = 10 ;
%                 Channels_zero_res_increase  = [] ;
%                  for ch=1:N
%                      Pzero2 = ...
%                      ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns2.NUMBER_OF_STIMULS_original ) ;         
%                      Pzero1 = ...
%                      ((Patterns1.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns1.NUMBER_OF_STIMULS_original ) ;
% 
%                      Channels_zero_res_increase( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%                  end
%                  Channels_zero_res_increase_good = Channels_zero_res_increase( find( abs(Channels_zero_res_increase ) > 0 ) );
% 
%                 [n,xout] = hist( Channels_zero_res_increase_good  , NNN ) ;
%                 n2 = n / length( Channels_zero_res_increase_good  )* 100 ;    
%                     bar(xout , n2 )
%                     title( 'Zero resp increase, Ctr1-Ctrl2' )
%                     xlabel( 'Diff, %')   
%                    ylabel( 'Count, %') 
%            
%            
%            
%          subplot(PlotY, PlotX , PlotX_dx + PlotX  + 2 ); 
%                  NNN = 10 ;
%                 Channels_zero_res_increase2 = [] ;
%                  for ch=1:N
%                      Pzero2 = ...
%                      ((Patterns3.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns3.NUMBER_OF_STIMULS_original ) ;         
%                      Pzero1 = ...
%                      ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns2.NUMBER_OF_STIMULS_original ) ;
% 
%                      Channels_zero_res_increase2( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%                  end
%                  Channels_zero_res_increase2_good = Channels_zero_res_increase2( find( abs(Channels_zero_res_increase2 ) > 0 ) );
% 
%                 [n,xout] = hist( Channels_zero_res_increase2_good  , NNN ) ;
%                 n2 = n / length( Channels_zero_res_increase2_good  )* 100 ;    
%                     bar(xout , n2 )
%                     title( 'Zero resp increase, Ctr2-Effect' )
%                     xlabel( 'Diff, %')   
%                    ylabel( 'Count, %')          
           
end

        
%         if max( Patterns1_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) > 0
%              axis( [ min( TimeBins_x )-DT_step  max( TimeBins_x )+DT_step 0 1.2 * max( Patterns1_to_draw.TimeBin_Total_Spikes_std ) ...
%              + max( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) ] )
%         end 
      

% if  Patterns1.Flags(1) == 1  
%                     Channels_zero_res_increase  = [] ;
%                  for ch=1:N
%                      Pzero2 = ...
%                      ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns2.NUMBER_OF_STIMULS_original ) ;         
%                      Pzero1 = ...
%                      ((Patterns1.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns1.NUMBER_OF_STIMULS_original ) ;
% 
%                      Channels_zero_res_increase( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%                  end
%                  Channels_zero_res_increase_good = Channels_zero_res_increase( find( abs(Channels_zero_res_increase ) > 0 ) );
%     
%      
%                     Channels_zero_res_increase2 = [] ;
%                  for ch=1:N
%                      Pzero2 = ...
%                      ((Patterns3.Spike_Rates_each_channel_zero_values_num( ch )  )/Patterns3.NUMBER_OF_STIMULS_original ) ;         
%                      Pzero1 = ...
%                      ((Patterns2.Spike_Rates_each_channel_zero_values_num( ch ) )/Patterns2.NUMBER_OF_STIMULS_original ) ;
% 
%                      Channels_zero_res_increase2( ch ) = 100 * ( Pzero2 -  Pzero1 ); 
%                  end
%                  Channels_zero_res_increase2_good = Channels_zero_res_increase2( find( abs(Channels_zero_res_increase2 ) > 0 ) );
%                  
%                  
%                   
%             Channels_zero_res_increase_good_mean = mean(  Channels_zero_res_increase_good );
%             Channels_zero_res_increase_good_std = std( Channels_zero_res_increase_good ) ; 
%             Channels_zero_res_increase2_good_mean = mean( Channels_zero_res_increase2_good );
%             Channels_zero_res_increase2_good_std = std( Channels_zero_res_increase2_good ) ;
%             [p,StatisitcallyDifferent_if1] = ranksum(Channels_zero_res_increase_good , Channels_zero_res_increase2_good , PVAL_Threshold  );   
%             if StatisitcallyDifferent_if1 == 1
%                StatDiff = '*' ; 
%             else
%                StatDiff = '' ; 
%             end
% 
%             subplot(PlotY, PlotX , PlotX_dx + PlotX*2  +2 );
%                 XxX = 1:2 ;
%                 barwitherr( [Channels_zero_res_increase_good_std Channels_zero_res_increase2_good_std], XxX , ...
%                     [Channels_zero_res_increase_good_mean Channels_zero_res_increase2_good_mean] ); 
%                          title( [ 'Zero resp increase ('  StatDiff ')' ] )
%                         xlabel(  ' Ctr1-Ctr2, Ctr2-Effect'  )
%                         ylabel( 'Diff, %')
% 
% end

subplot(PlotY, PlotX , PlotX_dx + PlotX*3  +1 ); 
    XxX = 1:3 ;
    barwitherr( [std(Patterns1.Spike_Rates_each_burst) std(Patterns2.Spike_Rates_each_burst) std(Patterns3.Spike_Rates_each_burst)]...
        , XxX , ...
        [mean(Patterns1.Spike_Rates_each_burst) mean(Patterns2.Spike_Rates_each_burst) mean(Patterns3.Spike_Rates_each_burst)] );  
             title(  'Stat diff Spike rates'   )
            xlabel( [ ' Ctr1-Ctr2 (' Stat_Selective_SpikeRates '), Ctr2-Effect (' Stat_Selective_SpikeRates2 ')' ])
            ylabel( 'Spike rate')

subplot(PlotY, PlotX , PlotX_dx + PlotX*3  +2 ); 
  bar( [ Stat_Selective_electrodes_precent    Stat_Selective_electrodes_precent2 ])
             title(  'Stat selective electrodes'   )
            xlabel( ' Ctr1-Ctr2, Ctr2-Effect')
            ylabel( 'Elcedtrodes, %')

            
          if exist( 'GLOB' )                          
             if isfield( GLOB , 'pause_on_cluster_figs' )  
                 if GLOB.pause_on_cluster_figs
                    pause 
                 end
             end   
             
             if isfield( GLOB , 'pause_on_tet_channel_analysis' )  
                 if GLOB.pause_on_tet_channel_analysis && flags.Tet_channel_stim
                    pause 
                 end
             end   
          end      
            

end


     
          
          
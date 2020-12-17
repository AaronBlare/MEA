function  [ T_act ] = ...
    Selective_Channels_Tactivation_in_Patterns( Patterns1 , Patterns2 , STIM_RESPONSE_BOTH_INPUTS , OVERLAP_TRESHOLD , Show_Figures)
% Stat and linear (by clustering) difference of activation times in all
% channels independently
% OUTPUT :
%     T_act.total_number_of_active_electrodes 
%     T_act.Stat_selective_channels_num_Tact 
%     T_act.Stat_Selective_channels_percent_Tact 
%     T_act.Selective_electrodes_lin_div_num_Tact_Tact 
%     T_act.Selective_electrodes_lin_div_percent_Tact 
%     T_act.ALL_CHANNELS_Overlaps_lin_div_Tact
 
% STIM_RESPONSE_BOTH_INPUTS = 0 ; 
OVERLAP_NOT_RESPOND_TO_BOTH = 100 ;

N = length( Patterns1.Spike_Rates_each_channel_mean  );
Nb = Patterns1.Number_of_Patterns  ;
Nb2 = Patterns2.Number_of_Patterns  ;

PVAL_Threshold = 0.005 ;

Stat_selective_channels_num_Tact = 0 ;
total_number_of_active_electrodes = 0 ; 
Selective_electrodes_lin_div_num_Tact_Tact=0 ;
OVERLAP_TRES = OVERLAP_TRESHOLD ;
ALL_CHANNELS_Overlaps_lin_div_Tact_clean=[];
ALL_CHANNELS_Overlaps_lin_div_Tact=[];
ALL_CHANNELS_Stat_selective=[];
Channels1_Tact_mean = zeros(  N ,1 );
Channels1_Tact_std = zeros(  N ,1 );
Channels2_Tact_mean = zeros(  N ,1 );
Channels2_Tact_std = zeros(  N ,1 );
Channels_overlap = zeros(  N ,1 );
Channels_is_selective= zeros(  N ,1 );
Channel_difference_mean = zeros(  N ,1 );
 ttt=0;
for ch = 1 : N 
      chan_times1 =  [] ;   
      chan_times2 =  [] ; 
      hh=0;
      hh2 = 0;
      for t = 1 : Nb           
          hh = hh + H(  Patterns1.burst_activation( t , ch ) ) ;
          if H(  Patterns1.burst_activation( t , ch ) ) > 0 
             chan_times1 = [ chan_times1   Patterns1.burst_activation( t , ch ) ] ;
          end
      end
      for t = 1 : Nb2      
          hh2 = hh2 + H(  Patterns2.burst_activation(  t , ch ) ) ;
          if H(  Patterns2.burst_activation( t , ch ) ) > 0 
             chan_times2 = [ chan_times2   Patterns2.burst_activation( t , ch ) ] ;
          end
      end
      
%       if ch == 49 || ch==57
%           length( chan_times1 )
%           length( chan_times2 )
%       end
      
      if hh > 0 && hh2 > 0
         [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent]= ...
          SelectiveValues( chan_times1,chan_times2, PVAL_Threshold , OVERLAP_TRES , false) ;
           
%           Overlaps_lin_div_Tact = [Overlaps_lin_div_Tact overlap_values_Optim_Thres_precent ];     
          

         if hh / ( Nb ) >= STIM_RESPONSE_BOTH_INPUTS && hh2 / ( Nb2) >= STIM_RESPONSE_BOTH_INPUTS
             total_number_of_active_electrodes = total_number_of_active_electrodes + 1 ;
             Stat_selective_channels_num_Tact = Stat_selective_channels_num_Tact + StatisitcallyDifferent_if1 ; 
             Selective_electrodes_lin_div_num_Tact_Tact = Selective_electrodes_lin_div_num_Tact_Tact + LinearyDifferent_if1;
             Channels_is_selective(ch) = StatisitcallyDifferent_if1 ;
             Channels_overlap(ch) = overlap_values_Optim_Thres_precent ;
             ALL_CHANNELS_Overlaps_lin_div_Tact = [ALL_CHANNELS_Overlaps_lin_div_Tact overlap_values_Optim_Thres_precent ];    
             ALL_CHANNELS_Overlaps_lin_div_Tact_clean = [ALL_CHANNELS_Overlaps_lin_div_Tact_clean ...
                        overlap_values_Optim_Thres_precent ];  
    %         if number_of_selective_electrodes < 5
    
    %             [n,x] = hist(chan_times1);
    %             [n2,x2] = hist(chan_times2);
    %             figure  
    %             bar( [ x' x2' ],[ n' n2' ])       
    %             title( 'Activation times (hist) on 1 electrode for selective electrodes Tact')
    %         end 
         else 
             Channels_is_selective(ch) = 0 ;
             Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
         end

        Channels1_Tact_mean(ch) = mean( chan_times1 ) ;
        Channels2_Tact_mean(ch) = mean( chan_times2) ;
        Channels1_Tact_std(ch) = std( chan_times1 ) ;
        Channels2_Tact_std(ch) = std( chan_times2) ; 





         if overlap_values_Optim_Thres_precent < OVERLAP_TRESHOLD  & ttt <5 && Show_Figures ...
                       & Channels_is_selective(ch) == 1 
             ttt=ttt+1; 
             
             BINs_number = 10 ;
    %          && Zero_values_total_precent < 20
             xxx = max(max(chan_times1),max(chan_times2));
    %          xxx = 1:floor(xxx/10):xxx;
             chan_times1'
             chan_times2'
             xxx =  1:floor(xxx/BINs_number):xxx; 

                [n,x] = hist(chan_times1 , xxx);
                n=100* n/ length( chan_times1 );
                [n2,x2] = hist(chan_times2 , xxx);
                n2=100* n2/ length( chan_times2 );

                f = figure   ; 
                figure_title = 'Spikerate separation example' ;
                 set(f, 'name',  figure_title ,'numbertitle','off' )
                subplot( 2,1,1);
                bar( [ x' x2' ],[ n' n2' ],1 )       
%                 plot(   x ,  n ,  x2,  n2   )       
                title( ['Selective electrodes Tact,overlap='...
                  int2str(  floor(overlap_values_Optim_Thres_precent)) ])
                subplot( 2,1,2);
                 hold on
    %             bar( chan_times1 , 'BarWidth',0.6)
    %             bar( chan_times2, 'r','BarWidth',0.3)
                plot( chan_times1 ,  '--'  , 'MarkerSize'      , 6 ,'Marker'          , '.')
                plot( chan_times2, 'r','MarkerSize'      , 6 ,'Marker'          , '.'  )
                xlabel( 'Stimulus #');
                ylabel( 'Activation timing, ms');
                title( ['Channel ' int2str(ch)] )
                hold off
    %             pause
         end

 

        
 
      
      else
          ALL_CHANNELS_Overlaps_lin_div_Tact = [ALL_CHANNELS_Overlaps_lin_div_Tact OVERLAP_NOT_RESPOND_TO_BOTH  ];   
          Channels_overlap(ch) = OVERLAP_NOT_RESPOND_TO_BOTH ;
          Channels_is_selective(ch) = 0 ;
      end
      Channel_difference_mean(ch) = Channels_is_selective(ch)*(mean(chan_times2) - mean(chan_times1)) / mean(chan_times1);
      
end

  Selective_electrodes_lin_div_percent_Tact = 100 *( Selective_electrodes_lin_div_num_Tact_Tact / total_number_of_active_electrodes );
  Stat_Selective_channels_percent_Tact = 100 *( Stat_selective_channels_num_Tact / total_number_of_active_electrodes );
  
  
  
% Channel_difference_mean =Channel_difference_mean * Channels_is_selective ;
T_act.total_number_of_active_electrodes =total_number_of_active_electrodes;
T_act.Stat_selective_channels_num = Stat_selective_channels_num_Tact;
T_act.Stat_Selective_channels_percent =Stat_Selective_channels_percent_Tact;
T_act.Selective_electrodes_lin_div_num =Selective_electrodes_lin_div_num_Tact_Tact;
T_act.Selective_electrodes_lin_div_percent =Selective_electrodes_lin_div_percent_Tact;
T_act.ALL_CHANNELS_Overlaps_lin_div =ALL_CHANNELS_Overlaps_lin_div_Tact;
T_act.Channels_overlap = Channels_overlap ;






  
if Show_Figures
%   figure
%      xxx =  0 : 5 : 100 ;
%      [n,x] = hist(ALL_CHANNELS_Overlaps_lin_div_Tact ,xxx); 
%      n=100* n/ length( ALL_CHANNELS_Overlaps_lin_div_Tact);
%   
%      Binn = 10 ;
%     [n,x] = hist_desired( TOTAL_RATE.Channels_overlap , Binn ) ;
%      bar( x , n )
%      title( 'ALL_CHANNELS_Overlaps_lin_div_Tact hist' )
%      
  figure
%     subplot(2,1,1);
%          bar( [ Channels1_Tact_mean Channels2_Tact_mean  ] ) 
%         title( 'Mean T activation in 2 pattern sets' )
%         % end      
%         % figure  
    subplot(4,2,1:2); 
    x= (1:N ) ; 
    y= [Channels1_Tact_mean Channels2_Tact_mean  ] ;
    e= [ Channels1_Tact_std   Channels2_Tact_std  ] ; 
    ycolor= ['b','r'];
    ecolor= ['k','k']; 
     barwitherr( e , x ,y ) 
     ylabel( 'T act., ms')
      axis( [ min(x)-1 max(x)+1 0 1.2 * max( [ Channels1_Tact_mean' Channels2_Tact_mean'  ] ) ...
                         + max([ Channels1_Tact_std'   Channels2_Tact_std'  ]) ] ) 
    title( 'Mean T activation in 2 pattern sets' )


%     subplot(2,1,2);
%         hold on
%            errorbar( Channels1_Tact_mean  , Channels1_Tact_std , 'x' )  
%               errorbar( Channels2_Tact_mean  , Channels2_Tact_std  , 'xr')
%               title( 'Mean T activation in 2 pattern sets' )
%         hold off

%     figure
%     subplot(3,1,1);
%         bar( Channels_is_selective  )
%          title( 'Selective electrodes if 1'  )
% 
%     %          figure
%     subplot(3,1,2);
%         bar( Channels_overlap  )
%          title( 'Overlap, similar rates %' )

    subplot(4,2,3:4);
         hold on
         
         bar( Channels_is_selective*100  ,'r' )
         
        bar( Channels_overlap , 0.5 )
        ylabel( 'Overlap') 

        hold off
        axis( [ min(x)-1 max(x)+1 0 1.1 * max( Channels_overlap ) ] ) 
         title( 'Overlap, similar T act. %' )
         legend( 'Stat different Tact', 'Overlap',4 )
         
         
    subplot(4,2,5:6);            
        bar( Channel_difference_mean , 0.5 )
            ylabel( 'Raatio')
            title( 'Mean difference normalized') 
            if max( Channel_difference_mean ) > min( Channel_difference_mean )
                axis( [ min(x)-1 max(x)+1 1.1*min(Channel_difference_mean) 1.1 * max( Channel_difference_mean ) ] ) 
            end
            
%     subplot(3,1,3);
%         bar(   x   ,  n     )
%      title( 'Tact Overlaps Distribution, %' )
     

 xxx =  0 : 5 : 100 ;
 [n_actual,xn] = hist(ALL_CHANNELS_Overlaps_lin_div_Tact ,xxx); 
 n_percent=100* n_actual/ length( ALL_CHANNELS_Overlaps_lin_div_Tact );
 
     subplot(4,2,7);
        bar(   xn   ,  n_actual     )
        ylabel( 'Channels')
         title( 'T activation Overlaps, %' )
         axis( [ min(xn)-0.1*(max(xn)) max(xn)+ 0.1*(max(xn)) 0 1.2 * max( n_actual ) ] )

    subplot(4,2,8);
        bar(   xn   ,  n_percent     )
         ylabel( 'Count, %')
         title( 'T activation Overlaps, %' )
         axis( [ min(xn)- 0.1*(max(xn)) max(xn)+ 0.1*(max(xn)) 0 1.2 * max( n_percent ) ] )
%-----------------------------------------------        

  
     
     
%     Plot8x8Data( ALL_CHANNELS_Overlaps_lin_div_Tact )
%         xlabel('Electrode #')
%         ylabel('Electrode #')
%               title( 'Overlaps in first spiking times' )
%           
%                      
%      Plot8x8Data( Channels_is_selective )
%         xlabel('Electrode #')
%         ylabel('Electrode #')
%               title( 'Stat selective in first spiking times' )
%               colormap gray
          
    %---- 8x8 figures os selectivity ----------------     
f = figure; 

    subplot(1,2,1);
    Plot8x8Data( ALL_CHANNELS_Overlaps_lin_div_Tact , false )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Overlaps T act.' )
     
    subplot(1,2,2); 
    Plot8x8Data( Channels_is_selective , false )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Stat. different T act.(1-different)' )
%      colormap gray
 
     
%      Overlaps_lin_div( Overlaps_lin_div >50 ) = [];      
          
          
end 
  
ALL_CHANNELS_Overlaps_lin_div_Tact( ALL_CHANNELS_Overlaps_lin_div_Tact >100 ) = [];
 
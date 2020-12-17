% CYCLE_NUM_SIGNIFICANT_ELECTRODES_script

     m1burstactivation_reserv = m1.burst_activation ;
    m2burstactivation_reserv = m2.burst_activation ;
      Sense_CH = [] ;
      Sense_CH_all = [] ;    

       m1.burst_activation =m1burstactivation_reserv ;
      m2.burst_activation =m2burstactivation_reserv ;
      ITERA = 200 ;
      Sensitive_electrodes = zeros(N,1);
       DATA = [] ;
      ZERO_CHANNELS_NUM = 60 ;
    min_R4 = 1 ;
    Found_elec = 0 ;

    %   for ZERO_CHANNELS_NUM = 58 : N-4
          ZERO_CHANNELS_NUM
          mean_Jacc = [] ;
          for it = 1  : ITERA

                m1.burst_activation =m1burstactivation_reserv ;
              m2.burst_activation =m2burstactivation_reserv ;
            Y = EraseRandomChannles( ZERO_CHANNELS_NUM , N ) ;

                  m1.burst_activation( : , Y ) = 0 ;          

                  m2.burst_activation( : , Y ) = 0 ;             

             Num_channels_active = N - ZERO_CHANNELS_NUM ;      
             [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4,R5 ,R6] = Two_sets_compare_similarity( ...
               m1.burst_activation , m2.burst_activation , 0 , 0 , 0 ,0 , 'n' , PHASE_ON , ADJUST_SPIKES );  
           % R6 = Active_Patterns_to_centroid1 %!!!!    
           min_R4
               Found_elec
               mean_Jacc = [ mean_Jacc R4 ] ;
               if min_R4 > R4 min_R4 = R4; Sense_CH = Y ; end
               if R4 <= 0.05 && R5 == 1      
                   f= 1 :64 ;
                   Sense_CH = Y ;
                   Found_elec = Found_elec + 1 ;
    %                Sense_CH_all = [ Sense_CH_all ; Sense_CH ];
                   f(Y) = [] ;
                   f
                   Sensitive_electrodes( Y ) = Sensitive_electrodes( Y )- 1 ;
               end
    %        end
    %     DATA= [ DATA ; Num_channels_active mean( mean_Jacc ) ];
      end
    %      std(x)/sqrt(n)
    mmm = min(Sensitive_electrodes) ;
    Sensitive_electrodes = Sensitive_electrodes + abs(mmm);
    save  'Jacc_on_Active_electrodes.mat'
    figure
    bar( Sensitive_electrodes );
    title('Sensetive electrodes')

    Sense_CH'
     m1.burst_activation =m1burstactivation_reserv ;
     m2.burst_activation =m2burstactivation_reserv ;
     f= 1 :64 ;
     f(  Sense_CH ) = [] ;
     Sense_CH = f ;
    % Sense_CH  = [  1     3    17    32    53    64   ];
     f= 1 :64 ;
     f(  Sense_CH ) = [] ;
     m1.burst_activation( : , f ) = 0 ;    
     m2.burst_activation( : , f ) = 0 ;


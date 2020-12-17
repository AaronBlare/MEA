

function  MeaDB_ExpTotal_analyze_connectiv_all_exp( ALL_cell_total , Exp_num  , var  )

    
    
%     Valu Exp_num , vare_str_to_show   = { 'Connectiv_matrix_tau_of_max_M' , 'Correlation_matrix_SR_max_corr_delay' };
   Value_str_to_show   = { 'burst_activation_3_smooth_1ms_mean' , 'burst_max_rate_delay_ms_mean' , ...
       'Spike_Rates_each_channel_mean'} ;
%    burst_max_rate_delay_ms_mean
% burst_activation_mean

Tau_maxM_all = [] ;
Corr_max_all = [] ;
Tact_3_all = [] ;
Max_rate_t_all  = [] ;
file_n = 4 ;

min_spikes_p_burst = ALL_cell_total(1).Global_flags.Connectiv_min_spikes_per_channel ;

% Exp_num = 1 ;

     for Exp_i = 1 : Exp_num
        Snames = ALL_cell_total(1).Analysis_data_cell_field_names ;
        Name_index = strmatch( Value_str_to_show{ 3 } , Snames  ) ;
        dat = ALL_cell_total(Exp_i).Analysis_data_cell( file_n , Name_index )   ; 
        Spike_Rates_each_channel_mean = cell2mat( dat );     
         
         
        Connectiv_matrix_tau_of_max_M = ALL_cell_total(Exp_i).Connectiv_data( file_n ).Connectiv_matrix_tau_of_max_M ;
        Correlation_matrix_SR_max_corr_delay = ALL_cell_total(Exp_i).Connectiv_data( file_n ).Correlation_matrix_SR_max_corr_delay ;
        
        N = size(Connectiv_matrix_tau_of_max_M , 1 ) ;
%         Connectiv_matrix_tau_of_max_M_vec = reshape( Connectiv_matrix_tau_of_max_M , [] , N*N);
%         Correlation_matrix_SR_max_corr_delay_vec  = reshape( Correlation_matrix_SR_max_corr_delay , [] , N*N);
%         Tau_maxM_all = [ Tau_maxM_all   Connectiv_matrix_tau_of_max_M_vec ];
%         Corr_max_all = [ Corr_max_all   Correlation_matrix_SR_max_corr_delay_vec ];
        result = [];
        result2 = [];
         for chi = 1 : N 
             for chj = 1 : N 
%                 if chj > chi 
                    Tact_diff = 0 ;
                    Corr_max= 0 ;
                if Spike_Rates_each_channel_mean( chi ) >= min_spikes_p_burst && ... 
                        Spike_Rates_each_channel_mean( chj ) >= min_spikes_p_burst 
                    Tact_diff =  Connectiv_matrix_tau_of_max_M( chi ,chj ) ;  
                    Corr_max =  Correlation_matrix_SR_max_corr_delay( chi ,chj ) ;  
                end
                result  = [result Tact_diff ];
                result2  = [result2 Corr_max ]; 
%                 end
             end
         end 
        Tau_maxM_all = [ Tau_maxM_all   result ];
        Corr_max_all = [ Corr_max_all   result2 ];
        
        
        
         
   % --- Analysis_data_cell, take matrix Tact----------------- 
        Snames = ALL_cell_total(1).Analysis_data_cell_field_names ;
        Name_index = strmatch( Value_str_to_show{ 1 } , Snames  ) ;
        dat = ALL_cell_total(Exp_i).Analysis_data_cell( file_n , Name_index )   ; 
        dat = cell2mat( dat );
        
        result = [];
         for chi = 1 : N 
             for chj = 1 : N 
%                 if chj > chi 
                    Tact_diff = 0 ;
                if Spike_Rates_each_channel_mean( chi ) >= min_spikes_p_burst && ... 
                        Spike_Rates_each_channel_mean( chj ) >= min_spikes_p_burst 
                    Tact_diff =  dat( chi ) - dat( chj ) ;  
                end
                result  = [result Tact_diff ];
%                 end
             end
         end
         Tact_3_all = [ Tact_3_all   result ] ;
         %------------------------------------------------
         
        % --- Analysis_data_cell, take matrix maxrate-----------------
        Snames = ALL_cell_total(1).Analysis_data_cell_field_names ;
        Name_index = strmatch( Value_str_to_show{ 2 } , Snames  ) ;
        dat = ALL_cell_total(Exp_i).Analysis_data_cell( file_n , Name_index )   ; 
        dat = cell2mat( dat );       
        
        result = [];
         for chi = 1 : N 
             for chj = 1 : N 
                 Tact_diff = 0 ;
              if Spike_Rates_each_channel_mean( chi ) >= min_spikes_p_burst && ... 
                        Spike_Rates_each_channel_mean( chj ) >= min_spikes_p_burst 
                Tact_diff =  dat( chi ) - dat( chj ) ;  
              end
               result  = [result Tact_diff ];
             end
         end
         Max_rate_t_all  = [ Max_rate_t_all   result ] ;
         %------------------------------------------------         
        
     end
     
     
     Tact_3_all = abs( Tact_3_all ) ;
     Max_rate_t_all = abs( Max_rate_t_all );
%       figure
%      plot( Tact_3_all , Max_rate_t_all  , '*' )     
%      xlabel( 'burst_activation_3_smooth_1ms_mean' )
%      figure
%      hist(  Tact_3_all   )
%      figure
%      hist(  Max_rate_t_all    )
     

% Tau_maxM_all = Tact_3_all  ;
%  Tau_maxM_all = Max_rate_t_all   ;
%  Corr_max_all = Max_rate_t_all     ;
%  Corr_max_all = Tact_3_all     ;
 
      
           Corr_max_all( Tau_maxM_all == 0 ) = [] ;
           Tau_maxM_all( Tau_maxM_all == 0 ) = [] ;
%            Tau_maxM_all( Corr_max_all >50 ) = [] ;
%            Corr_max_all( Corr_max_all >50 ) = [] ;           
%                Corr_max_all( Tau_maxM_all >50 ) = [] ;
%                Tau_maxM_all( Tau_maxM_all >50 ) = [] ;  

           Tau_maxM_all( Corr_max_all >120 ) = [] ;
           Corr_max_all( Corr_max_all >120 ) = [] ;           
               Corr_max_all( Tau_maxM_all >120 ) = [] ;
               Tau_maxM_all( Tau_maxM_all >120 ) = [] ; 
               
               
     figure
           plot( Tau_maxM_all' , Corr_max_all' , '*')
           xlabel( 'Tau_maxM_all' )
           ylabel( 'Corr_max_all')
           max_val =  max( max( Tau_maxM_all) )    ;
%            axis( [ 0 max_val  0 max_val ] )
          
           whos x
           whos y
           x = Tau_maxM_all ;
           y = Corr_max_all ;
           [x , ix ] =sort(x) ;
           y = y( ix ); 
           
%            x = 1:100;
%            y= x + 3* randn(1,100); 
           P1 = polyfit(x,y, 1 )
           yhat = polyval(P1,x)  ;
           
           [R,P]=corrcoef( x , y ) ;
           R = R(2)
           p_val = P(2)
           
           [p,err] = polyfit(x,y,1);   % First order polynomial
           y_fit = polyval(p,x,err);   % Values on a line
            y_dif = y - y_fit;          % y value difference (residuals)
            SSdif = sum(y_dif.^2);      % Sum square of difference
            SStot = (length(y)-1)*std(y)*std(y);   % Sum square of y taken from variance
            rsq = 1-SSdif/SStot;        % Correlation 'r' value. If 1.0 the correlelation is perfec
            rsq
            
            
            
            
            
             
           figure
           hold on
            plot(x,y,'b*')
            plot( x,yhat,'r-', 'Linewidth' , 2)
            hold off
            xlabel X
            ylabel Y
            grid on
%             title( 'Linear polynomial fit')
            axis( [ 0 max_val  0 max_val ] )
            xlabel( 'Spike train correlation, ms' )
           ylabel( 'Profile correlation delay, ms')
%            ylabel( 'Max. spike rate difference, ms')
%             xlabel( 'Max. spike rate difference, ms' )
%            ylabel( 'Activation time difference, ms')           

           diff = Tau_maxM_all - Corr_max_all ;
           diff( abs( diff ) > 100 ) = []; 
           
           Nx=2 ; Ny =1 ;
           figure
           subplot( Ny , Nx , 1)
               hist( dat , 50 )
               title( 'Max_rate_t_all')
           subplot( Ny , Nx , 2)
               hist( Corr_max_all , 50 )
               title( 'Corr_max_all')
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
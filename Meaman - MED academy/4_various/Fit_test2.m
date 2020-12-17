% Fit_test1   




% y = x( 1 : 200000);
% y = x( 1 : 600000);
% y = x ;
% y_patch_origin = y ;
% [params decayFits] = detectPSPs(y , true   )
% 
%  decays = decayFits ;
% for i = 1 : length(params(  : , 3) )
% st = floor( params( i , 3) )  ;
% decays{i} = y_patch_origin( st : st+ 500 ) ;
% end


% Nsig = 2  ;
Nsig0 = Nsig ;
sss = size( post_stim_signals_all ) ;
Nsig = sss(1)   ;

show_test_figs = false ;
adjust_art = false ;
leave_pre_ms = NaN ;
leave_post_ms = NaN ;

leave_pre_ms = - 5 ;
leave_post_ms = 20 ;


Filt_y = [] ;
Origin_y = [] ;

ftype = fittype( 'lowess') ;  
 ftype = fittype( 'M/(1+((x-T)/w).^2)+O') ;  
    %                       warning off
    x_normed = [ 0 : 1 : 300 ]   ;              
     
    
    fr_post  = find( Details.option_data_all(1).post_stim_signals_time_x_ms > leave_post_ms ,1 );
    fr_pre = find( Details.option_data_all(1).post_stim_signals_time_x_ms >  leave_pre_ms ,1 );
    min_pre_ms = min(  Details.option_data_all(1).post_stim_signals_time_x_ms ) ;
      
    
    tau_x =  0 : 1 : 1000 ; %  delays for fitting ;
    tau_x_ms = ((1000 * tau_x ) / sr ) ;
    x_normed = (max(tau_x)/2  - tau_x) / max(tau_x) ;
    x_normed=-x_normed; % delays for poly fit
    
    M_of_tau_original = post_stim_signals_all( 1 , :) ;
    
    if ~isnan( fr_pre )  &  ~isnan( fr_post ) 
    M_of_tau_original = M_of_tau_original( fr_pre : fr_post ); 
    t_x = Details.option_data_all(1).post_stim_signals_time_x_ms( fr_pre : fr_post ); 
    else
      t_x = Details.option_data_all(1).post_stim_signals_time_x_ms; 
    end
    
%     t_x = 1:length( M_of_tau_original ) ;
%     t_x = ((1000 * t_x ) / sr ) ;
    
    if show_test_figs
        figure
        plot( t_x , M_of_tau_original )
        title( 'M_of_tau_original')
    end
    
    artifact_sign = 1 ;
    
    if adjust_art 
    [maxa , mimax ] = max( M_of_tau_original ); 
    [mina , mimin ] = min( M_of_tau_original ); 
    
        if  abs( maxa ) > abs( mina )  
            artifact_sign = 1 ;
            mi = mimax ;
        else

        artifact_sign = -1 ;
        mi = mimin ;
        end
    
    M_of_tau_original(1: mi )=[];
    M_of_tau_original( 1+ length( x_normed ) : end) = [] ;
    
    end
    
%     t_x = 1:length( M_of_tau_original ) ;
%     t_x = ((1000 * t_x ) / sr ) ;
    
        if show_test_figs
             figure
            plot( t_x , M_of_tau_original )
            title( 'Original artifact')
        end
%     M_of_tau_original(1: 412 )=[];
%     M_of_tau_original( 1+ length( x_normed ) : end) = [] ;
    M_of_tau = M_of_tau_original ;
%     figure
%     plot( M_of_tau_original )
     
   for   ssi = 1 : Nsig
    
%         M_of_tau_original = -decays{ i} ;
%         M_of_tau_original = -post_stim_signals_all( i , :) ;
        
        M_of_tau_original = artifact_sign *  post_stim_signals_all( ssi , :) ;

        if adjust_art 
            
            
%         M_of_tau_original(1: 412 )=[];

        M_of_tau_original(1: mi )=[];
        
%         M_of_tau_original(1: 10 )=[];
    M_of_tau_original( 1+ length( x_normed ) : end) = [] ;
        else
            if ~isnan( fr_pre )  &   ~isnan( fr_post ) 
                M_of_tau_original = M_of_tau_original( fr_pre : fr_post ); 
            end
        end
    
    Origin_y = [ Origin_y   ;  M_of_tau_original ] ;
    
 
    M_of_tau   = SALPA( M_of_tau_original  );
  
    
%     M_of_tau   = SALPA( M_of_tau_original ,n, init, duration )  ;
    

% - --- TEST SALPA -----------------------
%     
%     figure
%     
%     hold on 
%     xxmax = 10   ;
%     dx = 5 ;
%     d1 = 2  ;
%     
%     M_of_tau_all = [] ; 
%     for i = d1 : dx : d1 + xxmax 
%         
%         n = i ; 
%         
%         
% %         n =  75 ;
%             n0 = n ;
%         init = n0 + 1 ;
%         
% %         init =  i ;
%         duration = length(M_of_tau_original) - 2*n0 - 2;
%         duration = duration - 100 ;
%         
%         M_of_tau   = SALPA( M_of_tau_original ,n , init , duration)  ;
%         M_of_tau_all = [M_of_tau_all ; M_of_tau ] ;
% %         M_of_tau   = SALPA( M_of_tau_original ,n, init, duration )  ;
%  
%     end
%     plot(  t_x,  M_of_tau_all  )
 % - --- TEST SALPA -----------------------   
%  figure
%  plot(  t_x,  M_of_tau_original  )
 
 
    if show_test_figs
                                    figure
                                    hold on 
%                                     plot(  tau_x_ms , M_of_tau_original )
%                                      plot(  tau_x_ms , M_of_tau , 'r' )
                                     

                                    plot(  t_x ,  M_of_tau_original )
                                     plot(  t_x, M_of_tau , 'r' )
                                     
                                     hold off
                                     title( 'Fitted artifact')
    end
                                     
                                     
                         FF =  M_of_tau ;
%                          figure ; plot( -FF) ;
                         
                         Filt_y = [ Filt_y   ; artifact_sign * FF ] ;
                         
                         
                         
   end                    
                   
   
                  figure ; plot(  t_x , Origin_y' ) ;
                title( 'All original artifacts')
                
                
              figure ; plot( t_x , artifact_sign *  Filt_y' ) ;
              title( 'All filtered artifacts')
                 
              
             tau_x =  t_x ;
Nsig  = Nsig0 ;
 
              
              
                         
                         
                         
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


% Nsig = 10 ;
show_test_figs = false ;


Filt_y = [] ;
Origin_y = [] ;

ftype = fittype( 'lowess') ;  
 ftype = fittype( 'M/(1+((x-T)/w).^2)+O') ;  
    %                       warning off
    x_normed = [ 0 : 1 : 300 ]   ;                          

    
    tau_x =  0 : 1 : 200 ; %  delays for fitting ;
    tau_x_ms = ((1000 * tau_x ) / sr ) ;
    x_normed = (max(tau_x)/2  - tau_x) / max(tau_x) ;
    x_normed=-x_normed; % delays for poly fit
    
    M_of_tau_original = post_stim_signals_all( 1 , :) ;
    t_x = 1:length( M_of_tau_original ) ;
    t_x = ((1000 * t_x ) / sr ) ;
    
    if show_test_figs
        figure
        plot( t_x , M_of_tau_original )
    end
    
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
    t_x = 1:length( M_of_tau_original ) ;
    t_x = ((1000 * t_x ) / sr ) ;
    
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
     
   for   i = 1 : Nsig
    
%         M_of_tau_original = -decays{ i} ;
%         M_of_tau_original = -post_stim_signals_all( i , :) ;
        
        M_of_tau_original = artifact_sign *  post_stim_signals_all( i , :) ;
        
%         M_of_tau_original(1: 412 )=[];
        M_of_tau_original(1: mi )=[];
        
%         M_of_tau_original(1: 10 )=[];
    M_of_tau_original( 1+ length( x_normed ) : end) = [] ;
    
    Origin_y = [ Origin_y   ; -M_of_tau_original ] ;
    
    
     fresult = fit( tau_x' ,M_of_tau_original' , ftype ,'Lower',[1 ,-100 , -300 , - 1000],'Upper',...
                              [Inf,1000 , 300 , 1000 ],'StartPoint',[1000 -5 0 3], 'MaxIter' , 10000 );
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
                               if abs( fresult.w) > 0 
                                     Connection_OK = true ;
                                      for x_i = 1 : length( tau_x )
                                        M_of_tau( x_i ) = fresult.M / ( 1+( ( tau_x(x_i)-fresult.T )/ fresult.w ).^2)+ fresult.O ;
                                      end  
        %                               if Show_fit_plot 
%                                         plot( fresult, tau_x , M_of_tau )
        %                               end 
        %                               Connectiv_matrix_M_on_tau_Blocks( chi ,chj , : )= M_of_tau /   Total_Spike_Rates( chi ) ;
                                      tau_max = H( tau_max ) * tau_max ; 
                                      M_max = max( M_of_tau ) ;
                                 
                               end
                            end
%     
%                           fresult = fit( x_normed'  ,M_of_tau_original' , ftype );
%                           p = [  fresult.p1 fresult.p2 fresult.p3 fresult.p4 fresult.p5  fresult.p6 fresult.p7 ];
%                           M_of_tau_poly_fit = polyval(p,x_normed);
%                           y_fit = M_of_tau_poly_fit ;
%                           M_max = max( M_of_tau_poly_fit );  
%                           tau_max_index = find( M_of_tau_poly_fit == M_max ,1) ;            
%                            tau_max = ( tau_max_index - 1)*1 ;  
%                           
%                                     M_of_tau  =   M_of_tau_poly_fit ;
%                             

    if show_test_figs
                                    figure
                                    hold on 
                                    plot(  tau_x_ms , M_of_tau_original )
                                     plot(  tau_x_ms , M_of_tau , 'r' )
                                     hold off
                                     title( 'Fitted artifact')
    end
                                     
                                     
                         FF = M_of_tau_original - M_of_tau ;
%                          figure ; plot( -FF) ;
                         
                         Filt_y = [ Filt_y   ; artifact_sign * FF ] ;
                         
                         
                         
   end                    
                   
   
                  figure ; plot(  Origin_y' ) ;
                title( 'All original artifacts')
                
                
              figure ; plot( tau_x_ms , artifact_sign *  Filt_y' ) ;
              title( 'All substracted artifacts')
                         
 
                         
                         
                         
                         
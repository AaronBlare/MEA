
function [ M_of_tau ,tau_max, M_max  ,diff ] = fit_artifact( Y )  


Show_fit_plot = false ;


tau_x = 0 : 1 : length( Y)-1 ; %  delays for fitting ;

 ftype = fittype( 'lowess') ;  
         ftype = fittype( 'M/(1+((x-T)/w).^2)+O') ;  
         
  fresult = fit( tau_x' ,Y' , ftype ,'Lower',[1 ,-100 , -300 , - 1000],'Upper',...
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
                                      if Show_fit_plot 
                                          hold on
                                        plot( fresult, tau_x , M_of_tau )
                                         plot( tau_x , Y , 'r' )
                                        hold off
                                      end 
        %                               Connectiv_matrix_M_on_tau_Blocks( chi ,chj , : )= M_of_tau /   Total_Spike_Rates( chi ) ;
                                      tau_max = H( tau_max ) * tau_max ; 
                                      M_max = max( M_of_tau ) ;
                               end
                            end

  FF = Y - M_of_tau ;
  diff = sum( FF )/length( Y) ;





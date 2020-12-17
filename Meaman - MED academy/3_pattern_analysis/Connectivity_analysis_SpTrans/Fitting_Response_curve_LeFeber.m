 %---- LeFeber fitting ------------
 Fitting_Response_curve_LeFeber
 
                       % Input:
                       % M_of_tau_original , tau_x , Connectiv_data ,
                       % Total_Spike_Rates
                       % Output : tau_max , M_max , M_of_tau
                       
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
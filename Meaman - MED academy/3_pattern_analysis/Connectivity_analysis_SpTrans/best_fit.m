% best_fit

ftype = fittype( 'M/(1+((x-T)/w).^2)+O') ; 
% fitOptions = fitoptions( 'Method','NonlinearLeastSquares');
% fresult = fit( x' ,y , ftype ,'Lower',[1 ,-10 , -3000 , - 10000],'Upper',...
%                           [Inf,1000 , 3000 , 10000 ],'StartPoint',[1000 -5 0 3], 'MaxIter' , Connectiv_data.params.Fit_Max_iterations , ...
%                           fitOptions);
x1 = x(1:floor( length(x)/2 ));
y1 = y(1:floor( length(x)/2 ));
fresult = fit( x1' ,y1 , ftype , 'Lower',[1 ,-5000 , 0 , - 40], 'MaxIter' , 3000000 );      
% fresult = fit( x' ,y , ftype ,  'MaxIter' , 3000000 );       
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
 
   plot( fresult, x1 , y1 )   
   for x_i = 1 : length( x )
%        M_of_tau( x_i ) = fresult.M / ( 1+( ( x(x_i)-fresult.T )/ fresult.w ).^2)+ fresult.O ;
%        M_of_tau2( x_i ) = 3900 / ( 1+( ( x(x_i)-3 )/20 ).^2)+ -1000 ;
   end
   Tmax=fresult.T 
%    hold on
%    plot(   x , y )
%    plot(  x , M_of_tau2 , '-r')
%    
%    hold off
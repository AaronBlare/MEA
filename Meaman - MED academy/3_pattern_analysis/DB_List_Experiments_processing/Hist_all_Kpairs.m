
        % Hist_all_Kpairs
        % Input - Data_Kpairs , BINS_NUM 
        %
        % for k = 1 : Kpairs
        %    Data_Kpairs( k ).data = All_data_all_exp( k ).TOTAL_RATE(1).all_exp_diff_mean_ratio ;  
        % end
                 
                % if true - make hist using Bar
                 Bar_hist = false ; 
                 
                 sss= size( Data_Kpairs ) ;
                 
                 Max_fn = -1*100 * ones( sss(1) , 1);
                 Min_fn = +1*100 * ones( sss(1) , 1);
                 
                 for k = 1 : Kpairs
                     if sss(1)>= k
                         Max_fn( k ) = max( Data_Kpairs( k ).data ) ; 
                         Min_fn( k ) = min( Data_Kpairs( k ).data  ) ; 
                     end
                 end
                   
                 if BINS_NUM ~= 0 
                     xBIN = ( max( Max_fn ) - min( Min_fn ) ) / BINS_NUM ;
                 else
                    xBIN = BINS_fixed ;
                 end
                     
                     Min_xxx =min( Min_fn )-xBIN  ;
                     Max_xxx = max( Max_fn )+xBIN ;
                     if ~Bar_hist
                         Min_xxx=Min_xxx-xBIN ;
                         Max_xxx=Max_xxx + xBIN ;
                     end
                     if BINS_NUM == 0 
                        xxx = Min_xxx - mod( Min_xxx ,  xBIN ) : xBIN : Max_xxx ;  
                     else
                         xxx = Min_xxx  : xBIN : Max_xxx ;
                         xxx1 = xxx - mod( Min_xxx  , xBIN )  ; 
                         xxx1(1)/xBIN ;
                         xxx= xxx1  ;
                     end
                   
                 Hist_n = [];  
                 Hist_x_n = [] ;
                 for k = 1 : Kpairs
                     if sss(1)>= k
                         [n,x] = hist( Data_Kpairs( k ).data  , xxx);
                          n=100* n/ length( Data_Kpairs( k ).data   );
                          Hist_n = [ Hist_n n' ] ;
                          Hist_x_n= [Hist_x_n x' ];
                     end
                 end 
                        
%                         figure  
%                         subplot( 2,1,1);
%                         bar(  Hist_x_n  ,Hist_n , 1 ) 
                        if Bar_hist
                            bar(  Hist_x_n  , Hist_n ,1 ) 
                        else
                            plot(  Hist_x_n  ,Hist_n , 'LineWidth',2 )  
                        end
%                          
                        if Kpairs > 2
                            colormap hot 
                        else
                            colormap jet
                        end
                        
                        Hist_x_n_diap = max( max( Hist_x_n )) - min( min(Hist_x_n) ) ;
                        if  max( max(Hist_x_n))  > min( min(Hist_x_n) ) 
                        axis( [ min( min(Hist_x_n) ) - 0.05*Hist_x_n_diap ...
                                0.1*Hist_x_n_diap + max( max(Hist_x_n) ) 0  1.05*max( max( Hist_n )) ] )
                            
                        end
                            
                            
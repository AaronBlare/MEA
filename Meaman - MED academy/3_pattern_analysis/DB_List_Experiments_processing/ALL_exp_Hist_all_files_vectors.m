
        % ALL_exp_Hist_all_files_vectors 
                 
                % if true - make hist using Bar
                 Bar_hist = false ; 
                 BINS_NUM = var.All_exp_2d_data_Hist_bins_num  ;
                 
                 max_data_matrix = max( max( data_matrix )) 
                 data_matrix_size = size( data_matrix )
                 sss= size( data_matrix ) ;
                 
                 Max_fn = -1*100 * ones( sss(1) , 1);
                 Min_fn = +1*100 * ones( sss(1) , 1);
                 
                 for fi = 1 : files_num
                     if sss(1)>= k
                         Max_fn( k ) = max( data_matrix( : , fi )) ; 
                         Min_fn( k ) = min( data_matrix( : , fi  )) ; 
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
%                          xxx1(1)/xBIN ;
                         xxx= xxx1  ;
                     end
                   
                 Hist_n = [];  
                 Hist_x_n = [] ;
                 for fi = 1 : files_num
                     k = 2 ;
                     if sss(1)>= k
                         vector_for_hist = data_matrix( :, fi )  ;
                         vector_for_hist = vector_for_hist( ~isnan( vector_for_hist ) ) ; 
                         vector_for_hist( vector_for_hist== 0 ) = [] ; 
                         
%                          whos vector_for_hist  
                        if Test_data_for_jbtest( vector_for_hist ) && length( vector_for_hist ) > 3
                         [n,x] = hist( vector_for_hist , xxx);
                        
                          
                         if Normalize_hist 
                             n=100* n/ length( vector_for_hist ); 
                         else
                             n= n ;
                         end
                          Hist_n = [ Hist_n n' ] ;
%                           whos Hist_n
                          % convert to column
                          size_x = size( x );
                          if size_x(2) == 1
                              x = x' ;
                          end
                            whos x
                            whos Hist_x_n
                          Hist_x_n= [Hist_x_n x' ];
                        end
                     end
                 end 
                        
%                         figure  
%                         subplot( 2,1,1);
%                         bar(  Hist_x_n  ,Hist_n , 1 ) 
                        if Bar_hist
                            bar(  Hist_x_n  , Hist_n ,1 ) 
                        else
                            plot(  Hist_x_n  ,Hist_n , 'LineWidth', 1)  
                        end
%                          
                        if files_num > 2
                            colormap hot 
                        else
                            colormap jet
                        end
                        
                        Hist_x_n_diap = max( max( Hist_x_n )) - min( min(Hist_x_n) ) ;
                        if  max( max(Hist_x_n))  > min( min(Hist_x_n) ) 
                        axis( [ min( min(Hist_x_n) ) - 0.05*Hist_x_n_diap ...
                                0.1*Hist_x_n_diap + max( max(Hist_x_n) ) 0  1.05*max( max( Hist_n )) ] )
                            
                        end
                            
                    
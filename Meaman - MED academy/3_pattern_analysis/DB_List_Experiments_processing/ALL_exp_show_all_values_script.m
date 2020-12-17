% ALL_exp_show_all_values_script 


if isfield( var , 'data_2d_take_negative' )
data_2d_take_negative    = var.data_2d_take_negative ;
end

if isfield( var , 'data_2d_take_positive' )
data_2d_take_positive  = var.data_2d_take_positive ;
end


h_pict = [] ;
h_pict_Hists=[];
figi= 1;

fix_start_file = var.fix_start_file ;
Start_file = var.Start_file ; 
if var.End_Ctrl_file - Start_file > 0
End_Ctrl_file = var.End_Ctrl_file - fix_start_file ;  
End_file = End_Ctrl_file *2 ;
else
   End_Ctrl_file = 0 ;  
End_file = var.End_file  ; 
    
end

extract_data_files_list = var.Start_file + fix_start_file : var.End_file -  fix_start_file ;  
 
  
group1=  Start_file : End_Ctrl_file ;
group2 = End_Ctrl_file +1 : End_file ;
all_files_list = Start_file : End_file ;
files_num = End_file - Start_file +  fix_start_file;

State = var.State ;
Channel = var.Channel ;

Barplot_all_data = true ;
if isfield( var , 'Barplot_for_2d_data' )
    Barplot_for_2d_data =  var.Barplot_for_2d_data ;
    Barplot_all_data =  var.Barplot_for_2d_data  ;
end

Plot_data_each_file = var.Plot_data_each_file ; % Global_flags.Analyzed_Experiments_Plot_data_type ;
% 'Line-errorbar'  'Bar-errorbar' 'Boxplot' 'All data, meean'
% Plot_data_each_file = 'Bar-errorbar' ;

%  data_matrix( exp_num , file_number )
data2d_plot_num = 1 ;
for vi = 1 : length( Value_str_to_show )

    title_prefix_stat = '' ;
    title_prefix_stat2 = '' ;
     title_prefix=  ''  ;
     
    Value_str = Value_str_to_show{ vi }    
      loopIndex = strmatch( Value_str , All_exp_data_matrix.(Analysis_structure_fieldnames) );  
   if ~isempty( loopIndex )
      loopIndex = loopIndex(1);
      
      
            stst_diff_if_1 = Analysis_cell.cell_mean_total{  loopIndex , 11 , State , Channel   } ;
            title_prefix_stat = [ title_prefix_stat 'ctrl stable if 0= ' num2str( stst_diff_if_1 ) ] ;

            stst_diff_if_1 = Analysis_cell.cell_mean_total{  loopIndex , 9 , State , Channel   } ;
            title_prefix_stat = [ title_prefix_stat ', mean stable if 0= ' num2str( stst_diff_if_1 ) ] ;

            title_prefix_stat2 = '' ;
            stst_diff_if_1 = Analysis_cell.cell_mean_total{  loopIndex , 10 , State , Channel   } ;
            title_prefix_stat2 = [ title_prefix_stat2 ', var equal if 0= ' num2str( stst_diff_if_1 ) ] ; 

            stst_diff_if_1 = Analysis_cell.cell_mean_total{  loopIndex , 13 , State , Channel   } ;
            title_prefix_stat2 = [ title_prefix_stat2 ', multi mean equal if 0= ' num2str( stst_diff_if_1 ) ] ;    
      
      
      
      
      
      
      
      
      data_matrix = All_exp_data_matrix.(Analysis_structure_str)( : ,extract_data_files_list ,  loopIndex  );
        single_dat = data_matrix( 1 ) ;
        
 
            if strcmp(  Value_str , 'Channel_difference_increase_abs' )  
                data_matrix_size = size( data_matrix );
            end
        
      
      d=cellfun(@size, data_matrix  ,'uni',0);
      e=cell2mat(d);
      all_2d_data_equal_size =all( all(e==1) );
 
%------------------------------------------------------------   
      % if compare 1d values or compare vectors as means  
      if  length( cell2mat( single_dat)) == 1  || var.data2d_make_mean   
          
         % if each element is a vector then take mean of the vector
         if length( cell2mat( single_dat)) > 1     
              s = size( data_matrix ) ;
              data_matrix_d = zeros( s(1) , s(2) );
              for sy = 1:s(1)
                for sx = 1:s(2)
                   data_matrix_d( sy , sx ) = mean( cell2mat( data_matrix( sy,sx )));
                end 
              end
              data_matrix = mat2cell( data_matrix_d );
          end 
          data_matrix = squeeze( data_matrix );
          data_matrix = cell2mat( data_matrix ) ;
          
          
          data_matrix( abs( data_matrix ) == inf  ) = NaN ;

          if var.fix_start_file > 0 
    %       data_matrix( : , 1:var.fix_start_file ) = [] ;
    %       file_number_of_change = file_number_of_change - 1;
          end 

          data_matrix(isnan(data_matrix)) =  0 ;

              s = size( data_matrix ) ; 
              for sy = 1:s(1) 
                if var.data_pair_difference
                  data_matrix( sy , : ) = [0 diff( data_matrix( sy , : )/ data_matrix( sy , 1 ) ) ] ;
                end
                  
                if normalize_values
                    data_matrix( sy , : ) = 100 *data_matrix( sy , : )/ data_matrix( sy , 1 ) ;
    %                    calc difference from 1 
    %                 data_matrix( sy , : ) = data_matrix( sy , : ) - data_matrix( sy , 1 ) ;
                end
              end       

       %---Stat test 1st file to pre-stm, and post-stim

          

    %     if ALL_cell.Global_flags.file_number_of_change > 0 
            p = 0 ;
          if   End_Ctrl_file > 0 
            ctrl1 = data_matrix( : , 1  );

            pre_file_num = End_Ctrl_file ;
%             if strcmp( Analysis_structure_str , 'Comp_result_cell' ) 
%                 pre_file_num = End_Ctrl_file ;
%             end
            pre1 = data_matrix( : , pre_file_num  );
            post1 = data_matrix( : , pre_file_num+1  );

    %         end

            title_prefix=  'pre-ctrl,post-ctrl, '  ; 


            norm_test_all = [] ;
            if var.compare_diff_with_ctrl
            Datta1 = pre1 - ctrl1 ;
            Datta2 = post1 - ctrl1 ;
            else
               Datta1 = pre1   ;
               Datta2 = post1   ; 
            end

            Datta1=Datta1(isfinite(Datta1)) ;
            
            if length( Datta1 ) > 1
             h1_norm_if_0 = jbtest(  Datta1 ) ;
            else
             h1_norm_if_0 = 1 ;   
            end
             h1_norm_if_1 = h1_norm_if_0 == 0 ;
             norm_test_all = [ norm_test_all h1_norm_if_1 ] ;

             Datta2=Datta2(isfinite(Datta2)) ;
             if length( Datta1 ) > 1
             h1_norm_if_0 = jbtest(  Datta2 ) ;
            else
             h1_norm_if_0 = 1 ;   
             end  
             h1_norm_if_1 = h1_norm_if_0 == 0 ;
             norm_test_all = [ norm_test_all h1_norm_if_1 ] ;

                           if min(norm_test_all) == 1 
                               all_values_normaly_distib = true ;
                           else
                               all_values_normaly_distib = false ;
                           end

                           % Total_data( Exp_num , files_num ) - column = sample(all exp)                     
                           if all_values_normaly_distib
                               title_prefix = [title_prefix  'norm, ' ];
                               if length( Datta1 ) > 1 && length( Datta2 ) > 1
                                 [pre_post_diff_if_1  , p  ] = ttest( Datta1 , Datta2 ) ;
                               else
                                  p = 1 ; pre_post_diff_if_1 = 0 ; 
                               end
                           else 
                               title_prefix=  [title_prefix  'non-norm, ' ] ;
                               if length( Datta1 ) > 1 && length( Datta2 ) > 1                               
                                  [p , pre_post_diff_if_1 ]= signrank( Datta1 , Datta2  );        
                               else
                                  p = 1 ; pre_post_diff_if_1 = 0 ; 
                               end
                           end
          end


            title_prefix = [title_prefix  num2str( p ) ];
            if strcmp(  Value_str , 'Number_of_Connections_file2' )  
                mean( Datta1 )
                mean( Datta2 )
            end
         
            %--- Figures -------------------------------
            dx= 0.5 ;
            h = subplot( Ny , Nx , figi );
            figi 
            h_pict = [ h_pict h ] ;
            
            
            % plot data ===================================
            if var.show_hist % all data hist
                 
                 vector_for_hist = reshape(  data_matrix , [] , 1 )  ;
                 [Hist_n ,Hist_x_n ] = hist( vector_for_hist , var.All_exp_2d_data_Hist_bins_num);
                  Hist_n=100* Hist_n/ length( vector_for_hist ); 
                  xlabel( 'Change, %')
                  xlabel( 'Count, %')
                  
                  bar(  Hist_x_n  , Hist_n ,1 ) 
                        
            else                      
                if Barplot_all_data
                    
                    group = [repmat({'pre-ctrl'}, length( Datta1 ) , 1); repmat({'post-ctrl'}, length( Datta2 ) , 1) ];
                      boxplot(  [ Datta1 ; Datta2 ] , group );
                    labels_exs =   'pre-ctrl,post-ctrl'  ;

                else
                    
                    hold on
                    switch Plot_data_each_file
                        case 'Line-errorbar' 
                          plot( mean(data_matrix)  , 'LineWidth', 2 ); 
                          errorbar( mean(data_matrix) , std(data_matrix)  , 'bx' ) ;
                        case 'Bar-errorbar'  
                          barwitherr( std(data_matrix) , 1:s(1)   , mean(data_matrix) , 3 );
                        case 'Boxplot'  
                          boxplot( data_matrix ) ;
                        case 'All data, meean'
                          plot( data_matrix' , '*-', 'LineWidth', LD )
                          plot( mean(data_matrix) , '-k', 'LineWidth', 2 )
                          if vi == 1 
                            hleg1 = legend( legend_str , 'Location' ,'NorthWest');
                          end
                    end
                          
                          if End_Ctrl_file - Start_file > 0 
                             plot( [ End_Ctrl_file + dx End_Ctrl_file + dx  ] , [ 0.95* min(min(data_matrix)) ...
                                  1.05* max(max(data_matrix)) ], '--r', 'LineWidth', 2)
                          end
                       hold off
%                        if vi == 1 
%                           hleg1 = legend( legend_str , 'Location' ,'NorthWest');
%                        end
                %           set(hleg1,'Location','NorthWest');
                          xlabel( 'file #')
                          xlim( [  Start_file - dx End_file + dx ])  
                        
                           
                      
                end
            end
%                      ylabel( strrep(Value_str, '_', ' ') ) 
                      title( {[ strrep(Value_str, '_', ' ') ',' ];[ title_prefix ]; [title_prefix_stat] ; [title_prefix_stat2 ]} ) ;
            
                      figi = figi + 1 ;
            end
       

            
            %----------------------------------------------
            
%------------------------------------------------------------      
%------------------------------------------------------------      
%------------------------------------------------------------   
      % if compare 2d vectors   
      if  length( cell2mat( single_dat)) > 1   && ~var.data2d_make_mean   
          data_matrix = squeeze( data_matrix )  ;
          
          %--- compare vectors of equal size
                    d=cellfun(@numel, data_matrix  ,'uni',0);
                    e=cell2mat(d);
                    all_2d_data_equal_size =all( all(e==e(1)) );
       if all_2d_data_equal_size
          s_data_matrix_origin = size( data_matrix );  
          data_matrix = cell2mat( data_matrix ) ; 
          
          s=size( cell2mat( single_dat)  );
          s_single_dat=size( cell2mat( single_dat)  );
          % if each vector in data is row, then transpose
          if s(2) > s(1)
              single_dat = single_dat'; 
          end
          


          
%               data_matrix(isnan(data_matrix)) =  0 ;

              s = size( data_matrix ) ; 
              for sy = 1:s(1) 
                if normalize_values
%                     data_matrix( sy , : ) = 100 * data_matrix( sy , : )/ data_matrix( sy , 1 ) ;
                    df = data_matrix( sy , : ) - data_matrix( sy , 1 );
                    F =  data_matrix( sy , 1 ) ;
                    data_matrix( sy , : ) = 100 * df / F ;                    
                    
%                     a = find( data_matrix( : , : ) == NaN );
                    
%                     data_matrix(any(isnan(data_matrix),2),:)=[];
    %                    calc difference from 1 
    %                 data_matrix( sy , : ) = data_matrix( sy , : ) - data_matrix( sy , 1 ) ;
                end
              end 
              
          %+++++ Replace big values with NAN ++++
          Thresh_Nan_replace = var.Compare_vector_each_X_limit_val ;
          data_matrix( abs( data_matrix ) > Thresh_Nan_replace  ) = NaN ;       
          %=+++++++++++++++++++++++++++++++++++++
          data_matrix( abs( data_matrix ) <  var.Compare_vector_each_X_low_limit_val  ) = NaN ;
          %=+++++++++++++++++++++++++++++++++++++          
          %=+++++++++++++++++++++++++++++++++++++
          
          
              a = find( isnan( data_matrix ) == 1 );
                    data_matrix(  a ) = 0 ;
                    
                 
            if strcmp(  Value_str , 'Max_corr_delay_diff_vector' )  
                data_matrix_size = size( data_matrix );
                max_data_matrix = max( max( data_matrix )) ;
            end   
              
              
            %     if ALL_cell.Global_flags.file_number_of_change > 0 
          if   End_Ctrl_file > 0 
            ctrl1 = data_matrix( : , 1  );

            pre_file_num = End_Ctrl_file ;
%             if strcmp( Analysis_structure_str , 'Comp_result_cell' ) 
%                 pre_file_num = End_Ctrl_file ;
%             end
            pre1 = data_matrix( : , pre_file_num  );
            post1 = data_matrix( : , pre_file_num+1  );

    %         end

            title_prefix=  'pre-ctrl,post-ctrl, '  ; 
            labels_exs =   'pre-ctrl,post-ctrl'  ; 


            norm_test_all = [] ;
            if var.compare_diff_with_ctrl
            Datta1 = pre1 - ctrl1 ;
            Datta2 = post1 - ctrl1 ;
            else
               Datta1 = pre1   ;
                Datta2 = post1   ; 
            end
            
            if data_2d_take_negative                      
%                       Datta1 = Datta1( Datta1 < 0 );
%                       Datta2 = Datta2( Datta2 < 0 );
                      
                      
                    Datta1_new = [] ;
                    Datta2_new=[];
                    for i = 1 : s_data_matrix_origin( 1 )
                        i1 = (i-1) * s_single_dat(1) + 1 ;
                        i2 = (i) * s_single_dat(1)   ;
                        a=length( find(  Datta1( i1 : i2  ) < -var.Compare_vector_each_X_low_limit_val ) ) ;
                        Datta1_new  = [ Datta1_new  ; a ];
                        
                        b=length( find(  Datta2( i1 : i2  ) < -var.Compare_vector_each_X_low_limit_val ) ) ;
                        Datta2_new  = [ Datta2_new  ; b ];
                    end
                    Datta1  = Datta1_new ;
                    Datta2  = Datta2_new ;
            end
            
            if data_2d_take_positive                     
%                       Datta1 = Datta1( Datta1 > 0 );
%                       Datta2 = Datta2( Datta2 > 0 );
                      
                      Datta1_new = [] ;
                    Datta2_new=[];
                    for i = 1 : s_data_matrix_origin( 1 )
                        i1 = (i-1) * s_single_dat(1) + 1 ;
                        i2 = (i) * s_single_dat(1)  ;
                        a=length( find(  Datta1( i1 : i2  ) > var.Compare_vector_each_X_low_limit_val ) ) ;
                        Datta1_new  = [ Datta1_new  ; a ];
                        
                        b=length( find(  Datta2( i1 : i2  ) > var.Compare_vector_each_X_low_limit_val ) ) ;
                        Datta2_new  = [ Datta2_new  ; b ];
                    end
                    Datta1  = Datta1_new ;
                    Datta2  = Datta2_new ;
            end
            
                           Datta1_finite  = isfinite( Datta1 );
                           Datta1 = Datta1( Datta1_finite == 1 );
                           
                           Datta2_finite  = isfinite( Datta2 );
                           Datta2 = Datta2( Datta2_finite == 1 );
                           
               
            
            if length( Datta1 ) > 2 && length( Datta2 ) > 2
             h1_norm_if_0 = jbtest(  Datta1 ) ;
             h1_norm_if_1 = h1_norm_if_0 == 0 ;
             norm_test_all = [ norm_test_all h1_norm_if_1 ] ;

             h1_norm_if_0 = jbtest(  Datta2 ) ;
             h1_norm_if_1 = h1_norm_if_0 == 0 ;
             norm_test_all = [ norm_test_all h1_norm_if_1 ] ;
            

                           if min(norm_test_all) == 1 
                               all_values_normaly_distib = true ;
                           else
                               all_values_normaly_distib = false ;
                           end
                           


                           % Total_data( Exp_num , files_num ) - column = sample(all exp)                     
                           if all_values_normaly_distib && length( Datta1 ) > 2 && length( Datta2 ) > 2
                               title_prefix = [title_prefix  'norm, ' ];
                               if length( Datta1 ) == length( Datta2 ) 
                                  [pre_post_diff_if_1  , p  ] = ttest( Datta1 , Datta2 ) ;
                               else
                                  [pre_post_diff_if_1  , p  ] = ttest2( Datta1 , Datta2 ) ;
                               end
                           else 
                               title_prefix=  [title_prefix  'non-norm, ' ] ;
                               if length( Datta1 ) == length( Datta2 ) 
                                    [p , pre_post_diff_if_1 ]= signrank( Datta1 , Datta2  );     
                               else
                                    [p , pre_post_diff_if_1 ]= ranksum( Datta1 , Datta2  );     
                               end
                           end
            else
               p = 1 ; title_prefix = 'no data' ;
            end
          end
       end

            title_prefix = [title_prefix  num2str( p ) ]; 
               
              
          
            %--- Figures -------------------------------
            dx= 0.5 ; 
            legend_str_files = cell( files_num , 1);
            for fi = 1 : files_num
            legend_str_files{ fi } = [ 'File ' num2str( fi ) ] ;
            end
            
                  h_hist = subplot( Ny , Nx , figi );
                  h_pict_Hists = [ h_pict_Hists h_hist ] ;
                  hold on
                  Normalize_hist = true;
%                   Normalize_hist = false;
%                   Barplot_for_2d_data = true ;
                  
                  if Barplot_for_2d_data
                      
%                       % boxplot for median values in distrib
                      Datta1 = Datta1( ~isnan( Datta1 ));
                      Datta2 = Datta2( ~isnan( Datta2 )); 
                      
                      group = [repmat({'pre-ctrl'}, length( Datta1 ) , 1); repmat({'post-ctrl'}, length( Datta2 ) , 1) ];
                      boxplot(  [ Datta1 ; Datta2 ] , group );
% %                       barwitherr2( [std(Datta1) std(Datta2)] , [1 2]  , [mean(Datta1) mean(Datta2)] );                      

%                       Datta1 = numel( Datta1 );
%                       Datta2 = numel( Datta2 );
% %                       
%                       Bar( [ Datta1  Datta2 ] )
                        

                  else 
                     %-----------------------------------------
                      ALL_exp_Hist_all_files_vectors
                     %-----------------------------------------
                  end 
                      

                   hold off
                   if data2d_plot_num == 1 
                      hleg1 = legend( legend_str_files  , 'Location' ,'EastOutside' );
                   end
                   data2d_plot_num = data2d_plot_num +1 ;
            %           set(hleg1,'Location','NorthWest');
                      ylabel( 'distr')
                      xlabel( strrep(Value_str, '_', ' ') )
                      title( {[ strrep(Value_str, '_', ' ') ',' ];[ title_prefix ]; [title_prefix_stat] ; [title_prefix_stat2 ]} ) ;

                      figi = figi + 1 ;
            
                      %%

%             linkaxes( [ h_pict(:) ] , 'x' )
            %----------------------------------------------
          
      end
   end
end

    if  ~var.data2d_make_mean  
%       linkaxes( [ h_pict_Hists(:) ] , 'x' ) 
    end
      linkaxes( [ h_pict(:) ] , 'x' ) 
         

       
     
%----------------------------------










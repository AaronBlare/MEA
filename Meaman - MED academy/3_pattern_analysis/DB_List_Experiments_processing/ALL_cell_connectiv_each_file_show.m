%  ALL_cell_connectiv_each_file_show

f=figure ; 
            figure_title= 'Connectivity' ;
             set(f, 'name',  figure_title ,'numbertitle','off' )  
             
         stim_channels = zeros( N ,1 ) ;
                if ~isempty( Global_flags.Analyze_selected_channels  )
                    stim_channels( Global_flags.Analyze_selected_channels ) = 1 ;
                
                    h = subplot( Ny , Nx , 1 );                      
                   h_pict = Plot8x8Data( stim_channels , false );      
                   title( 'Stim channels')
                end
                
         for fi = 1 : N_filess
           Connectiv_matrix_tau_of_max_M = ALL_cell.Connectiv_data( fi  ).Connectiv_matrix_tau_of_max_M  ;
           Connectiv_matrix_max_M = ALL_cell.Connectiv_data( fi  ).Connectiv_matrix_max_M  ;
            
               N = numel( Channel_difference_mean  );
                
            h = subplot( Ny , Nx , fi +1 );         
            
             var= []; 
              var.Connectiv_matrix_max_M = Connectiv_matrix_max_M ;
             var.new_figure = false ;
             var.calc_bidirection = true ;
             var.background_1d_vector = false ;
             var.background_2d_data = Connectiv_matrix_max_M ;
             Connectiv_data2 = Connectiv_Post_proc( Connectiv_matrix_tau_of_max_M , var) ;
               
               title( num2str( fi ) ) 
         end
         
         
         
         
         
         
         
         
         
         
         
%          h = subplot( Ny , Nx , fi +2 );  
         figure
         subplot( Ny - 1 , Nx , 1 );
         Plot8x8Data( zeros( 1,N) , false , false )
         thresholds.max = 0 ;
         thresholds.min = 0 ;
         thresholds2.max = 0 ;
         thresholds2.min = 0 ;
         
         Show_values_type = 2  ;
         
         Diff_val_all_mean = [] ; 
         Diff_val_all_num = [] ;
         Diff_val_all2_mean = [] ;
         
         for fi = 1 : N_filess-1 
           subplot( Ny - 1 , Nx , fi + 1 );  
          
         Plot8x8Data( zeros( 1,N) , false , false )
         hold on 
         
         f = Global_flags.file_number_of_change ;
         
         Connectiv_matrix_ctrl = ALL_cell.Connectiv_data( 1    ).Connectiv_matrix_tau_of_max_M  ;
         Connectiv_matrix_post = ALL_cell.Connectiv_data( fi   +1  ).Connectiv_matrix_tau_of_max_M  ;
         Connectiv_matrix_diff = Connectiv_matrix_post - Connectiv_matrix_ctrl ;
         
         Connectiv_matrix_str_ctrl = ALL_cell.Connectiv_data( 1    ).Connectiv_matrix_max_M  ;
         Connectiv_matrix_str_post = ALL_cell.Connectiv_data( fi   +1  ).Connectiv_matrix_max_M  ;
         Connectiv_matrix_str_diff = Connectiv_matrix_str_post - Connectiv_matrix_str_ctrl ;
  
         max_diff_val = 1.02 * max( max( (Connectiv_matrix_diff ))) 
         min_diff_val  = 1.02 * min( min( (Connectiv_matrix_diff ))) 
          
%          max_diff_val = -50 ;
%          min_diff_val = 50 ;
         
         max_diff_val2 = 1.01 * max( max( (Connectiv_matrix_str_diff ))) 
         min_diff_val2  = 1.01 * min( min( (Connectiv_matrix_str_diff ))) 
         
         
         if fi <= f
            thresholds.max =  max(  (max_diff_val) ,  thresholds.max )   ;
            thresholds.min =  min(  (min_diff_val) ,  thresholds.min )   ;
            
            thresholds2.max =  max(  (max_diff_val2) ,  thresholds2.max )   ;
            thresholds2.min =  min(  (min_diff_val2) ,  thresholds2.min )   ;
         end
%          max_diff_val2 = 0.9 ;
%          min_diff_val2 = -0.9 ;
%          max_diff_val = 12 ;
         
         Thr_max = 8 ;
         Thr_min = - Thr_max ;
         Thr_max2 = 0.04 ;
         Thr_min2 = -Thr_max2 ; 
         
%          if fi <= f
%             Thr_max =  thresholds.max ;
%             Thr_min =  thresholds.min ;
%             Thr_max2 =  thresholds2.max ;
%             Thr_min2 =  thresholds2.min ; 
%          else  
%          end
         
         load( 'MEAchannel2dMap.mat');   
         cmap = colormap; 
         nclr = size(cmap,1);
         
         Diff_val_all = [] ; 
         Diff_val_all2 = [] ; 
         
         for i = 1 : N
            [x,y] = meshgrid(1:N,1:N);
            arrow=0.40;
            scalelength = 1;
            for j=1: N

                if Show_values_type == 1 
                   current_val =    Connectiv_matrix_diff( i , j)  ; 
                   Curr_thr_max = Thr_max ;
                   Curr_thr_min = Thr_min  ;
                else
                   current_val  =   Connectiv_matrix_str_diff( i , j);  
                   Curr_thr_max = Thr_max2 ;
                   Curr_thr_min = Thr_min2 ;
                end
%               if  abs( Connectiv_matrix_diff( i , j)) > Thr_delay
%               if  ( Connectiv_matrix_str_diff( i , j)) > Thr_str_delay   
%                 if  ( Connectiv_matrix_diff( i , j)) > Thr_max  || ...
%                     ( Connectiv_matrix_diff( i , j)) < Thr_min 
                if  current_val > Curr_thr_max || ...
                    current_val < Curr_thr_min
%                 if  ( Connectiv_matrix_str_diff( i , j)) > Thr_max2
                     
                  Diff_val_all = [ Diff_val_all current_val ] ; 
                  xstart = MEA_channel_coords( i ).chan_X_coord  ;  
                  ystart =  MEA_channel_coords( i ).chan_Y_coord ;    
                  
                  xend = MEA_channel_coords( j ).chan_X_coord   ;    
                  yend = MEA_channel_coords( j ).chan_Y_coord  ;  
                  
                  [th,val2  ] = cart2pol( [  xend - xstart ],[  yend - ystart ]);
                   
                  u=1;
                  v=1;
 
 % Get x coordinates of each vector plotted
              lx = [xstart; ... 
                   xend   ];

              % Get y coordinates of each vector plotted
              ly = [ystart; ... 
                   yend ];
 
              % Plot the vectors
%               line(lx,ly,'Color',cmap(i,:),'LineWidth',2);
%                 line(lx,ly, 'LineWidth',2);
%                 arrow(lx,ly ) 
            if Show_values_type == 1 
                ci = floor( ( (current_val  - min_diff_val) / (max_diff_val -min_diff_val) ) *  nclr ) + 1  ;
            else
                ci  = floor( ( (current_val  - min_diff_val2) / (max_diff_val2 -min_diff_val2) ) *  nclr ) + 1  ;
            end
                 quiver( xstart , ystart , xend - xstart , yend - ystart  ,  ...
                'LineWidth',2 , 'Color' , cmap(ci     ,:) )  ;
              end
         end         
         
         end
         
        Diff_val_all_mean = [ Diff_val_all_mean mean( Diff_val_all ) ] ;
%         Diff_val_all2_mean = [ Diff_val_all2_mean mean( Diff_val_all2 ) ] ;
        Diff_val_all_num = [ Diff_val_all_mean length( Diff_val_all ) ] ;

         
         
%          figure
%          hist( Diff_delays_all , 20 )
         
         end
         
         figure
             subplot( 1 , 2 ,1 )
             bar( Diff_val_all_mean )
             title( 'Diff val all mean')
             
             subplot( 1 , 2 , 2 )
             bar( Diff_val_all_num )
             title( 'Diff val all num')
        
         
         
         
         

%-- Connectiv_compare_results_show
function ALL_cell_TotalRate_compare_results_show( ALL_cell ,   Global_flags , var)

ex_n=1;

Nx = 3 ; Ny = 3 ;
fi = 1 ;
DN = 5 ;

old_show = false ;
Cmp_type_num  = var.Cmp_type_num ;
Data_type = var.Conp_type_data_type ;

figure_title = [ 'Compare sequence = ' num2str( Cmp_type_num ) ', Compare type = ' num2str( Data_type ) ] ;

 Value_str_to_show_Comp_result_TOTAL_RATE_cell = ...
     { 'psth_diff_precent' , 'Channel_difference_mean_one_value' , 'Channel_difference_mean_ratio_one_value' , ...
     'Channel_difference_increase_abs' , ...
     'Channel_difference_decrease_abs' , 'Mean_distance_burst_activation_mean' , ...
     'Mean_distance_burst_activation_2_mean' ,  ...
     'Mean_distance_burst_activation_3_smooth_1ms_mean' , 'Mean_distance_Spike_Rates_each_channel_mean' ...
                };

ex_list = 1 : Global_flags.Files_in_exeperiment   ;
ex_list_ctrl_data = 1 : Global_flags.file_number_of_change   ;
ex_list_ctrl_data_from2nd = 1 : Global_flags.file_number_of_change - 1 ;
n_files = Global_flags.Files_in_exeperiment - 1;


Default_StatAsterix = '()' ;

ctrl_exp_bar_color = 'b' ;
if Global_flags.file_number_of_change  > 0
    all_bar_color = 'r' ;
else
    all_bar_color = 'b' ;
end


 Name_index = strmatch( 'Statistical_ANALYSIS' , ALL_cell.Analysis_data_cell_field_names  ) ;
 mean_burst_parameters =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index(1) )' ); 
 mean_burst_parameters = mean_burst_parameters';
           
% Comp_result_TOTAL_RATE_cell

           f=figure ; 
             set(f, 'name',  figure_title ,'numbertitle','off' )  
             h_pict = [] ; 
            figi= 1;
             
for vi = 1 : length( Value_str_to_show_Comp_result_TOTAL_RATE_cell )
    
     Value_str = Value_str_to_show_Comp_result_TOTAL_RATE_cell{ vi }  ; 
  
           Name_index = strmatch( Value_str , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           Name_index = Name_index(1);
           dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) );
           
           h = subplot( Ny , Nx , figi );
           h_pict = [ h_pict h ] ;
            hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )   
%                     bar( EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )  
                end
                hold off
%                 xlim( [   1  n_files + 1  ] )
                xlabel( 'File number' ) 
%                 ylabel( strrep(Value_str, '_', ' ') )
                title(  strrep(Value_str, '_', ' ') )        
            figi = figi + 1 ;
            %-------------------------------------------------------      
    
    
    
    
end
 linkaxes( [ h_pict(:) ] , 'x' ) 
 
 %-- Show spatial effects --------------------------------- 
 if 2 > 1
         if Cmp_type_num == 2 && Data_type == 1 
             
         Value_str_to_show_in_comp  = {  'Channels_overlap' ,  ...
             'Channel_difference_mean_ratio' , 'Channel_difference_mean'  } ;
         
          
%              Nx = 3  ; Ny = 2 ;
               Nx = ceil( sqrt( n_files ));
              Ny = Nx ; 
              if Nx + Ny < n_files
                  Ny = Ny + 1 ;
              end
              
              
         for str_i = 1 : numel( Value_str_to_show_in_comp ) 
             Value_str_to_show_in_comp_i = Value_str_to_show_in_comp{ str_i } ;    
             

             
            f=figure ; 
            figure_title= Value_str_to_show_in_comp{ str_i } ;
             set(f, 'name',  figure_title ,'numbertitle','off' )  
             
             h_pict = [] ; 
            figi= 1;
            
 
%            Channel_difference_mean_ratio  Channels_overlap
           Name_index = strmatch( Value_str_to_show_in_comp_i  , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE , 'exact') ; 
           Name_index = Name_index(1);    
           dat = ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) ;
           dat1 = dat( ex_list_ctrl_data(end)-1  ) ;
           N_filess = numel( dat )
           for fi = 2 : N_filess
           Channel_difference_mean  = cell2mat(  dat( fi  ) ); 
           Channel_difference_mean( abs(Channel_difference_mean)>100 ) = 0 ;  
           
       
               N = numel( Channel_difference_mean  );
               stim_channels = zeros( N ,1 ) ;
                if ~isempty( Global_flags.Analyze_selected_channels  )
                    stim_channels( Global_flags.Analyze_selected_channels ) = 1 ;
                
                    h = subplot( Ny , Nx , 1 );                      
                   h_pict = Plot8x8Data( stim_channels , false );      
                   title( 'Stim channels')
                end
        
               
            h = subplot( Ny , Nx , fi  );                      
               h_pict = Plot8x8Data( Channel_difference_mean  , false );  
                
               
               title( num2str( fi ) ) 
           end
        
         end
         
         
         %----------- Connectivity each file ---------------------------
         ALL_cell_connectiv_each_file_show
         %=---------------------
         
         end
 end
 %-------------------------------------------------------
 
 if 1 > 2 % show gignatures of bursts and max cor delays of channel burst profile

        Nx = 3  ; Ny = 2 
        f=figure ; 
             set(f, 'name',  figure_title ,'numbertitle','off' )  
             h_pict = [] ; 
            figi= 1;
            
           
            Name_index = strmatch( 'Spike_Rate_Signature_diff'  , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           Name_index = Name_index(1);
           dat = ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) ;
           dat1 = dat( ex_list_ctrl_data(end) ) ;
           Spike_Rate_Signature_diff_ctrl_pre = cell2mat( dat1 ); 
           dat2 = dat( ex_list_ctrl_data(end) + 1 ) ;
           Spike_Rate_Signature_diff_pre_post = cell2mat( dat2 ); 
           
           Name_index = strmatch( 'DT_bin'  , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           Name_index = Name_index(1);
           DT_bin = cell2mat( ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) );  
           DT_bin = 10 ;
 h = subplot( Ny , Nx , 1 );           
            image_h =  plot_burst_signature(  Spike_Rate_Signature_diff_ctrl_pre  ,  DT_bin )
             
 h = subplot( Ny , Nx , 2 );          
            image_h =  plot_burst_signature(  Spike_Rate_Signature_diff_pre_post  ,  DT_bin )
            
    

            Name_index = strmatch( 'Spike_Rate_Signature_1ms_smooth_diff'  , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           Name_index = Name_index(1);
           dat = ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) ;
           dat1 = dat( ex_list_ctrl_data(end) ) ;
           Spike_Rate_Signature_diff_ctrl_pre = cell2mat( dat1 ); 
           dat2 = dat( ex_list_ctrl_data(end) + 1 ) ;
           Spike_Rate_Signature_diff_pre_post = cell2mat( dat2 ); 
           
   h = subplot( Ny , Nx , 3 );           
            image_h =  plot_burst_signature(  Spike_Rate_Signature_diff_ctrl_pre  ,  1 )
   h = subplot( Ny , Nx , 4 );          
            image_h =  plot_burst_signature(  Spike_Rate_Signature_diff_pre_post  ,  1 )

            
           Name_index = strmatch( 'Spike_Rate_1ms_smooth_Max_corr_delay_diff'  , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           Name_index = Name_index(1);
           dat = ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) ;
           dat1 = dat( ex_list_ctrl_data(end) ) ;
           Spike_Rate_1ms_smooth_Max_corr_pre = cell2mat( dat1 ); 
           dat2 = dat( ex_list_ctrl_data(end) + 1 ) ;
           Spike_Rate_1ms_smooth_Max_corr_post = cell2mat( dat2 ); 
           
           s=size( Spike_Rate_1ms_smooth_Max_corr_pre ) ;
            x=1: s( 2) ; y = 1:s( 1);
               
   h = subplot( Ny , Nx , 5 );           
           bb= imagesc(  x    , y ,  Spike_Rate_1ms_smooth_Max_corr_pre  ); 
           title( 'Max corr delay, ctr-pre' )     
           colorbar
   h = subplot( Ny , Nx , 6 );          
           bb= imagesc(  x    , y ,  Spike_Rate_1ms_smooth_Max_corr_post  ); 
           title( 'Max corr delay, pre-post' )    
            colorbar
            
 end
 
 
 
 
 
 
 
 
 
 
 
 
 
 

  if old_show         
           h01 = subplot(Ny,Nx, fi+0 );
           
           Value_str = 'Channel_difference_mean_one_value'; 
           Name_index = strmatch( Value_str , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) );
           
            hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )   
%                     bar( EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )  
                end
                hold off
                
                xlabel( 'File number' )
                ylabel('Channel_difference_mean, spikes')
                title( Value_str )        
           
            %-------------------------------------------------------                                      
           h3 = subplot(Ny,Nx, fi+   1 );
           
           
           Value_str = 'Channel_difference_mean_ratio_one_value'; 
           Name_index = strmatch( Value_str , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) );
           
            hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )   
%                     bar( EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )  
                end
                hold off
                
                xlabel( 'File number' )
                ylabel('Channel_difference_mean ratio, %')
                title( Value_str )  
          %-------------------------------------------------------                                            
           h4 = subplot(Ny,Nx, fi+ 2 );
           
           
           Value_str = 'Selective_electrodes_lin_div_precent'; 
           Name_index = strmatch( Value_str , ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_Names_TOTAL_RATE  ) ; 
           dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_TOTAL_RATE_cell(: , Name_index ) );
           
            hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )   
%                     bar( EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )  
                end
                hold off
                
                xlabel( 'File number' )
                ylabel('Selective_electrodes_lin_div_precent, %')
                title( Value_str )      
          
          
          
  end 
          
          
          
          
                  
                      
                      
                      
                      
                      
                      
                      
                      
                      
            
                
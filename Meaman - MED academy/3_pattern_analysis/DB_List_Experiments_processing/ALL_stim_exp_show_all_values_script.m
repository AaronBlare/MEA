
%   ALL_stim_exp_show_all_values_script

%  Analysis_data_TOTAL_RATE
% Analysis_data_T_act
% Analysis_data_SpikeRate
%   Analysis_data_cell

% Analysis_data_cell_field_names

h_pict = [] ;
h_pict_Hists=[];
figi= 1;
   

ssize = size(    ALL_cell.Analysis_data_cell );
 files_num = ssize(1) ; 
 

 
 %======= Figure 1 =============
 MEAN = [] ;
 STD = [] ;

    
    Value_str = 'total_number_of_active_electrodes' ; 
    loopIndex = strmatch( Value_str , ALL_cell.Analysis_data_TOTAL_RATE_names );  
    dat_mean  = Analysis_cell.Analysis_data_TOTAL_RATE.cell_mean_total{  loopIndex(1) , 3    } ;
    dat_std  = Analysis_cell.Analysis_data_TOTAL_RATE.cell_mean_total{  loopIndex(1) , 5    } ;
    MEAN = [ MEAN dat_mean ];
    STD = [ STD dat_std ] ;
 
    Value_str = 'Stat_selective_electrodes_num' ; 
    loopIndex = strmatch( Value_str , ALL_cell.Analysis_data_TOTAL_RATE_names );  
    dat_mean  = Analysis_cell.Analysis_data_TOTAL_RATE.cell_mean_total{  loopIndex(1) , 3    } ;
    dat_std  = Analysis_cell.Analysis_data_TOTAL_RATE.cell_mean_total{  loopIndex(1) , 5    } ;
    MEAN = [ MEAN dat_mean ];
    STD = [ STD dat_std ] ;

   Value_str = 'Stat_selective_channels_num' ; 
    loopIndex = strmatch( Value_str , ALL_cell.Analysis_data_T_act_names );  
    dat_mean  = Analysis_cell.Analysis_data_T_act.cell_mean_total{  loopIndex(1) , 3    } ;
    dat_std  = Analysis_cell.Analysis_data_T_act.cell_mean_total{  loopIndex(1) , 5    } ;
    MEAN = [ MEAN dat_mean ];
    STD = [ STD dat_std ] ;   
    
    
 figure
    Ny = 1 ; Nx = 3 ;
     barwitherr( STD , 1:length( STD )  , MEAN );
     title( 'active electrode')
     
%======= Figure 2 =============     
   Value_str_to_show  = {  'countsTOTAL_RATE_Overlaps_lin_div' , 'countsTact_Overlaps_lin_div' ,...
        'countsSPIKE_RATE_OVERLAPS', 'countsFirstBIN_SPIKERATE_OVERLAPS' , 'SPIKE_RATE_optimal_tbin_OVERLAPS' };
    
    MEAN = [] ;
    STD = [] ;
    Value_str = 'xTact_Overlaps' ; 
    loopIndex  = strmatch( Value_str , ALL_cell.Analysis_data_cell_field_names );  
    dat_mean_x  = Analysis_cell.cell_mean_total{  loopIndex(1)  , 3    } ;
    X = [] ;
    
      for vi = 1 : length( Value_str_to_show )
 
        Value_str = Value_str_to_show{ vi }    
        loopIndex  = strmatch( Value_str , ALL_cell.Analysis_data_cell_field_names );  
        dat_mean  = Analysis_cell.cell_mean_total{  loopIndex(1)  , 3    } ;
        dat_std =  Analysis_cell.cell_mean_total{  loopIndex(1)  , 5    } ;
        MEAN = [ MEAN dat_mean ];
        STD = [ STD dat_std ] ;
        dat_mean_x = dat_mean_x + 2;
        X = [ X dat_mean_x ] ;
      end 
    
   figure  
%    bar(  dat_mean_x , MEAN ) ;
   errorbar( X , MEAN , STD )
    legend( 'TOTAL_RATE' , 'Tact' , 'SPIKE_RATE' , ' FirstBIN OVERLAPS' , ' optimal tbin OVERLAPS'  )
%========================
 
 
 %======= Figure 3 =============     
   Value_str_to_show  = {  'countsTOTAL_RATE_Overlaps_lin_div_bin2' , 'countsTact_Overlaps_lin_div_bin2' ,...
        'countsSPIKE_RATE_OVERLAPS_bin2', 'countsFirstBIN_SPIKERATE_OVERLAPS_bin2' , 'SPIKE_RATE_optimal_tbin_OVERLAPS_bin2' };
    
    MEAN = [] ;
    STD = [] ;
    Value_str = 'xTact_Overlaps_bin2' ; 
    loopIndex  = strmatch( Value_str , ALL_cell.Analysis_data_cell_field_names );  
    dat_mean_x  = Analysis_cell.cell_mean_total{  loopIndex(1)  , 3    } ;
    X = []
      for vi = 1 : length( Value_str_to_show )
 
        Value_str = Value_str_to_show{ vi }    
        loopIndex  = strmatch( Value_str , ALL_cell.Analysis_data_cell_field_names );  
        dat_mean  = Analysis_cell.cell_mean_total{  loopIndex(1)  , 3    } ;
        dat_std =  Analysis_cell.cell_mean_total{  loopIndex(1)  , 5    } ;
        MEAN = [ MEAN dat_mean ];
        STD = [ STD dat_std ] ;
        X = [ X dat_mean_x ] ;
      end 
    
   figure  
%    bar(  dat_mean_x , MEAN ) ;
   errorbar( X , MEAN , STD )
   legend( 'TOTAL_RATE' , 'Tact' , 'SPIKE_RATE' , ' FirstBIN OVERLAPS' , ' optimal tbin OVERLAPS'  )
 %========================
 
%======= Figure 3 =============

     
 
  Value_str_to_show  = { 'psth_diff_precent' , 'Centroid_Error_precent' , 'Clustering_error_precent_KMEANS' ,...
        'SVM_accuracy' };
 
    Value_str_to_show_Tact  = { 'Tact_Intersimilarity_Dissimilar_patterns_precent' , 'Tact_Centroid_Error_precent' , ...
        'Tact_Clustering_error_precent_KMEANS' ,...
        'SVM_accuracy' };

       
     figure_title = 'Figure 3' ;
    f=figure ;
    set(f, 'name',  figure_title ,'numbertitle','off' ) 
    Nx = 4 ; Ny = 2  ;  
    
    for vi = 1 : length( Value_str_to_show )
 
        Value_str = Value_str_to_show{ vi } 
        loopIndex = strmatch( Value_str , ALL_cell.Analysis_data_TOTAL_RATE_names );  
        dat_mean  = Analysis_cell.Analysis_data_TOTAL_RATE.cell_mean_total{  loopIndex(1) , 3    } ;
        dat_std  = Analysis_cell.Analysis_data_TOTAL_RATE.cell_mean_total{  loopIndex(1) , 5    } ;
        
        all_data  = ALL_cell.Analysis_data_TOTAL_RATE( : , loopIndex(1)     );
        all_data = cell2mat( all_data );
        
        h = subplot( Ny , Nx , vi );
            h_pict = [ h_pict h ] ;
%         barwitherr( dat_std , 1:length( dat_std )  , dat_mean );

%         errorbar( dat_mean ,  dat_std )
%         ylim( [ 0 dat_mean + 1.5* dat_std ])

        hist( all_data , 20 )
         title( Value_str )    
    end
    
    %---- Tact data
    df = length( Value_str_to_show ) ;
    for vi = 1 : length( Value_str_to_show_Tact )
 
        Value_str = Value_str_to_show_Tact{ vi } 
        loopIndex = strmatch( Value_str , ALL_cell.Analysis_data_T_act_names );  
%         dat_mean  = Analysis_cell.T_act.cell_mean_total{  loopIndex(1) , 3    } ;
%         dat_std  = Analysis_cell.T_act.cell_mean_total{  loopIndex(1) , 5    } ;
        
        all_data  = ALL_cell.Analysis_data_T_act( : , loopIndex(1)     );
        all_data = cell2mat( all_data );
        
        h = subplot( Ny , Nx , df + vi );
            h_pict = [ h_pict h ] ;
%         barwitherr( dat_std , 1:length( dat_std )  , dat_mean );

%         errorbar( dat_mean ,  dat_std )
%         ylim( [ 0 dat_mean + 1.5* dat_std ])

        hist( all_data , 20 )
         title( Value_str )    
    end
%----------------------------------





























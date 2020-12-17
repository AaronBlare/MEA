%  Compare_TET_connectivity
    

Data_type = 2 ;
Cmp_type_num = 1 ;
Connectiv_analyze_AB_show_figures = false ;

        bursts_absolute = Patterns1.bursts_absolute ; 
       Spike_Rates  = Patterns1.Spike_Rates;
       Spike_Rates_each_channel_mean = Patterns1.Spike_Rates_each_channel_mean ; 
       Connectiv_data.params.show_figures = true ;
       Nb = length( bursts_absolute ) ;
         Patterns_analysis_connectivity 
        % >>> Input: bursts or bursts_absolute , Spike_Rates  
        % Output >>>: 
        % Connectiv_data struct : 
        
         Stim_resp_Connectiv_analyze_AB
% input Connectiv_data struct :POST_STIM_RESPONSE
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24   ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [  51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes

% find number of connections
 tau_all = reshape(  Connectiv_data.Connectiv_matrix_tau_of_max_M , [] ,1 );
    tau_all( tau_all == 0 ) = [] ;
    Connectiv_data.Number_of_Connections = length( tau_all ) ;
    
% Leave on connections between chambers 
if Global_flags.Connectiv_Only_between_chanbers
    tau_all = reshape( Connectiv_data_AB_tau , [] ,1 );
    tau_all( tau_all == 0 ) = [] ;
    Connectiv_data.Number_of_Connections = length( tau_all ) ;
        Connectiv_data.Connectiv_matrix_max_M  = Connectiv_data_AB_M ;
        Connectiv_data.Connectiv_matrix_tau_of_max_M = Connectiv_data_AB_tau ;
end
        
        Patterns1.Connectiv_data = Connectiv_data ;
        
        
       bursts_absolute = Patterns2.bursts_absolute ; 
       Spike_Rates  = Patterns2.Spike_Rates;
       Spike_Rates_each_channel_mean = Patterns2.Spike_Rates_each_channel_mean ; 
       Nb = length( bursts_absolute ) ;
       Connectiv_data.params.show_figures = false ;
         Patterns_analysis_connectivity 
        % >>> Input: bursts or bursts_absolute , Spike_Rates  
        % Output >>>: 
        % Connectiv_data struct :
        
         Stim_resp_Connectiv_analyze_AB
% input Connectiv_data struct :POST_STIM_RESPONSE
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24   ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [  51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes

% find number of connections
 tau_all = reshape(  Connectiv_data.Connectiv_matrix_tau_of_max_M , [] ,1 );
    tau_all( tau_all == 0 ) = [] ;
    Connectiv_data.Number_of_Connections = length( tau_all ) ;
    
% Leave on connections between chambers     
if Global_flags.Connectiv_Only_between_chanbers 
    tau_all = reshape( Connectiv_data_AB_tau , [] ,1 );
    tau_all( tau_all == 0 ) = [] ;
    Connectiv_data.Number_of_Connections = length( tau_all ) ;
        Connectiv_data.Connectiv_matrix_max_M  = Connectiv_data_AB_M ;
        Connectiv_data.Connectiv_matrix_tau_of_max_M = Connectiv_data_AB_tau ;
end
        Patterns2.Connectiv_data = Connectiv_data ;
        
 % compare 2 connectiv structs :
        Comp_result = Connectiv_Compare_2_connectiv_data( Patterns1.Connectiv_data , Patterns2.Connectiv_data , [] , ...
                [] , [] , Global_flags );
            
            Comp_result1 = Comp_result ;
        Comp_result_Names = fieldnames(  Comp_result )  ;  
         Comp_result_cell =  struct2cell(  Comp_result ) ;
         ALL_cell.Comp_type( 1 , Data_type ).Comp_result = [];
        ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell = [];
        ALL_cell.Comp_type( 2 , Data_type ).Comp_result = [];
        ALL_cell.Comp_type( 2 , Data_type).Comp_result_cell = [];
        
         ALL_cell.Comp_type( 1 , Data_type ).Comp_result_cell = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell ; Comp_result_cell' ] ; 
         ALL_cell.Comp_type( 1 , Data_type).Comp_result = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result ; Comp_result' ] ;    
         ALL_cell.Comp_type( 1 , Data_type).Comp_result_Names =   Comp_result_Names ;   
        
    if Global_flags.Use_3_files
       bursts_absolute = Patterns3.bursts_absolute ; 
       Spike_Rates  = Patterns3.Spike_Rates;
       Spike_Rates_each_channel_mean = Patterns3.Spike_Rates_each_channel_mean ; 
       Nb = length( bursts_absolute ) ;
         Patterns_analysis_connectivity 
        % >>> Input: bursts or bursts_absolute , Spike_Rates  
        % Output >>>: 
        % Connectiv_data struct :
        
        
        Stim_resp_Connectiv_analyze_AB
% input Connectiv_data struct :POST_STIM_RESPONSE
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24   ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [  51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes

% find number of connections
 tau_all = reshape(  Connectiv_data.Connectiv_matrix_tau_of_max_M , [] ,1 );
    tau_all( tau_all == 0 ) = [] ;
    Connectiv_data.Number_of_Connections = length( tau_all ) ;
    
% Leave on connections between chambers 
if Global_flags.Connectiv_Only_between_chanbers
    tau_all = reshape( Connectiv_data_AB_tau , [] ,1 );
    tau_all( tau_all == 0 ) = [] ;
    Connectiv_data.Number_of_Connections = length( tau_all ) ;
        Connectiv_data.Connectiv_matrix_max_M  = Connectiv_data_AB_M ;
        Connectiv_data.Connectiv_matrix_tau_of_max_M = Connectiv_data_AB_tau ;
end 
        Patterns3.Connectiv_data = Connectiv_data ;
       
   % compare 2 connectiv structs :
        Comp_result = Connectiv_Compare_2_connectiv_data( Patterns1.Connectiv_data , Patterns3.Connectiv_data , [] , ...
                [] , [] , Global_flags );
            
         Comp_result2 = Comp_result ;   
        Comp_result_Names = fieldnames(  Comp_result )  ;  
         Comp_result_cell =  struct2cell(  Comp_result ) ;
         ALL_cell.Comp_type( 1 , Data_type ).Comp_result_cell = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell ; Comp_result_cell' ] ; 
         ALL_cell.Comp_type( 1 , Data_type).Comp_result = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result ; Comp_result' ] ;    
        
 % show comp results   
 Comp_result_SNames2 = { 'Number_of_common_Connections', ...
                        'Mean_M_abs_difference_common_connections' , ...
              'New_Diss_connes_percent_of_1s_file', ...           
             'New_conns_percent_of_1st_file' , ...
              'Dissapeared_conns_percent_of_1st_file' , ...
             'Mean_M_abs_difference_unstable_connections' , ...
             'Mean_tau_max_difference_common_connections' , ...
              'New_conns_mean_delay' , ...
              'Mean_tau_max_both_files' };
          
%             Comp_result_SNames2{ 1 } = 'Number_of_common_Connections' ;
%              Comp_result_SNames2{ 2 } = 'Mean_M_abs_difference_common_connections'; 
%              Comp_result_SNames2{ 4 } = 'New_Diss_connes_percent_of_1s_file' ;            
%              Comp_result_SNames2{ 5 } = 'New_conns_percent_of_1st_file' ;
%              Comp_result_SNames2{ 6 } = 'Dissapeared_conns_percent_of_1st_file' ;
%              Comp_result_SNames2{ 7 } = 'Mean_M_abs_difference_unstable_connections' ;
%              Comp_result_SNames2{ 3 } = 'Mean_tau_max_difference_common_connections' ;
%              Comp_result_SNames2{ 8 } = 'New_conns_mean_delay' ;    
         DataIndex_num = length( Comp_result_SNames2 )  ;


         
         Nx = 4 ;
         Ny = 3 ;
   figure       
   
   f0 = 1 ;
   dat = [  Patterns1.Connectiv_data.Number_of_Connections ...
       Patterns2.Connectiv_data.Number_of_Connections ...
       Patterns3.Connectiv_data.Number_of_Connections ] ;
   h = subplot( Ny , Nx , f0 ); 
           bar( dat ) ;
           title (  'Number of connections' );
           
  f0 = f0 + 1 ;         
      dat = [      Comp_result1.Number_adequate_channels1
           Comp_result1.Number_adequate_channels2
           Comp_result2.Number_adequate_channels2 ] ; 
    h = subplot( Ny , Nx , f0 ); 
           bar( dat ) ;
           title (  'Number adequate channels' );
           
           
           
   for DataIndex = 1 : DataIndex_num   
       
         Name_index = strmatch(  Comp_result_SNames2( DataIndex ) , ALL_cell.Comp_type( Cmp_type_num , Data_type  ).Comp_result_Names  ) ; 
         dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num , Data_type  ).Comp_result_cell(: , Name_index ) );
           
         h = subplot( Ny , Nx , DataIndex + f0 ); 
           bar( dat ) ;
           title (  Comp_result_SNames2( DataIndex )  );
           
           
           
        
        
   end
    
    end


function meaDB_ExpTotal_analyze_one_file_each_exp( All_exp_data_matrix , Exp_num , var )

 Value_str_to_show   = { 'Spike_Rate_Signature_1ms_smooth' , 'SpikeRate_burst_profile_1ms' , 'Spike_Rates_Signature' , 'Spike_Rates' , 'InteBurstInterval' ...
        , 'Spike_Rates_each_burst' , 'Small_bursts_number'  , 'Small_bursts_Davies_Bouldin_Clustering_index' };
Analysis_structure_str = 'Analysis_data_cell' ; % Spike_Rate_Signature_1ms_smooth  Amps_Signature_1ms_smooth
Analysis_structure_fieldnames = 'Analysis_data_cell_field_names' ;
Snames = All_exp_data_matrix.(Analysis_structure_fieldnames) ;

loopIndex_for_analysis = 1 ;

figure
Ny = 2 ; Nx = Exp_num ;

file_i1 = 4 ;
file_i2 = 5 ;

fi = 1 ;
    for Exp_i = 1 : Exp_num
        dat= cell( numel(  Value_str_to_show )  ,1);
          for loopIndex = 1 : numel(  Value_str_to_show )  
              Name_index = strmatch( Value_str_to_show{ loopIndex } , Snames  )  
             dat{ loopIndex } = All_exp_data_matrix.(Analysis_structure_str)( Exp_i , file_i1 , Name_index(1) , var.State , var.Channel   )  ; 
               dat{ loopIndex }  
          end
        
        subplot( Ny , Nx , fi )      
        G = cell2mat( dat{loopIndex_for_analysis} );
        N = size( G,2);
        Spike_Rate_Signature = G';
        
%         DT_step= 1 ;
%         s=size( Spike_Rate_Signature ) ;
%         x=1: s( 2) ; y = 1:N;
%         bb= imagesc(  x *DT_step  , y ,  Spike_Rate_Signature  ); 
%         title( ['Burst profile, spikes/bin (' num2str(DT_step) ' ms)'] );
%         xlabel( 'Time offset, ms' )
%         ylabel( 'Electrode #' )
%         colorbar
%         fi = fi + 1 ;
        
        
        for loopIndex = 1 : numel(  Value_str_to_show )  
              Name_index = strmatch( Value_str_to_show{ loopIndex } , Snames  ) ;
             dat{ loopIndex } = All_exp_data_matrix.(Analysis_structure_str)( Exp_i , file_i2 , Name_index(1) , var.State , var.Channel   )  ; 
             dat{ loopIndex }  
          end
        
%         subplot( Ny , Nx , fi )      
        G = cell2mat( dat{loopIndex_for_analysis} );
        N = size( G,2);
        Spike_Rate_Signature2 = G';
%         Spike_Rate_Signature = Spike_Rate_Signature2 ;
        
        Spike_Rate_Signature  = Spike_Rate_Signature2 - Spike_Rate_Signature ;
        
        subplot( Ny , Nx , fi ) 
        DT_step= 1 ;
        s=size( Spike_Rate_Signature ) ;
        x=1: s( 2) ; y = 1:N;
        bb= imagesc(  x *DT_step  , y ,  Spike_Rate_Signature  ); 
        title( ['Burst profile, spikes/bin (' num2str(DT_step) ' ms)'] );
        xlabel( 'Time offset, ms' )
        ylabel( 'Electrode #' )
        colorbar
        fi = fi + 1 ;
        
        

%         G = cell2mat( dat{loopIndex_for_analysis} );
%         N = size( G,2);
%         SpikeRate_burst_profile_1ms = G';      
%         
%             for loopIndex = 1 : numel(  Value_str_to_show )  
%               Name_index = strmatch( Value_str_to_show{ loopIndex } , Snames  ) ;
%              dat{ loopIndex } = All_exp_data_matrix.(Analysis_structure_str)( Exp_i , file_i2 , Name_index(1) , var.State , var.Channel   )  ; 
%              dat{ loopIndex }  
%             end    
%           
%         G = cell2mat( dat{loopIndex_for_analysis} );
%         N = size( G,2);
%         SpikeRate_burst_profile_1ms2 = G';             
%             
% %        SpikeRate_burst_profile_1ms = SpikeRate_burst_profile_1ms2 - SpikeRate_burst_profile_1ms ;     
%        
%          subplot( Ny , Nx , fi )           
%          plot( SpikeRate_burst_profile_1ms )
%          title( ['Burst profile, spikes/bin (' num2str(1) ' ms)'] );
%          xlim( [1 300 ] )
%         xlabel( 'Time offset, ms' )
%         ylabel( 'Electrode #' )
        
        
        
        
        
        
%         fi = fi + 1 ;       
         
          
    end
    
    
    
       

    
    
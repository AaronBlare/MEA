   %--- Connectiv_matrix_statistics_figures----------------
   
    x = 1: N ;
    y = x ; 
    Nx = 4 ;   Ny = 3 ;
    
%     Connectiv_data.Connectiv_matrix_max_M( 1 , : ) = 1 ;

% LOAD_GLOBAL_CONSTANTS
GLOBAL_CONSTANTS_load


% Global_flags.Connects_min_tau_diff = 5 ;  

            
            
        
s= size( Connectiv_data.Connectiv_matrix_max_M  ) ;
N = s(1);
%---Hubs many----------------------------
Hubs = cell(1,1); 

hub_i = 0 ;
for chi = 1 : N 
   N_connections_trans = 0 ;
   channels_in_hub = [] ;
   channels_in_hub_taus_max=[];
   for chj = 1 : N    
        if chi ~= chj 
          M1 = Connectiv_data.Connectiv_matrix_max_M( chi , chj ) ;
          tau1= Connectiv_data.Connectiv_matrix_tau_of_max_M( chi , chj ) ; 
          is_Connection_OK_1 = M1 > 0 ;
          is_Connection_OK_1_delay_non_zero = tau1 >= GLOBAL_const.Connects_min_tau_diff ;            
          is_Connection_exists  = is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero  ;  
          N_connections_trans = N_connections_trans +   is_Connection_exists ;
          if is_Connection_exists
            channels_in_hub = [ channels_in_hub chj ] ;
            channels_in_hub_taus_max= [ channels_in_hub_taus_max tau1];
          end
        end
   end
   if N_connections_trans > 4
       hub_i=hub_i+1;
      Hubs{ hub_i , 1 } = channels_in_hub ;
      Hubs{ hub_i , 2 } = N_connections_trans ;
      Hubs{ hub_i , 3 } = chi ;      
      Hubs{ hub_i , 4 } = channels_in_hub_taus_max ;  
   end
end
            
Hubs_number = hub_i 

%---Hubs inputs many----------------------------
Hubs_Inputs = cell(1,1);
hub_inputs_i = 0 ;
for chj = 1 : N 
   N_connections_trans = 0 ;
   channels_in_hub = [] ;
   channels_in_hub_taus_max=[];
   for chi = 1 : N    
        if chi ~= chj 
          M1 = Connectiv_data.Connectiv_matrix_max_M( chi , chj ) ;
          tau1= Connectiv_data.Connectiv_matrix_tau_of_max_M( chi , chj ) ; 
          is_Connection_OK_1 = M1 > 0 ;
          is_Connection_OK_1_delay_non_zero = tau1 >= GLOBAL_const.Connects_min_tau_diff ;            
          is_Connection_exists  = is_Connection_OK_1 *  is_Connection_OK_1_delay_non_zero  ;  
          N_connections_trans = N_connections_trans +   is_Connection_exists ;
          if is_Connection_exists
            channels_in_hub = [ channels_in_hub chi ] ;
            channels_in_hub_taus_max= [ channels_in_hub_taus_max tau1];
          end
        end
   end
   if N_connections_trans > 4
       hub_inputs_i=hub_inputs_i+1;
      Hubs_Inputs{ hub_inputs_i , 1 } = channels_in_hub ;
      Hubs_Inputs{ hub_inputs_i , 2 } = N_connections_trans ;
      Hubs_Inputs{ hub_inputs_i , 3 } = chj ;      
      Hubs_Inputs{ hub_inputs_i , 4 } = channels_in_hub_taus_max ;  
   end
end
            
Hubs_inputs_number = hub_inputs_i
%------------------------------------------------


%------Figures Hubs-------------------------------
%------------------------------------------------
if Hubs_number > 0
   hubs_size = cell2mat( Hubs( : , 2 ) ) ; 
   [ sizes , hub_num_x ]= sort( hubs_size ,'descend' );
    
   if Hubs_number >= Show_HUBS_number_figures 
      Hubs_number_to_show = Show_HUBS_number_figures ;
   else
      Hubs_number_to_show = Hubs_number ;
   end
   
   if Hubs_number > 0
   for Hub_i_show = 1 : Hubs_number_to_show
       
        Hub_i_show_index =  hub_num_x( Hub_i_show );
%        [max_hub , hub_max_i ] = max( cell2mat( Hubs( : , 2 ) ) );
%         hub_max_i
         hub_channels_recieved = cell2mat( Hubs( Hub_i_show_index , 1 ) )
         hub_channel_transmitter = Hubs{ Hub_i_show_index , 3 }
         hub_channels_recieved_delays = cell2mat( Hubs( Hub_i_show_index , 4 ) )
         hub_channels_recieved_delays = ...
         Connectiv_data.Connectiv_matrix_tau_of_max_M( hub_channel_transmitter , hub_channels_recieved ) ;

         hub_channels_recieved_M_max = ...
         Connectiv_data.Connectiv_matrix_max_M( hub_channel_transmitter , hub_channels_recieved ) ; 



         Array_vector_hub_markers = zeros( N ,1 );
         Array_vector_hub_delays = zeros( N ,1 );
         Array_vector_hub_M_max = zeros( N ,1 );
         Array_vector_all_channels_spike_rates = zeros( N ,1 );

         Array_vector_all_channels_spike_rates( hub_channels_recieved ) = ...
                    Connectiv_data.Total_Spike_Rates( hub_channels_recieved )  ;
         Array_vector_all_channels_spike_rates( hub_channel_transmitter ) = ...
                    Connectiv_data.Total_Spike_Rates( hub_channel_transmitter ) ;


         Array_vector_hub_markers( hub_channels_recieved ) = 2 ;
         Array_vector_hub_markers( hub_channel_transmitter ) = 1 ; 

         Array_vector_hub_delays( hub_channels_recieved ) = hub_channels_recieved_delays ; 
         Array_vector_hub_M_max( hub_channels_recieved ) = hub_channels_recieved_M_max ;

         f=figure ;
         figure_title = ['Hub, Source=' num2str( hub_channel_transmitter ) ' channel' ] ;
         set(f, 'name',  figure_title ,'numbertitle','off' );

         Nx2 = 2 ; Ny2 = 2 ;
         subplot( Ny2 , Nx2 ,1 )
            Plot8x8Data( Array_vector_hub_markers , false );
            title( 'Hub markers' )

         subplot( Ny2 , Nx2 ,2 )
            Plot8x8Data( Array_vector_hub_delays , false );
            title( 'Hub delays , ms' )        

         subplot( Ny2 , Nx2 , 3 )
            Plot8x8Data( Array_vector_hub_M_max , false );
            title( 'Hub strengths' )        

         subplot( Ny2 , Nx2 , 4 )
            Plot8x8Data( Array_vector_all_channels_spike_rates , false );
            title( 'Hub spike rates' )          
   end
            
            
   end
end
%------------------------------------------------
%------------------------------------------------
            


%------Figures Hubs inputs-------------------------------
%------------------------------------------------
Hubs_number = Hubs_inputs_number 
Hubs_inputs_number
Hubs = Hubs_Inputs ;
if Hubs_number > 0
   hubs_size = cell2mat( Hubs( : , 2 ) ) ; 
   [ sizes , hub_num_x ]= sort( hubs_size ,'descend' );
    
   if Hubs_number >= Show_HUBS_number_figures 
      Hubs_number_to_show = Show_HUBS_number_figures ;
   else
      Hubs_number_to_show = Hubs_number ;
   end
   
   if Hubs_number > 0
   for Hub_i_show = 1 : Hubs_number_to_show
       
        Hub_i_show_index =  hub_num_x( Hub_i_show );
%        [max_hub , hub_max_i ] = max( cell2mat( Hubs( : , 2 ) ) );
%         hub_max_i
         hub_channels_recieved = cell2mat( Hubs( Hub_i_show_index , 1 ) )
         hub_channel_transmitter = Hubs{ Hub_i_show_index , 3 }
         hub_channels_recieved_delays = cell2mat( Hubs( Hub_i_show_index , 4 ) )
         hub_channels_recieved_delays = ...
         Connectiv_data.Connectiv_matrix_tau_of_max_M( hub_channels_recieved , hub_channel_transmitter ) ;

         hub_channels_recieved_M_max = ...
         Connectiv_data.Connectiv_matrix_max_M(  hub_channels_recieved , hub_channel_transmitter ) ; 



         Array_vector_hub_markers = zeros( N ,1 );
         Array_vector_hub_delays = zeros( N ,1 );
         Array_vector_hub_M_max = zeros( N ,1 );
         Array_vector_all_channels_spike_rates = zeros( N ,1 );

         Array_vector_all_channels_spike_rates( hub_channels_recieved ) = ...
                    Connectiv_data.Total_Spike_Rates( hub_channels_recieved )  ;
         Array_vector_all_channels_spike_rates( hub_channel_transmitter ) = ...
                    Connectiv_data.Total_Spike_Rates( hub_channel_transmitter ) ;


         Array_vector_hub_markers( hub_channels_recieved ) = 2 ;
         Array_vector_hub_markers( hub_channel_transmitter ) = 1 ; 

         Array_vector_hub_delays( hub_channels_recieved ) = hub_channels_recieved_delays ; 
         Array_vector_hub_M_max( hub_channels_recieved ) = hub_channels_recieved_M_max ;

         f=figure ;
         figure_title = ['Hub inputs, Source=' num2str( hub_channel_transmitter ) ' channel' ] ;
         set(f, 'name',  figure_title ,'numbertitle','off' );

         Nx2 = 2 ; Ny2 = 2 ;
         subplot( Ny2 , Nx2 ,1 )
            Plot8x8Data( Array_vector_hub_markers , false );
            title( 'Hub markers' )

         subplot( Ny2 , Nx2 ,2 )
            Plot8x8Data( Array_vector_hub_delays , false );
            title( 'Hub delays , ms' )        

         subplot( Ny2 , Nx2 , 3 )
            Plot8x8Data( Array_vector_hub_M_max , false );
            title( 'Hub strengths' )        

         subplot( Ny2 , Nx2 , 4 )
            Plot8x8Data( Array_vector_all_channels_spike_rates , false );
            title( 'Hub spike rates' )          
   end
            
            
   end
end
%------------------------------------------------
%------------------------------------------------
    
    figure 
    subplot( Ny ,Nx , [ 1 2 5 6  ])
        h_pict = imagesc( x,y, Connectiv_data.Connectiv_matrix_max_M );
        title( 'Connections strength matrix');
        xlabel( 'electrode #')
        ylabel( 'electrode #')
        colorbar
        axis square
    subplot(  Ny ,Nx  , [ 3 4 7 8 ]) 
        h_pict2 = imagesc( x,y, Connectiv_data.Connectiv_matrix_tau_of_max_M );
        title( 'Connections delays matrix');
        xlabel( 'electrode #')
        ylabel( 'electrode #')
        axis square
        colorbar      
       
        
        Bins_num = 40 ;

      subplot(  Ny ,Nx  , 9 )
        
         hist( Connectiv_data.Connectiv_matrix_max_M_vector_non_zeros , Bins_num )
         xlabel( 'Connections strength')
         ylabel('Count #')
         title( 'Strength histogram');
      
      subplot(  Ny ,Nx , 10 ) 
            non_zero_delays=Connectiv_data.Connectiv_matrix_tau_of_max_M_vector_non_zeros ;
            non_zero_delays(non_zero_delays==0)=[];
         hist( non_zero_delays , Bins_num )
         xlabel( 'Connections delay (>0)')
         ylabel('Count #')
         title( 'Delays histogram');
    %-----------------------------------------
    
    
  %--- Connectivity  plot----------------   
        subplot(  Ny ,Nx , [ 11 12 ] )

            plot( Connectiv_data.Connectiv_matrix_tau_of_max_M_vector_non_zeros , Connectiv_data.Connectiv_matrix_max_M_vector_non_zeros , '*' )
            xlabel( 'Delay' )
            ylabel( 'Strength' )
            title( 'Connections' )
            
            
% %======== Separate figure for matrix            
%     figure        
%           
%     subplot( 1 ,2 , 1)
%         h_pict = imagesc( x,y, Connectiv_data.Connectiv_matrix_max_M );
%         title( 'Connectivity strength matrix');
%         xlabel( 'electrode #')
%         ylabel( 'electrode #')
%         colorbar
%         axis square
%     subplot(  1 ,2  , 2) 
%         h_pict2 = imagesc( x,y, Connectiv_data.Connectiv_matrix_tau_of_max_M );
%         title( 'Connections delays matrix');
%         xlabel( 'electrode #')
%         ylabel( 'electrode #')
%         axis square
%         colorbar              
%             
            
            
            
            
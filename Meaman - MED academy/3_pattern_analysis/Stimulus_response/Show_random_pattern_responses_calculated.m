

% Show_random_pattern_responses_calculated


Patterns_to_show = 9 ;
  Nx = floor( sqrt( Patterns_to_show ));
  Ny = Nx ;
  Patterns_to_show = Nx*Nx ;
  
  Patterns_lin_num = 1:Patterns.Number_of_Patterns ; 
    %-- Take random patterns 
  while length( Patterns_lin_num  ) > Patterns_to_show
     Art_delete_num = floor( rand()*length( Patterns_lin_num ) + 1) ;
     Patterns_lin_num( Art_delete_num ) =[];
  end 
  %---------------------------
  Nb_i_loop = 0 ;
  
     figure
  for Nb_i = 1 : Patterns_to_show  
%       
               TimeBin_Total_Spikes = Patterns.TimeBin_Total_Spikes( Patterns_lin_num( Nb_i ) , 1:end ) ;

            Nb_i_loop = Nb_i_loop + 1 ;
            hh(Nb_i_loop) =  subplot( Ny , Nx , Nb_i ) ;
               bar( TimeBin_Total_Spikes )
               title( ['Response # ' num2str( Nb_i )])
%                if max(TimeBin_Total_Spikes) >0
%                 axis( [ 0 Ent_t + abs(Start_t) 0 1.2*max( TimeBin_Total_Spikes ) ] )
%                end
        
  end
  
  xlabel( 'Time, ms')
  ylabel( 'spikes per 1 ms')
  linkaxes( hh , 'xy')
       
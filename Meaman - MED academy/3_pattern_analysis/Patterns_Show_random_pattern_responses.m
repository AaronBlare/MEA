

% Patterns_Show_random_pattern_responses 


Patterns_to_show = 25 ;
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
  
               f=figure ;
             FigureName = [ 'Responses with timebin = ' num2str( Patterns.DT_bin ) ' ms'];
             set(f,'name', FigureName  ,'numbertitle','off')
             xx = Patterns.Poststim_interval_START : Patterns.DT_bin : Patterns.Poststim_interval_END - Patterns.DT_bin;
      
  for Nb_i = 1 : Patterns_to_show  
%       
               TimeBin_Total_Spikes = Patterns.TimeBin_Total_Spikes( Patterns_lin_num( Nb_i ) , 1:end ) ;

            Nb_i_loop = Nb_i_loop + 1 ;
            hh(Nb_i_loop) =  subplot( Ny , Nx , Nb_i ) ;
            
               bar( xx ,TimeBin_Total_Spikes )
               title( ['Response # ' num2str( Nb_i )])
               if max(TimeBin_Total_Spikes) >0
                   xlim('auto')
%                  xlim( [ Patterns.Poststim_interval_START - 10 Patterns.Poststim_interval_END  + 10 ] );  
%                 axis( [ 0 Patterns.Poststim_interval_END / Patterns.DT_bin   0 1.2*max( TimeBin_Total_Spikes ) ] )
               end
        
  end
  
  xlabel( 'Timebin, number')
  ylabel( 'spikes per bin')
  linkaxes( hh , 'x')
       
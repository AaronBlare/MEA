function  Show_random_pattern_responses( N , Patterns_to_show , index_r ,  artefacts , Start_t , Ent_t ,DT_step ,  var )
 
 
nargin
if nargin > 7 % No bursts_amps in input
%   bursts_amps = bursts1 ;  
  bursts_amps_included = true ;
else
   bursts_amps_included = false ;  
end
 
Start_t = -50 ;
DT = 1 ; 
  
  
  Nx = floor( sqrt( Patterns_to_show ));
  Ny = Nx ;
  Patterns_to_show = Nx*Nx ;
    

  %-- Take random patterns 
  while length( artefacts ) > Patterns_to_show
     Art_delete_num = floor( rand()*length( artefacts ) + 1) ;
     artefacts( Art_delete_num ) =[];
  end 
  %---------------------------
    
  
  
  
params.show_figures = false ;
  AWSR = AWSR_from_index_r( index_r  , DT , params );
 Nb_i_loop = 0 ;
     figure('name','Stimulus response examples');
  for Nb_i = 1 : Patterns_to_show  
     if Nb_i <= length( artefacts )
        STT = floor( artefacts(Nb_i) ) + Start_t ;
        if STT > 1
            if floor( artefacts(Nb_i) ) + Ent_t < artefacts( end)
                   TimeBin_Total_Spikes = AWSR(  STT :  floor( artefacts(Nb_i) ) + Ent_t );

                Nb_i_loop = Nb_i_loop + 1 ;
                hh(Nb_i_loop) =  subplot( Ny , Nx , Nb_i ) ;
                   bar( TimeBin_Total_Spikes )
                   title( ['Response #' num2str(Nb_i) ' at ' num2str( artefacts( Nb_i )/1000  )])
                   if max(TimeBin_Total_Spikes) >0
                    axis( [ 0 Ent_t + abs(Start_t) 0 1.2*max( TimeBin_Total_Spikes ) ] )
                   end
            end
        end
     end
  end
  
  if exist( 'hh', 'var' )
  if ~isempty( hh )
  xlabel( 'Time, ms')
  ylabel( 'spikes per 1 ms')
  linkaxes( hh , 'xy')
  end
  end
 
% Get_Responses_in_Interval
function [ Patterns ] = Patterns_Get_Responses_in_Interval_from_Raster( N , artefacts ,index_r ,Post_stim_interval_start , ...
   Post_stim_interval_end  , DT_bin ,flags  )
  % index_r, intervals post stim -> bursts burst_activation
  % One_sigma_in_channels ... 
  
 flags.normalize = false; 
   if nargin == 6
    flags.normalize = false; 
 end
 
 Normalize_responses = flags.normalize ;
 
 Nb=length(artefacts);
     
    if flags.Burst_Data_Ver == 1
        Patterns.bursts_absolute=zeros( length(artefacts) ,N, 1000);   
        Patterns.bursts=zeros( length(artefacts) ,N, 1000); 
        Patterns.bursts_amps=zeros( length(artefacts) ,N, 1000);        
    else            
        Patterns.bursts_absolute= cell( Nb ,1 ) ;   
        Patterns.bursts= cell( Nb ,1 ) ;
        Patterns.bursts_amps= cell( Nb ,1 ) ;
    end
 

    
    
    
    Patterns.One_sigma_in_channels = zeros( 1,N); 
    Patterns.burst_activation=zeros( Nb ,N);
    Patterns.burst_activation_absolute=zeros( Nb ,N);
    Patterns.burst_activation_amps =zeros( Nb ,N);  
    
   Patterns.Poststim_interval_START =   Post_stim_interval_start  ;
   Patterns.Poststim_interval_END = Post_stim_interval_end ;
   Patterns.Number_of_Patterns = Nb ;
   Patterns.N_channels = N ;
   Patterns.artefacts = artefacts ;
   Patterns.DT_bin = DT_bin ;
   
   Start_t_shift = Post_stim_interval_start ;
%    Post_stim_interval_start = 0 ;
   
 siz = size(index_r);
 s=size(siz);
 
index_r_chan_times = cell( N , 1) ;
index_r_chan_amps = cell( N , 1)  ; 
index_ch_all = cell( N , 1)  ; 
for ch =1 : N
   index_ch  = find( index_r( : , 2 ) == ch ) ;
   index_ch_all{ch} = index_ch ;
   index_r_chan_times{ch} = index_r( index_ch  , 1 )  ;    
   index_r_chan_amps{ch} = index_r( index_ch , 3 )  ; 
end  
 
    
    for i=1:  length( artefacts   )     
%             extract_channel_index = find( index_r( : , 2 ) == CHANNEL_i ) ;
%             channel_index_i =  index_r( extract_channel_index , 1 )   ;  
%             channel_index_i;
%             Zero_values_in_channel_precent = find( extract_channel_index == 0); 
%             Zero_values_in_channel  = length( Zero_values_in_channel_precent ) ;
%             Zero_values_in_channel;
%             
%             Amps_i =  index_r( extract_channel_index , 3 )   ;  
            
            
           
               
         if flags.Burst_Data_Ver >= 1        
            Patterns.bursts_absolute{ i } = cell( N,1);
            Patterns.bursts{ i } = cell( N,1);
            Patterns.bursts_amps{ i } = cell( N,1);
         end
%              meanAMP = mean( Amps );
%              meanAMP
%              if CHANNEL_i==1
%                  hist( Amps)
%              end
%          FIND_ALL_SPIKES_AFTER_STIM = true ;   
%     chan_index_after_art  = [] ;
%     chan_amps_after_art  = [] ;
%     chan_index_after_time= [] ;
%     for i=1:  length( artefacts   )  
        for CHANNEL_i = 1 :  N
            
            One_sigmas_ch=0;
             if siz(2) >3 
              One_sigmas_i =  index_r( index_ch_all{ CHANNEL_i } , 4 )   ;  
              if  ~isempty( One_sigmas_i )
              One_sigmas_ch = One_sigmas_i(1);
              end

            else
               
            end
               Patterns.One_sigma_in_channels( CHANNEL_i ) = One_sigmas_ch;
            
%         if FIND_ALL_SPIKES_AFTER_STIM == true 
%             index_after_art = find( artefacts(i) < channel_index_i(:) & artefacts(i) + Post_stim_interval_start >= channel_index_i(:)  );
%         else
%             index_after_art = find( artefacts(i) < channel_index_i(:) & artefacts(i) + Post_stim_interval_start >= channel_index_i(:) , 1 );
%         end    
%        if ~isempty( index_after_art  )
% %            chan_responsed  = chan_responsed +1 ;
%             s = channel_index_i( index_after_art ) - artefacts(i) ;
%             sAmps = Amps_i( index_after_art );
%             chan_index_after_art  = [ chan_index_after_art  ; s ] ;        
%             chan_amps_after_art= [ chan_amps_after_art ; sAmps ];
%        end
       
%        ss = find( artefacts(i) + Post_stim_interval_start <= channel_index_i(:) & artefacts(i) + Post_stim_interval_end >= channel_index_i(:)  );
       ss = find( artefacts(i) + Post_stim_interval_start < index_r_chan_times{CHANNEL_i} ...
                    & artefacts(i) + Post_stim_interval_end >= index_r_chan_times{CHANNEL_i}  );
       
       if ~isempty( ss  )
           length( ss );
           
           if flags.Burst_Data_Ver == 1  
               Patterns.bursts_absolute(i,CHANNEL_i,1:length(ss)) = channel_index_i( ss ) ;
               Patterns.bursts(i,CHANNEL_i,1:length(ss)) = channel_index_i( ss ) -  artefacts(i) ; 
               Patterns.bursts_amps(i,CHANNEL_i,1:length(ss)) = Amps_i( ss ) ; 
           else      
               
               AMPS = index_r_chan_amps{CHANNEL_i}(  ss ) ;
               SPIKES_ms = index_r_chan_times{CHANNEL_i}( ss ) ;
               ampt = AMPS / One_sigmas_ch ;
                   if flags.par.Stim_response_Amp_as_AmpSigma
                            AMPS= ampt ;
                   end
                   
               if   flags.par.Amp_sigma_threshold > 0 
                   
                   fampt = find( abs( ampt ) <  flags.par.Amp_sigma_threshold ) ;
                   if ~isempty( fampt )
                      AMPS( fampt ) = [] ;
                      SPIKES_ms( fampt ) = [] ;
                   end
%                    spikes_erased_percent =  100 * ( (  numel( fampt ))/ numel( ss )  )    ;
%                    if spikes_erased_percent > 0 
%                        spikes_erased_percent
%                    end
%                    fampt = find( abs( SPIKES_ms  -  artefacts(i) ) >  10 ) ;
%                    if ~isempty( fampt )
%                       AMPS( fampt ) = [] ;
%                       SPIKES_ms( fampt ) = [] ;
%                    end
               end
                   
               Patterns.bursts_absolute{ i }{ CHANNEL_i} = SPIKES_ms ;
               Patterns.bursts{ i }{ CHANNEL_i} =  SPIKES_ms  -  artefacts(i) ; 
               Patterns.bursts_amps{ i }{ CHANNEL_i} = AMPS ;   
%                Patterns.bursts_absolute{ i }{ CHANNEL_i} = index_r_chan_times{CHANNEL_i}( ss ) ;
%                Patterns.bursts{ i }{ CHANNEL_i} =  index_r_chan_times{CHANNEL_i}( ss )  -  artefacts(i) ; 
%                Patterns.bursts_amps{ i }{ CHANNEL_i} = index_r_chan_amps{CHANNEL_i}(  ss ) ;  
           end
           
           
           
%            Spike_Rates(i,CHANNEL_i)=length(ss);

%            burst_end(i) = channel_index_i( ss(end) ) ;

%            s = channel_index_i( ss ) - artefacts(i) ;
%                 chan_index_after_time  = [ chan_index_after_time  ; s ] ;  
         
               ss = ss(1);
%                Patterns.burst_activation(i,CHANNEL_i) = channel_index_i( ss ) - artefacts(i)   ;
%                Patterns.burst_activation_absolute(i,CHANNEL_i) = channel_index_i( ss )    ;
%                Patterns.burst_activation_amps(i,CHANNEL_i) = Amps_i( ss )     ;
               Patterns.burst_activation(i,CHANNEL_i) = index_r_chan_times{CHANNEL_i}( ss ) -  artefacts(i)  ;
               Patterns.burst_activation_absolute(i,CHANNEL_i) = index_r_chan_times{CHANNEL_i}( ss )  ;
               Patterns.burst_activation_amps(i,CHANNEL_i) = index_r_chan_amps{CHANNEL_i}(  ss )    ;
           end
      
       
    end     
    
    end
     

     
     
     
     
     
     
     
     
     

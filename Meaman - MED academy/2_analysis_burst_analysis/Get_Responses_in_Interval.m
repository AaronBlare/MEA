% Get_Responses_in_Interval
function [ Patterns ] = Get_Responses_in_Interval_Patterns( N , artefacts ,index_r ,Post_stim_interval_start , ...
   Post_stim_interval_end  , DT_bin ,flags  )
  % index_r, intervals post stim -> bursts burst_activation
  % One_sigma_in_channels ... 
  
  
   if nargin == 6
    flags.normalize = false; 
 end
 
 Normalize_responses = flags.normalize ;
 
 Nb=length(artefacts);
    
    Patterns.bursts_absolute=zeros( length(artefacts) ,N, 1000);   
    Patterns.bursts=zeros( length(artefacts) ,N, 1000); 
    Patterns.bursts_amps=zeros( length(artefacts) ,N, 1000);  
    Patterns.One_sigma_in_channels = zeros( 1,N); 
    Patterns.burst_activation=zeros( Nb ,N);
    Patterns.burst_activation_absolute=zeros( Nb ,N);
    Patterns.burst_activation_amps =zeros( Nb ,N);  
    
   Patterns.Poststim_interval_START =  SPost_stim_interval_start  ;
   Patterns.Poststim_interval_END = Post_stim_interval_end ;
   Patterns.Number_of_Patterns = Nb ;
   Patterns.N_channels = N ;
   
 siz = size(index_r);
 s=size(siz);
    for CHANNEL_i = 1 :  N
        
            extract_channel_index = find( index_r( : , 2 ) == CHANNEL_i ) ;
            channel_index_i =  index_r( extract_channel_index , 1 )   ;  
            channel_index_i;
            Zero_values_in_channel_precent = find( extract_channel_index == 0); 
            Zero_values_in_channel  = length( Zero_values_in_channel_precent ) ;
            Zero_values_in_channel;
            
            Amps_i =  index_r( extract_channel_index , 3 )   ;  
            
            
            if s >3 
              One_sigmas_i =  index_r( extract_channel_index , 4 )   ;   
              One_sigmas_ch = One_sigmas_i(1);

            else
               One_sigmas_ch=0;
            end
               Patterns.One_sigma_in_channels( CHANNEL_i ) = One_sigmas_ch;
%              meanAMP = mean( Amps );
%              meanAMP
%              if CHANNEL_i==1
%                  hist( Amps)
%              end
%          FIND_ALL_SPIKES_AFTER_STIM = true ;   
%     chan_index_after_art  = [] ;
%     chan_amps_after_art  = [] ;
%     chan_index_after_time= [] ;
    for i=1:  length( artefacts   )  
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
       
       ss = find( artefacts(i) + Post_stim_interval_start <= channel_index_i(:) & artefacts(i) + Post_stim_interval_end >= channel_index_i(:)  );
       if ~isempty( ss  )
           length( ss );
           Patterns.bursts_absolute(i,CHANNEL_i,1:length(ss)) = channel_index_i( ss ) ;
           Patterns.bursts(i,CHANNEL_i,1:length(ss)) = channel_index_i( ss ) -  artefacts(i) ;
           
%          bursts_absolute_amps(i,CHANNEL_i,1:length(ss)) = Amps_i( ss ) ;
           Patterns.bursts_amps(i,CHANNEL_i,1:length(ss)) = Amps_i( ss ) ; 
%            Spike_Rates(i,CHANNEL_i)=length(ss);

%            burst_end(i) = channel_index_i( ss(end) ) ;

%            s = channel_index_i( ss ) - artefacts(i) ;
%                 chan_index_after_time  = [ chan_index_after_time  ; s ] ;  
                
       end
%            ss =  find( artefacts(i) + Post_stim_interval_start <= channel_index_i(:) & artefacts(i) + Post_stim_interval_end >= channel_index_i(:) ,1  );           
           if ~isempty( ss  )   
               ss = ss(1);
               Patterns.burst_activation(i,CHANNEL_i) = channel_index_i( ss ) - artefacts(i)   ;
               Patterns.burst_activation_absolute(i,CHANNEL_i) = channel_index_i( ss )    ;
               Patterns.burst_activation_amps(i,CHANNEL_i) = Amps_i( ss )     ;
           end
      
       
    end     
    
    end
     

     
     
     
     
     
     
     
     
     

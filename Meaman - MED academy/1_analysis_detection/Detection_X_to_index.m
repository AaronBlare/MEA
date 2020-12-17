
% Detection_X_to_index
% input x handles
% output: index

% if PLAY_CHANNEL_SOUND == 'n' 
%             if Artefacts_find ~= 'y' 
% %             [spikes,thr,index,amps,one_sigma_thr]  = amp_detect2( handles);       %detection with amp. thresh.
%             [spikes,thr,index,amps,one_sigma_thr,artefacts] = amp_detect3_artefacts( handles, Collect_sigma_from  , Collect_sigma_to , 'n' );   
%             else  
handles.LFP_stim_num = Arg_plus.LFP_stim_num ;  
%             [spikes,thr,index,amps,one_sigma_thr,artefacts, option_data] = ...
%                 amp_detect3_artefacts( handles, Collect_sigma_from  , Collect_sigma_to , 'n' );   
            
            
            [spikes,thr,index,amps,one_sigma_thr,artefacts,option_data, artefact_amps] = ...
                amp_detect3_artefacts_copy(               handles, Collect_sigma_from  , Collect_sigma_to , 'n' );
            
            
            
%             artefacts_all  = [ artefacts_all artefacts ];
              artefacts = artefacts' ;
%             end    
%         else    
%             [spikes,thr,index]  = amp_detect2_sound( handles);       %detection with amp. thresh.    
%         end
        x = [];
%         whos index
        
        option_data.channel = channel ; 
        option_data_all = [ option_data_all option_data  ] ;
        
        if Compressin > 1             
        DT =  Compressin ;
        index_buf = [] ;
        for ti = 1 : DT :  Trace_Lenght_pionts  - DT
           s = find( index >= ti & index < ti + DT ) ; 
           if s > 0 
             index_buf = [ index_buf  floor( ti / Compressin ) ] ;
           end            
        end            
        index = index_buf ; 
        end
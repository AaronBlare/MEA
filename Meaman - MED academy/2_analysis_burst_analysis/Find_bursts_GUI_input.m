% Find_bursts_GUI_input
% burst analysis get parameters from gui   

    GLOBAL_CONSTANTS_load
     
    Global_flags.Search_Params;
    
        Search_Params = Global_flags.Search_Params ;

    
    if (get(handles.checkboxList2,'Value') == get(handles.checkboxList2,'Max'))
        List_files2 = true ;
    else
        List_files2 = false ;
    end
     t = get(handles.TimeBinBurstEdit,'String');
     s = get(handles.BurstSigmaEdit,'String');


if (get(handles.checkboxBurstFile,'Value') == get(handles.checkboxBurstFile,'Max'))
        save_bursts_to_files = 'y' ;
    else
        save_bursts_to_files = 'n' ;
end     
    

if (get(handles.checkboxGetFromFile,'Value') == get(handles.checkboxGetFromFile,'Max'))
       GetFromFile = true ;
    else
        GetFromFile = false ;
end    

     
    if (get(handles.chec6well_bursts,'Value') == get(handles.chec6well_bursts ,'Max'))
        use6well_raster = true ;
    else
        use6well_raster =  false ;
    end  
    
%     if (get(handles.checkboxSimpleBu,'Value') == get(handles.checkboxSimpleBu ,'Max'))
%         Simple_analysis = true ;
%     else
%         Simple_analysis =  false ;
%     end  
     
   if (get(handles.checkboxConnectiv,'Value') == get(handles.checkboxConnectiv ,'Max'))
         Analyze_Connectiv = true ;
    else
        Analyze_Connectiv =  false ;
    end   
    
    if (get(handles.checkboxSB_filter,'Value') == get(handles.checkboxSB_filter ,'Max'))
         Filter_small_bursts = true ;
    else
        Filter_small_bursts =  false ;
    end   
     
     
    if (get(handles.checkboxCutSuperB,'Value') == get(handles.checkboxCutSuperB ,'Max'))
        Filter_Superbursts = true ;
    else
        Filter_Superbursts =  false ;
    end      
    

    
    
    if (get(handles.checkbox41_MeaA,'Value') == get(handles.checkbox41_MeaA,'Max'))
   analyze_A_mea = true ;
else
  analyze_A_mea = false ;
end

if (get(handles.checkbox42_MeaB,'Value') == get(handles.checkbox42_MeaB,'Max'))
  analyze_B_mea = true ;
else
  analyze_B_mea = false ;
end
    
     
     
    TimeBin = str2num( t );
    AWSR_sig_tres = str2num( s );

    ch = get(handles.editChannelNumBurst,'String');
    CHANNEL = str2num( ch );

    f = get(handles.editSupeB_scale,'String');
    SsuperBurst_scale_sec = str2num( f );
    
    Arg_file.Use_meaDB_raster = false ;
    
    
   
a = get(handles.edit15,'String'); 
a_to = get(handles.edit23,'String'); 
x = get(handles.text19DT_bin,'String'); 
art_c = get(handles.edit22Artc,'String'); 
LFP_stim_num_c = get(handles.edit52_LFP_stim_num,'String'); 
LFP_stim_num_arr = strread( LFP_stim_num_c ,  '%d '  ) ;  
 
% Take_all_spikes_after_stim = true ;

 if (get(handles.checkbox5msBin,'Value') == get(handles.checkbox5msBin,'Max'))
   % Checkbox is checked-take approriate action
   checkbox5msBin = true ;
else
   checkbox5msBin = false ;
 end 
 
Search_Params.DT_bin = str2num( x{1} );
Search_Params.PosStim_Interval_start = str2num( a );
Search_Params.PosStim_Interval_end = str2num( a_to );
Search_Params.Artefact_channel = str2num( art_c ); 
Search_Params.Take_all_spikes_after_stim =  true ;
Search_Params.checkbox5msBin = checkbox5msBin ;

  if (get(handles.checkboxSubFolder,'Value') == get(handles.RelativeDurBox,'Max'))
   % Checkbox is checked-take approriate action
   files_subfolders = true ;
else
   files_subfolders= false ;
  end
 

%-------------------------------------   
%-------------------------------------   
%-------------------------------------   
a = get(handles.SigmaEdit,'String');
b = get(handles.edit24,'String');
c = get(handles.edit25,'String');
if (get(handles.checkboxArt,'Value') == get(handles.checkboxArt,'Max'))
   ARTEFACTS_ON = true ;
else
   ARTEFACTS_ON = false ;
end

if (get(handles.checkboLFP,'Value') == get(handles.checkboLFP,'Max'))
   Arg_plus.Post_stim_potentials_collect   =  true ;
else
   Arg_plus.Post_stim_potentials_collect   =  false ;
end


sigma_from_sec = str2num( b );
sigma_to_ms = str2num( c );
SIGMATRES = str2num( a );
% LFP_stim_num = str2num( LFP_stim_num_c );
% LFP_stim_num_arr

if (get(handles.ListConvert,'Value') == get(handles.ListConvert,'Max'))
   % Checkbox is checked-take approriate action
   FILE_LIST_PROCESS = 'y' ;
else
   % Checkbox is not checked-take approriate action
   FILE_LIST_PROCESS = 'n' ;
end 

% List_files2 = 'n' ;
  
if (get(handles.checkboxAutoAnalysis,'Value') == get(handles.checkboxAutoAnalysis,'Max'))
    Auto_burst_analysis = true ;
else
    Auto_burst_analysis = false ;
end

if (get(handles.checkboxPostStim,'Value') == get(handles.checkboxPostStim,'Max'))
    AutoPostStim= true ;
else
    AutoPostStim = false ;
end

if (get(handles.checkbox6well_detect,'Value') == get(handles.checkbox6well_detect,'Max'))
    var.use_6well_mea = true ;
else
    var.use_6well_mea= false ;
end
    
%-------------------------------------    
 %-------------------------------------   
 
 if (get(handles.checkbox43_Correct,'Value') == get(handles.checkbox43_Correct,'Max'))
    Auto_stimulus= true ;
else
    Auto_stimulus = false ;
 end

 Auto_stimulus ;
 
 
 
 ch = get(handles.edit26chan,'String');

 cexpect = get(handles.edit53_maxart,'String');
 ARTEFACT_thr_search_expected = str2num( cexpect );  % Expected ISI (sec)
 
 
%---------------------- Post_stim_response_params_GUI_input

a = get(handles.edit15,'String'); 
a_to = get(handles.edit23,'String'); 
x = get(handles.text19DT_bin,'String'); 
art_c = get(handles.edit22Artc,'String'); 
 
    Take_all_spikes_after_stim = true ;
    Search_Params.Analyze_preceding_spont_bursts = false ;

     if (get(handles.checkbox5msBin,'Value') == get(handles.checkbox5msBin,'Max'))
       % Checkbox is checked-take approriate action
       checkbox5msBin = true ;  
    else
       checkbox5msBin = false ;

     end 
     Search_Params.Small_PSTH_bin =  5 ;
      if (get(handles.checkboxAdjust,'Value') == get(handles.checkboxAdjust,'Max'))
       % Checkbox is checked-take approriate action
       Search_Params.Adjust_artefact_times = true ;
       % Adjusts artifact times using 1 ms bin AWSR of raster -> finds max of
       % AWSR around each artifact time +- 1000 ms.
      else
       Search_Params.Adjust_artefact_times =  false ;
      end 

    b = get(handles.edit_Response_threshold2,'String'); 
    Search_Params.Spike_Rates_each_burst_cut_Threshold_precent  = str2num( b );

    if (get(handles.checkbox_Small_responses2,'Value') == get(handles.checkbox_Small_responses2,'Max'))
        Use_Small_response = true ;
    else 
        Use_Small_response = false ;
    end
    Search_Params.Use_Small_response = Use_Small_response ;
    
    if (get(handles.checkboxPSTH_connect_analy,'Value') == get(handles.checkboxPSTH_connect_analy,'Max'))
        Search_Params.Analyze_Connectivity = true ;
    else 
        Search_Params.Analyze_Connectivity = false ;
    end 
    
    if (get(handles.checkboxOnlyFilteredResp,'Value') == get(handles.checkboxOnlyFilteredResp,'Max'))
        Search_Params.Analyze_Connectivity_only_filtered_responses = true ;
    else 
        Search_Params.Analyze_Connectivity_only_filtered_responses = false ;
    end     
    
    
     
%-----------
 
 
 %-------------------------------------   
    
    
    

    
    
    Search_Params.SsuperBurst_scale_sec = SsuperBurst_scale_sec ;
    Search_Params.Filter_small_bursts = Filter_small_bursts ;
    
    Search_Params.Filter_Superbursts = Filter_Superbursts ;        
      
    Search_Params.TimeBin = TimeBin ; 
    Search_Params.AWSR_sig_tres = AWSR_sig_tres ;
    Search_Params.save_bursts_to_files = save_bursts_to_files ;
    Search_Params.List_files2 = List_files2 ;
    Search_Params.Show_figures = true ;
    Search_Params.Arg_file = Arg_file ;
    Search_Params.use6well_raster = use6well_raster ;
%     Search_Params.Simple_analysis = Simple_analysis;
    Search_Params.Analyze_Connectiv = Analyze_Connectiv;
    
    
    Search_Params.ARTEFACTS_ON = ARTEFACTS_ON ;
    
    Search_Params.LFP_stim_num = LFP_stim_num_arr ; 
    
    handles.par.ARTEFACT_search_around_selected_elec = Auto_stimulus ;
    Search_Params.ARTEFACT_search_around_selected_elec= Auto_stimulus ;
    % Search_Params.analyze_A_mea = handles.par.analyze_A_mea ;
% Search_Params.analyze_B_mea = handles.par.analyze_B_mea ; 
    Search_Params.analyze_A_mea = analyze_A_mea ;
    Search_Params.analyze_B_mea = analyze_B_mea ; 
    Arg_plus.analyze_A_mea = analyze_A_mea ;
    Arg_plus.analyze_B_mea = analyze_B_mea ; 

    Arg_plus.ARTEFACT_search_around_selected_elec= Auto_stimulus ;
    Arg_plus.use_6well_mea = use6well_raster ;
%     LOAD_GLOBAL_CONSTANTS    
    
%     Search_Params.Analyse_preBursts = false ;
    Arg_plus.Artefact_file =[];

Arg_plus.Analyze_all_files_in_subfolders = files_subfolders ;


Arg_plus.ARTEFACT_thr_search_expected  = ARTEFACT_thr_search_expected ;

Arg_plus.filename = [] ;


Search_Params.channel_to_analyze  = readChanNum( ch    ) ;    
Search_Params.GetFromFile = GetFromFile  ;
Arg_plus.GetFromFile = GetFromFile  ;

Search_Params.AutoPostStim = AutoPostStim ;
Arg_plus.LFP_stim_num = LFP_stim_num_arr ; 
handles.LFP_stim_num = LFP_stim_num_arr ; 
Search_Params.LFP_stim_num = LFP_stim_num_arr ; 


Search_Params.leave_or_erase_artifacts = GLOBAL_const.leave_or_erase_artifacts  ; % after load artifact erase or leave only some
Search_Params.erase_artifacts   = GLOBAL_const.erase_artifacts  ;
Search_Params.leave_or_erase_every_artifact_period   = GLOBAL_const.leave_or_erase_every_artifact_period  ; % if 6 - then erase 1 ,6 ,12 ... artifact (or leave)

Search_Params.TimeBin = TimeBin ;
Search_Params.AWSR_sig_tres = AWSR_sig_tres ;
% Search_Params.Search_Params = Search_Params ;


% Search_Params.PostStim  = PostStim ;
% Search_Params.DT_bin = str2num( x{1} );
% Search_Params.PosStim_Interval_start = str2num( a );
% Search_Params.PosStim_Interval_end = str2num( a_to );
% Search_Params.Artefact_channel = str2num( art_c ); 

    
    
    
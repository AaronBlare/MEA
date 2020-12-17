
% Post_stim_response_params_GUI_input

a = get(handles.edit15,'String'); 
a_to = get(handles.edit23,'String'); 
x = get(handles.text19DT_bin,'String'); 
art_c = get(handles.edit22Artc,'String'); 
 
    Take_all_spikes_after_stim = true ;
    Params.Analyze_preceding_spont_bursts = false ;

     if (get(handles.checkbox5msBin,'Value') == get(handles.checkbox5msBin,'Max'))
       % Checkbox is checked-take approriate action
       checkbox5msBin = true ;  
    else
       checkbox5msBin = false ;

     end 
     Params.Small_PSTH_bin =  5 ;
      if (get(handles.checkboxAdjust,'Value') == get(handles.checkboxAdjust,'Max'))
       % Checkbox is checked-take approriate action
       Params.Adjust_artefact_times = true ;
       % Adjusts artifact times using 1 ms bin AWSR of raster -> finds max of
       % AWSR around each artifact time +- 1000 ms.
      else
       Params.Adjust_artefact_times =  false ;
      end 

    b = get(handles.edit_Response_threshold2,'String'); 
    Params.Spike_Rates_each_burst_cut_Threshold_precent  = str2num( b );

    if (get(handles.checkbox_Small_responses2,'Value') == get(handles.checkbox_Small_responses2,'Max'))
        Use_Small_response = true ;
    else 
        Use_Small_response = false ;
    end
    Params.Use_Small_response = Use_Small_response ;
    
    if (get(handles.checkboxPSTH_connect_analy,'Value') == get(handles.checkboxPSTH_connect_analy,'Max'))
        Params.Analyze_Connectivity = true ;
    else 
        Params.Analyze_Connectivity = false ;
    end 
    
    if (get(handles.checkboxOnlyFilteredResp,'Value') == get(handles.checkboxOnlyFilteredResp,'Max'))
        Params.Analyze_Connectivity_only_filtered_responses = true ;
    else 
        Params.Analyze_Connectivity_only_filtered_responses = false ;
    end     
    
    
    
    DT_bin = str2num( x{1} );
    Diap_ms = str2num( a );
    MAX_RESPONSE_DUR = str2num( a_to );
    Artefact_channel = str2num( art_c );
%-----------
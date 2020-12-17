 % LEARNING CURVE----------------------------
 % Learning_curve_from_RS_thresh_percent
 
 % Input :
%  N=64;
% Selected_channel = Arg_file.Channel_num_for_Learn_curve ;
% RS_thrshold_percent = Arg_file.RS_threshold_percent ;  
% Channel_artefacts = 1 ;
% InterTrialPeriod = 50000 ; 
% artifacts_num = length( artefacts) ; 
%  
%Output :
% Learning_curve_artefacts_num
% Learning_curve
 
Start_trial_artfefact_nums = 1 ;
End_trial_artfefact_nums = 2 ;
Use_default_cycle_time = true ;
    Default_Cycle_Time = 600 ;

  Trial_Starts_Ends_nums = [ 1 ; 1  ] ; 
  Trials_num = 1 ;
     for i=1:  length( artefacts   )-1 
       if artefacts(i+1)-artefacts(i) > InterTrialPeriod 
           Trial_Starts_Ends_nums(End_trial_artfefact_nums,(Trials_num)) = i ;
           Trials_num = Trials_num + 1 ;
           Trial_Starts_Ends_nums(Start_trial_artfefact_nums, ( Trials_num ) )= i + 1 ; 
       end
     end
    Trial_Starts_Ends_nums( End_trial_artfefact_nums,(Trials_num)) = i ;
     
     Trials_num
Trial_Starts_Ends_nums

% find single lonely artifacts
single_artfeacts = find( Trial_Starts_Ends_nums( End_trial_artfefact_nums, :) ...
        ==  Trial_Starts_Ends_nums( Start_trial_artfefact_nums, :));
single_artfeacts 
Trial_Starts_Ends_nums( : , single_artfeacts )=[];
Trial_Starts_Ends_nums
Trials_num = Trials_num - length( single_artfeacts );


% POST_STIM_RESPONSE.RS_all_channels_all_responses  ( Ns x 64 )
%------------- find RS threshold value 
a=sort(POST_STIM_RESPONSE.RS_all_channels_all_responses( : , Selected_channel)) ;
RS_threshold_value = a( floor(artifacts_num*(1-RS_thrshold_percent/100) ) ) 
 %-------------------------

%-- Learning curve find
Learning_curve_artefacts_num = zeros(Trials_num , 1 )  ;
Learning_curve = zeros(Trials_num , 1 ) ;
for tri= 1 : Trials_num
   % time to reach RS value    
    Adapt_time = find(  POST_STIM_RESPONSE.RS_all_channels_all_responses(  ...
        Trial_Starts_Ends_nums( Start_trial_artfefact_nums ,( tri )) : ... 
        Trial_Starts_Ends_nums( End_trial_artfefact_nums,( tri )), Selected_channel) >= RS_threshold_value  , 1) ;
    if  isempty( Adapt_time )
        if  Use_default_cycle_time  
           Adapt_time = Default_Cycle_Time  ;
           
        else 
           Adapt_time = Trial_Starts_Ends_nums( End_trial_artfefact_nums,( tri )) ...
              - Trial_Starts_Ends_nums( Start_trial_artfefact_nums,( tri )) ;
        end
        Learning_curve( tri ) = Adapt_time ;
    else    
        Learning_curve_artefacts_num( tri ) = Adapt_time  ;      
        Adapt_time_end_stim_num = Trial_Starts_Ends_nums( Start_trial_artfefact_nums,( tri )) + Adapt_time - 1 ;
        Adapt_time_start_stim_num = Trial_Starts_Ends_nums( Start_trial_artfefact_nums,( tri )) ;        
        Adapt_time_ms = artefacts( Adapt_time_end_stim_num ) ... 
                -  artefacts( Adapt_time_start_stim_num ) ;
        Learning_curve( tri ) =  Adapt_time_ms / 1000   ;
    end
end 





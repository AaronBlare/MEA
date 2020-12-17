function [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent...
    ,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , overlap_val_STABLE_Optim_Thres_precent , is_Stable_response ...
    Zero_values_in_Data1 , Zero_values_in_Data2 ]= ...
      SelectiveValues( DATA1,DATA2, PVAL_Threshold , OVERLAP_TRES , Count_zero_values , STIM_RESPONSE_BOTH_INPUTS)
 % is_Stable_response = true -  DATA1 or DATA2 has more than
 % STIM_RESPONSE_BOTH_INPUTS*100 [e.g 80%] of non-zero values
 % Count_zero_values == false -> erases ZEROs in data sets before compare
  NOT_BOTH_STABLE_RESPONSE_overlap = 110 ; % if both data sets have number of non-zero values < STIM_RESPONSE_BOTH_INPUTS
 EMPTY_OVERLAP_AFTER_overlap_values_func = 100 ; 
    
LinearyDifferent_if1 = 0 ;

Normal_distrib = false ;

if Normal_distrib
[StatisitcallyDifferent_if1 , p ] = ttest2(DATA1,DATA2, PVAL_Threshold  );       
else
[p,StatisitcallyDifferent_if1] = ranksum(DATA1,DATA2, PVAL_Threshold  );       
end

if nargin == 5
    STIM_RESPONSE_BOTH_INPUTS = 0 ;
end  
STIM_RESPONSE_BOTH_INPUTS=STIM_RESPONSE_BOTH_INPUTS * 100 ;
          
 [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
     ,overlap_values_Optim_Thres,Zero_values_total_precent,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , ...
     Zero_values_in_Data1 , Zero_values_in_Data2 ] ...
    = Overlapping_Values(DATA1,DATA2,  Count_zero_values   ); 


% if overlap_values_Optim_Thres_precent == 0
%      [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
%      ,overlap_values_Optim_Thres,Zero_values_total_precent,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , ...
%      Zero_values_in_Data1 , Zero_values_in_Data2 ] ...
%     = Overlapping_Values(DATA1,DATA2,  Count_zero_values  , true ); 
% end

if overlap_values_Optim_Thres_precent > 100
    DATA1
    DATA2
    Optimal_Threshold
    overlap_values_Optim_Thres_precent = 100 ;
end

if isempty( overlap_values_Optim_Thres_precent ) 
    overlap_values_Optim_Thres_precent = EMPTY_OVERLAP_AFTER_overlap_values_func ; 
end



    if ~Count_zero_values
      if Zero_values_in_Data1_precent <= 100- STIM_RESPONSE_BOTH_INPUTS || Zero_values_in_Data2_precent <= 100- STIM_RESPONSE_BOTH_INPUTS
          overlap_val_STABLE_Optim_Thres_precent = overlap_values_Optim_Thres_precent ;
          is_Stable_response = true ;      

      else   
          overlap_val_STABLE_Optim_Thres_precent = NOT_BOTH_STABLE_RESPONSE_overlap ;
          is_Stable_response = false;
          overlap_values_Optim_Thres_precent= NOT_BOTH_STABLE_RESPONSE_overlap ;
          if StatisitcallyDifferent_if1 == 1 % if stst different but not stable 
              StatisitcallyDifferent_if1= 0;
          end
      end
    else
        overlap_val_STABLE_Optim_Thres_precent = overlap_values_Optim_Thres_precent ;
        is_Stable_response = true ;
    end

         if overlap_values_Optim_Thres_precent <= OVERLAP_TRES
             if Zero_values_in_Data1_precent <= 100-STIM_RESPONSE_BOTH_INPUTS || Zero_values_in_Data2_precent <= 100-STIM_RESPONSE_BOTH_INPUTS
                 LinearyDifferent_if1 = 1 ;
             else
                 LinearyDifferent_if1 = 0 ;
             end
         end
         
         

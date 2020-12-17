function [ Patterns  ]...
            = Erase_Patterns_filter( Patterns , Global_flags )
 
        
%            Global_flags.Erase_Patterns_Min_TSR = 100 ;
%             Global_flags.Erase_Patterns_Max_TSR = 1000 ;
%         
  EraseIf_tru_otherwise_put_Zero = true ;
  
               fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
               DT = Patterns.DT_bin ;
               Nb= Patterns.Number_of_Patterns ;
               N = Patterns.N_channels ;
     
                   delete_responses_index = []; 
                   for R = 1 : Nb       
                         
                         if  Patterns.Spike_Rates_each_burst( R )  < Global_flags.Erase_Patterns_Min_TSR 
                             delete_responses_index =[delete_responses_index R];
                         end
                         if  Patterns.Spike_Rates_each_burst( R )  > Global_flags.Erase_Patterns_Max_TSR 
                             delete_responses_index =[delete_responses_index R];
                         end
                         
                   end 
                  
                   
                 
                 %---------------------------------
                 
                 
              
                             responses_index = delete_responses_index ;
                             
                                 % responses_index shoulkd be defined
                                 % before call
                             Stimulus_responses_Delete_responses  
                 
                 
                 
                 
                 
                 
                 
                 
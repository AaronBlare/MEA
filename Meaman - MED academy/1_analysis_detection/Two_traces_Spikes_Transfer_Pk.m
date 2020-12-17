function  Result  = Two_traces_Spikes_Transfer_Pk( x , y , D_T  , D_T_deviation  )
% x , y  - binary traces , D_T - delay after spike , D_T_deviation)- time
% window where after D_T might be , all in frames
 

TN = length( x );
DT = D_T ;
tau = D_T_deviation ;
half_tau = floor( tau / 2 ) ;
 

X_bin_events = 0 ;
Y_bin_events_transfered = 0 ;
Y_bin_events = 0 ;
Time = 0 ;
Time_after_X_event = 0 ;

for Ti = half_tau + 1 : tau : TN - DT - tau
    if Y_bin_events > 0
      Time = Time +1 ;
    end    
  Time_after_X_event  = Time_after_X_event  + 1; 
    
    SumY = sum( y( Ti + DT - half_tau : Ti + DT + half_tau) )  ;
    if SumY > 0
      Y_bin_events = Y_bin_events + 1 ;
    end  
  SumX  = sum( x( Ti - half_tau : Ti + half_tau) )  ; 
  if SumX > 0        
  X_bin_events = X_bin_events + 1 ;  
  Time_after_X_event  = 0 ;
  
  if SumY > 0  
    Y_bin_events_transfered = Y_bin_events_transfered + 1 ;
  end  
 
  end
  
end
  

Time = Time - Time_after_X_event   ;
ss = 0 ;
Pb = Y_bin_events / Time ;
for j = 0 : Y_bin_events_transfered - 1
  ss = ss + nchoosek( X_bin_events , j )  * power( Pb , j )* ... 
        power( 1 - Pb  , X_bin_events  - j ) ;   
end

Pk = 1 - ss ;

Result = Pk  ;






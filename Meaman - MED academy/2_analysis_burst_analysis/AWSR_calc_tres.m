

function [Threshold]= AWSR_calc_tres( AWSR , AWSR_sig_tres )

Threshold = AWSR_sig_tres * std( AWSR ) ;
% Threshold = AWSR_sig_tres * 1.6 * median( AWSR ) ;
Burst_Detection_Threshold = Threshold 
end
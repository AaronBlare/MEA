//function [ M_of_tau ] = Spikes_transferred( ch1_times , ch2_times , tau_delta , tau_max , epsilon_tau  ) 
#include "mex.h"       
#include <math.h>
 

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  double* M_of_tau; 
  double* ch1_times; 
  double* ch2_times; 
  double tau_delta, tau_max, epsilon_tau ;
  size_t len_ch1_times = mxGetN(prhs[0]); 
  size_t len_ch2_times = mxGetN(prhs[1]); 
  ch1_times = mxGetPr(prhs[0]); 
  ch2_times = mxGetPr(prhs[1]); 
  tau_delta = *mxGetPr(prhs[2]);      
  tau_max = *mxGetPr(prhs[3]);    
  epsilon_tau = *mxGetPr(prhs[4]);   
  /* Create the array M_of_tau */
  plhs[0] = mxCreateDoubleMatrix( 1+floor(abs((tau_max-0)/tau_delta)),1,mxREAL);
  M_of_tau = mxGetPr(plhs[0]);   
 //double spj_time ;
 // double spi_time ;
  double M ; 
  mwSize spj_num_v_ume ;
  mwSize spj_num_new_check ;
  bool spike_found ;
  mwSize spi ; 
  
  mwSize tau_i=0;
//  if tau_max < 0 then analyze spikes recieved, otherwise -spikes transferred 
  for(mwSize d= 0 ;  abs(  d  ) <=  abs( tau_max  ) ; d=d + tau_delta * (abs( tau_max  )/tau_max)  ) {
    M = 0 ;  
    spj_num_v_ume =0 ;
    for(  spi=0; spi < len_ch1_times; spi++) 
    {
            
        spike_found = false ;
        
         
        for( spj_num_new_check =spj_num_v_ume; spj_num_new_check < len_ch2_times; spj_num_new_check ++){
//            if ( !spike_found)
            {
                if ( ch1_times[spi ] <   ch2_times[ spj_num_new_check ] -  d + epsilon_tau     ){
                    spike_found = true ;
                    spj_num_v_ume = spj_num_new_check ;
                    break ;
                };
            };
        };
        
        if ( spike_found  ){
           if ( ch1_times[spi ] >= ch2_times[ (int)spj_num_v_ume ]- d - epsilon_tau    ){ 
//               if (spi==2)   M =  spj_num_v_ume  + 1 ;
                M++ ;
//                 M = epsilon_tau   ;
           };
        };
        
//         if ( !spike_found )
//         {
//             if ((spi ==0)  ){
//                M = -1 ;
//             };
// //            if (spi ==0) M = 1 ;
//            if ( ch1_times[spi ] < ch2_times[ spj_num_v_ume ] + epsilon_tau + d ){
//                
// //                  M = spj_num_v_ume ;
//                 if ((spi ==0)  ){
//                    M = spj_num_v_ume ;
//                 };
//            };
//         };
//               if ( spike_found )
//               { break ; };
               
                  
             
                
        
//           for(mwSize spj=0; spj< len_ch2_times; spj++){
//        //       spj_time  = ch2_times[spj ];
//               if (( ch1_times[spi ] >= ch2_times[spj ] - epsilon_tau + d ) && ( ch1_times[spi ] < ch2_times[spj ] + epsilon_tau + d )){   
//                     M = M + 1 ;   
//               }; 
//                
//           };
         
        
    };   
    M_of_tau[ tau_i ] = M ; 
    
    tau_i++ ;
  
  };
  
  
  
  
  
}




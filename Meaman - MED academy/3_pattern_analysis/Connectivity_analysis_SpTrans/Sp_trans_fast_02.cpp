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
  mwSize spi ; 
//   bool spike_found ; 
  mwSize eps_i;
          
   int  spike_should_be_here ;
  mwSize tau_i=0;
  for(mwSize d= 0 ;  abs(  d  ) <=  abs( tau_max  ) ; d=d + tau_delta * (abs( tau_max  )/tau_max)  ) {
    M = 0 ;  
    for( spi=0; spi < len_ch1_times; spi++) 
//     spi=0 ;
    { 
//          spike_found = false ;           
//          
        for( eps_i = -  epsilon_tau + 0  ; eps_i <   epsilon_tau  ; eps_i++)
//             mwSize eps_i=0;
        {
//             double time = (double) ;
//             time = time / 0.1 ;
//             if (spike_found ==false)
            {
                spike_should_be_here =(   ch1_times[spi ]  +   d + eps_i  - 1  ) ;
                if (( spike_should_be_here < len_ch2_times   )&&(spike_should_be_here > 0 )){
                    if (ch2_times[  spike_should_be_here ] == 1 ){
                        M++ ;
//                         spike_found = true ;
                        break ;
                    }
                }; 
            };
            
//             if (spike_found){
//                 break ;
//             };
               
            
        };   
//      
    
//               for(mwSize spj=0; spj< len_ch2_times; spj++)
//               {
//        //       spj_time  = ch2_times[spj ]; 
//                   if (( ch1_times[spi ] >= ch2_times[spj ] - epsilon_tau + d ) && ( ch1_times[spi ] < ch2_times[spj ] + epsilon_tau + d ))
//                   {   
//                       if ( ch2_times[spj ] == 1 ) 
//                       {
//                       M = M + 1 ;
//                       break;
//                       };
//                   };
//               }; 
               
          };
    
    M_of_tau[ tau_i ] = M ; 
    
    tau_i++ ;
  
  };
  
  
  
  
  
}




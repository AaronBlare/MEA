//function [  Connectiv_matrix  M_of_tau ] = Spikes_transferred_all_data2( ch_i_interval_start , ch_i_interval_end , tau_delta , ...
//    tau_max , epsilon_tau , Nb , N ,MaxSpikesPerChannelPerBurst ,Data_times , Total_Spike_Rates ,  Conn_Spikes_num_min ) 
#include "mex.h"       
#include <math.h>
 

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  double* M_of_tau; 
  double* Total_Spike_Rates; 
  double* Data_times; 
  double* Connectiv_matrix ; 
  int ch_i_interval_start , ch_i_interval_end ;
  double tau_delta, tau_max, epsilon_tau ;
  int Nb , N , MaxSpikesPerChannelPerBurst ;
  int Conn_Spikes_num_min ;
  double spi_time , spj_time ;
  ch_i_interval_start = *mxGetPr(prhs[0]); 
  ch_i_interval_end = *mxGetPr(prhs[1]); 
  tau_delta = *mxGetPr(prhs[2]);      
  tau_max = *mxGetPr(prhs[3]);    
  epsilon_tau = *mxGetPr(prhs[4]);  
  Nb = *mxGetPr(prhs[5]); 
  N =  *mxGetPr(prhs[6]);  
  MaxSpikesPerChannelPerBurst = *mxGetPr(prhs[7]);
  Data_times = mxGetPr(prhs[8]);    
  Total_Spike_Rates = mxGetPr(prhs[9]);     
  Conn_Spikes_num_min = *mxGetPr(prhs[10]); 
  /* Create the array M_of_tau */
//  plhs[0] = mxCreateDoubleMatrix( 1+floor(abs((tau_max-0)/tau_delta)),1,mxREAL);
 int ch_i_1 = ch_i_interval_start ;
 int ch_i_2 = ch_i_interval_end ; 
 
   int tau_number = 1+floor(abs((tau_max-0)/tau_delta)) ;
 
//   mwSize dims[]={ ch_i_2 - ch_i_1 + 1 ,N , tau_number   }; 
//   mwSize dims[]={ch_i_interval_end - ch_i_interval_start ,N , tau_number   };  
//   plhs[0] =  mxCreateNumericArray(3, dims, mxDOUBLE_CLASS,mxREAL); 
  plhs[0] =  mxCreateDoubleMatrix( tau_number*N*(ch_i_2 - ch_i_1 + 1 )   ,1,mxREAL);  

  
//  M_of_tau = mxGetPr(plhs[0]);   
  Connectiv_matrix = mxGetPr(plhs[0]) ;  
  
   
  plhs[1] = mxCreateDoubleMatrix( tau_number  ,1,mxREAL);  
  M_of_tau = mxGetPr(plhs[1]); 
  

 double M ;     
  int ch_i = N-1 ;
 int ch_j = N-1 ; 
 int ch_i_in_matrix = 0 ;
 int ch_i_index_from_0 = 0 ; 
 int tau_buf_i = 0 ; 
 
  
  
  int chanPos = N*MaxSpikesPerChannelPerBurst   ;
  int spikeX =  N ;
//   #define  Data_times(i,j, k) Data_times[(i)*chanPos+ (j) + (k)*spikeX ] 
  #define  Data_times(j, k) Data_times[ (j)*MaxSpikesPerChannelPerBurst + (k) ] 
  #define  Connectiv_matrix( ch_i , ch_j , tau_i )  Connectiv_matrix[(ch_i)*N + (ch_j) +(tau_i)*N*(ch_i_2 - ch_i_1 + 1 )  ] 

  
//  for ( ch_i  = ch_i_interval_start-1 ;  ch_i <= ch_i_interval_end-1  ; ch_i++ ) {
 for ( ch_i = ch_i_1 ;  ch_i <= ch_i_2  ; ch_i++ ) {
     
    for ( ch_j = 0 ;  ch_j < N  ; ch_j++ ) {        
   
  
          int tau_i=0;    
          for (int tau_buf_i0 =0 ; tau_buf_i0 < tau_number ; tau_buf_i0++ ) {
                M_of_tau[ tau_buf_i0 ] = 0 ;  
            }
          
      if (ch_i != ch_j ){   
         if ( Total_Spike_Rates[ch_i] > Conn_Spikes_num_min && Total_Spike_Rates[ch_j] > Conn_Spikes_num_min){
                mwSize tau_i=0;
                double d = 0 ;
                for(mwSize dd= 0 ;  dd <  tau_number ; dd =dd + 1 ) {
                    
                    M = 0 ;  
                    for(int Nb_i =0; Nb_i < Nb ; Nb_i++) 
                    {

//                         int Nb_i=0;
                                for(int spi=0; spi < MaxSpikesPerChannelPerBurst ; spi++) {
                                 //   spi_time  = ch1_times[spi ];
                                      spi_time  =   Data_times( ch_i ,spi) ;
                                    if  (spi_time > 0 ) {

                                      for(mwSize spj=0; spj< MaxSpikesPerChannelPerBurst ; spj++){
                                          spj_time  =  Data_times(  ch_j , spj) ;
                                        if ( spj_time > 0 )  {
                                           //       spj_time  = ch2_times[spj ];
                                                  if (( spi_time >= spj_time - epsilon_tau + d ) && ( spi_time < spj_time + epsilon_tau + d )){   
                                                        M = M + 1 ;   
                                                  };  
                                        };
                                      };  
                                    };
                                };   
                                
                    }; //for(int Nb_i 
                    M_of_tau[ tau_i ] = M ;  
                     tau_i++ ; 
                     
                    d = d + tau_delta ; 
                  };
         }; //if ( Total_Spike_Rates[ch_
      };
     tau_i=0;
     
       for (int tau_buf_i0 =0 ; tau_buf_i0 < tau_number ; tau_buf_i0++ ) {   
          Connectiv_matrix( ch_i_in_matrix , ch_j , tau_buf_i0 ) = M_of_tau[ tau_buf_i0 ] ;  
        };
  
    }; //ch_j    
    ch_i_in_matrix++ ;
 };
     
     
        for (int tau_buf_i0 =0 ; tau_buf_i0 < tau_number ; tau_buf_i0++ ) {   
           M_of_tau[ tau_buf_i0 ]  = Data_times( 0  ,tau_buf_i0)  ;  
        };    
     
     
     
     
     
//       
//   for (int tau_buf_i0 =0 ; tau_buf_i0 < tau_number ; tau_buf_i0++ ) {
// //     M = Data_times( 0 , 1 , tau_i) ;  
// // //       
// //     M_of_tau[ tau_i ] = M ; 
// //     for (int ch_j = 0 ;  ch_i < N  ; ch_j++ ) {     
//     Connectiv_matrix( ch_i , ch_j , tau_buf_i0 ) = M_of_tau[ tau_buf_i0 ] ;  
//   };
// //    M_of_tau[ 0 ] = tau_number*N*N ; //(N )*N*N + (N)  +( tau_number )*N ;
//   

   
}




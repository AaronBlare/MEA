//function [ sigma_ij (connection j->i if lag<0) ] = two_channels_cpp(h, j_n, SpAtI, delay_l,delay_r, d_step, fuzz)
#include "mex.h"       
#include <math.h>

double max(double a, double b) {
  return (a<b)?b:a;
};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  double* sigma;
  //double *i_n, *j_n;
  double *j_n;
  double* SpAtI;
  double h, delay_l, delay_r, d_step, fuzz;
  size_t len_i_n = mxGetM(prhs[1]);
  size_t len_SpAtI = mxGetM(prhs[2]);
  h = *mxGetPr(prhs[0]); 
  //i_n = mxGetPr(prhs[1]);
  j_n = mxGetPr(prhs[1]);      
  SpAtI = mxGetPr(prhs[2]);
  delay_l = *mxGetPr(prhs[3]);
  delay_r = *mxGetPr(prhs[4]);
  d_step = *mxGetPr(prhs[5]);
  fuzz = *mxGetPr(prhs[6]);
  mwSize ds=floor(d_step/h);
  mwSize dl=floor(delay_l/h);
  mwSize dr=floor(delay_r/h);
  mwSize fz=floor(fuzz/h);   
  /* Create the array */
  plhs[0] = mxCreateDoubleMatrix(1+floor(abs((delay_r-delay_l)/d_step)),1,mxREAL);
  sigma = mxGetPr(plhs[0]);  
  mwSize kl, kr, k;
  mwSize st;  

  if(len_SpAtI==0) {
    return;
  };
  mwSize ind=0;

  int i_sp;
  double ij_sp;
  
  for(mwSize d=dl; abs(d)<=abs(dr); d=d+ds) {
    if (d<0) {
      kl=1-d+fz;
      kr=len_i_n-fz;
    } else {
      kl=1+fz;
      kr=len_i_n-d-fz;
    };
    i_sp=0;
    ij_sp=0;
    for(mwSize z=1; z<=len_SpAtI; z++) {
      k=SpAtI[z-1];
      if ((k>kl) && (k<=kr)) {
        i_sp=i_sp+1;
        st=k+d;
        double wgh=0;
        for(mwSize s=st-fz; s<=st+fz; s++) {
          if (j_n[s-1]>0) {
            wgh=max(exp(-(double)abs(s-st)/((double)fz/2.0)), wgh);
            //wgh=max(exp(-(double)(s-st)*(s-st)/(2*fz*fz/4)), wgh);            
            //wgh=max(1, wgh);
          };
        };      
        ij_sp=ij_sp+wgh;                
      };
    }; 
    if (ij_sp>0) {
      sigma[ind]=ij_sp/(double)i_sp;
    } else {
      sigma[ind]=0;
    };
    ind++;
  };  
}
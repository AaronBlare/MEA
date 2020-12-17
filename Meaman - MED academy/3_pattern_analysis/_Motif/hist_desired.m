
function [ counts , xxx ] = hist_desired( DATA , step )
xxx =  0 : step : 100 ;
 [counts,x] = histc(DATA ,xxx); 
  counts=100* counts/ length( DATA );
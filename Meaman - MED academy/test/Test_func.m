
% Test_func
 name = '2013_03_17-15_02_2013_h1_gentam-02_stim09_10min__Nlearn_RASTER.mat'  
 k=  strfind(   name , '-')   ;
 h =  strfind(   name( k(1)+1:k(2)) , '_')   ;
  
 Exp_date =  name(1:k(1)-1) 
 Culture_date =  name( k(1)+1: k(1)+h(3)-1 ) 
 Culture_label = name(  k(1)+h(3)+1 : k(2) -1) 








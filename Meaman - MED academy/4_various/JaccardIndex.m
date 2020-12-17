function  JaccardIndex_1  = JaccardIndex(  X , Y , DELTA_D )



% DELTA_D = 200 ;
% Rstep = (median(Global_R_set1_to_center_mass)  +mad(Global_R_set1_to_center_mass,1)) / Ndis_Precision ; 
Rstep = ( max(max(X),max(Y) - ...
    min(min(X),min(Y) )))/ DELTA_D ;
di =0 ;glob = 0; glob_2 =1 ;glob_3=1;
for Ri = 1 : Rstep : max(max(X),max(Y))
    x = length( find( X > Ri & X <= Ri+Rstep ));
    y = length( find( Y > Ri & Y <= Ri+Rstep ));
    di = di+min(x,y);
    glob = glob +max(x,y);    
    glob_2 = glob_2 + y ;    
    glob_3 = glob_3 + x ;    
end
Jaccard_DistancesSet1Set2_similarity = di / glob ;
Pattern_Dissimilarity_Jaccard_S1crossS2byS2 = di / glob_2 ;
JaccardIndex_1 = di / ( glob_2 + glob_2 );



 
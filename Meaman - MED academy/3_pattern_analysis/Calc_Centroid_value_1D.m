
function centroid_values_1D = Calc_Centroid_value_1D( Data )


centroid_values_1D = mean(  Data   );
% centroid_values_1D = mean(  Data( Data > 0 )  );
if isnan( centroid_values_1D )
    centroid_values_1D= 0 ;
end
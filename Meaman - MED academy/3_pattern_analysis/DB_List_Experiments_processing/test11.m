 
dx=0;
SVM_accuracy_all=[];
KMeans_accuracy_all=[];

dx=0;
NN=12 ;
NN2=20 ;
N= 2 ;
DD = [] ;
for dx=0:0.1:4

Data1 = randn(100,1);
Data2 = randn(100,1) + dx ; 

[ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
    ,overlap_values_Optim_Thres , Zero_values_total_precent,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent] = Overlapping_Values(Data1,Data2,  false   );
% OO=[OO overlap_values_Optim_Thres_precent ];
overlap_values_Optim_Thres_precent

DD=[DD dx]; 


Data1 = randn(NN,N);
Data2 = randn(NN2 ,N)+  dx  ;

[ SVM_accuracy , SVM_error_points_precent , Not_distinguishable_points_num_E] = SVM_check_accuracy_1D_data( Data1 , Data2 , NN , NN2 , N );
SVM_error_points_precent
SVM_accuracy
SVM_accuracy_all=[SVM_accuracy_all SVM_accuracy];
% Data1 = randn(NN,4);
% Data2 = randn(NN-2,4)+1.2;

[ KMeans_Not_distinguishable_points_num , KMeans_Clustering_error_precent , KMeans_accuracy]   = Clustering_accuracy_2clusters( Data1,Data2  );
KMeans_Clustering_error_precent
KMeans_accuracy
KMeans_accuracy_all=[KMeans_accuracy_all KMeans_accuracy];

close all
end
SVM_accuracy_all
KMeans_accuracy_all

figure 
plot(    DD ,SVM_accuracy_all)
title( 'SVM_accuracy_all')

figure 
plot(   DD ,KMeans_accuracy_all)
title( 'KMeans_accuracy')
close all


% test_stat

N=1000 ;

DBI = [] ;
ERR = [];
O = [] ;
O2 = [] ;
err = 0.2;
clusters_last = [] ;

for err = 0: 1:200   

    DATA1=floor( 3*randn( N,1))+ 0  ;
    DATA2=floor( 32*randn( N,1))+ err  ; 

    data= [ DATA1 ; DATA2 ] ;
    labels = [ 1* ones( N,1)   2*ones(N,1)] ;


    [centers,clusters,errors,ind] = kmeans_clusters( data , 2 );
    
     [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
    ,overlap_values_Optim_Thres , Zero_values_total_precent,Zero_values_in_a1_precent,Zero_values_in_a2_precent , ...
    Zero_values_in_a1 , Zero_values_in_a2 ] =Overlapping_values( DATA1 , DATA2 ,true );

O = [ O overlapped_valuse_precent];

clusters = clusters{2,1};
clusters_last=clusters ;
Data1= data( clusters == 1);
Data2= data( clusters == 2);

     [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
    ,overlap_values_Optim_Thres , Zero_values_total_precent,Zero_values_in_a1_precent,Zero_values_in_a2_precent , ...
    Zero_values_in_a1 , Zero_values_in_a2 ] =Overlapping_values( Data1 , Data2 ,true );

    DBI = [ DBI ind(2)];
    ERR = [ ERR errors(2)];
        
        O2 = [ O2 overlapped_valuse_precent];
end


figure   
plot(DBI)
title('dbi')
figure
plot( ERR , 'r') 
figure
hold on
plot( O)
plot( O2 , 'r')
hold off
legend( 'Overlap', 'Overlap after k-means')
title('o')


clusters = clusters_last{2,1};
Data1= data( clusters == 1);
Data2= data( clusters == 2);


figure
subplot(1,2,1)
hist( [ DATA1 ; DATA2 ] , 50 ) 

subplot(1,2,2)
hold on
plot( Data1 )
plot( Data2,'r' )
hold off

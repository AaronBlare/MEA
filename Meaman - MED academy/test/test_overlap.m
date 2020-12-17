% test_overlap
clear
close all

DATA1=floor( 3*randn( 100,1))+ 7  ;
DATA2=floor( 3*randn( 100,1))+ 13  ;
figure 
plot( [DATA1 DATA2 ] , '*-')

Count_zero_values = false ;
all_data = [DATA1 ; DATA2 ];
%  [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
%      ,overlap_values_Optim_Thres,Zero_values_total_precent,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , ...
%      Zero_values_in_Data1 , Zero_values_in_Data2 ] ...
%     = Overlapping_Values2(DATA1,DATA2,  false   )  

 [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
    ,overlap_values_Optim_Thres , Zero_values_total_precent,Zero_values_in_a1_precent,Zero_values_in_a2_precent , ...
    Zero_values_in_a1 , Zero_values_in_a2 ] =Overlapping_values( DATA1 , DATA2 , Count_zero_values , true );

overlapped_values
overlapped_valuse_precent
Optimal_Threshold

 
 if Count_zero_values 
   ss1= find(DATA1==0);
   ss2= find(DATA2==0);  
   DATA1(ss1) = [];
   DATA2(ss2) = []; 
     
 end

figure
subplot(1,2,1)
% hist( [ DATA1  DATA2 ] , 100 )
subplot(1,2,2)
hold on
plot(  DATA1     , '*-')
plot(    DATA2  , 'r*-')
plot( [1 length(DATA1)],  [Optimal_Threshold Optimal_Threshold] , 'r')
hold off




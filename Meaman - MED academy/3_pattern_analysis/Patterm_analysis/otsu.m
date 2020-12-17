function [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
    ,overlap_values_Optim_Thres , Zero_values_total_precent,Zero_values_in_a1_precent,Zero_values_in_a2_precent , ...
    Zero_values_in_a1 , Zero_values_in_a2 ] = Overlap_values3(a1 , a2 , Count_zero_values  )
% Overlap between 2 data sets
% works for integerv values only
% threshold defines 2 sets

% overlapped_values - number of not unique values using middle of clusters


MAIN_INTERVAL = 0.5 ;

b=[a1 ; a2 ];
[c,d]=size(b);
b=reshape(b,[],1);
[m,n]=size(b);
s1 = length( a1);
s2 = length( a2);

A=diff( sort( b) );
A(A==0)=[];
% Interval_step =   min( A  )  ; 
Interval_step =    1 ; 
Interval_min = min(b)+ MAIN_INTERVAL ;
Interval_max = max( b)-1 ;
Interval_numbers = abs( floor( (Interval_max - Interval_min)/ Interval_step ));



Zero_values_total_precent = 0 ;

   Zero_values_in_a1 = find(a1==0); 
   Zero_values_in_a2 = find(a2==0);  
   Zero_values_in_a1 = length(Zero_values_in_a1 ) ; 
   Zero_values_in_a2 = length(Zero_values_in_a2 );  
   Zero_values_in_a1_precent = 100 *  Zero_values_in_a1  / length( a1);
   Zero_values_in_a2_precent = 100 *  Zero_values_in_a2  / length( a2);

if Count_zero_values == false 
   ss1= find(a1==0);
   ss2= find(a2==0); 
   Zero_values_total_precent = ( length( ss1) + length( ss2) ) / ( length( a1) + length( a2)) ;
   a1(ss1) = [];
   a2(ss2) = []; 
end 


% Otsu code
% weightb=zeros(3, Interval_numbers );
% weightf=zeros(3,Interval_numbers );
 

Class1_errors=zeros( 2,Interval_numbers  );
Class2_errors=zeros( 2,Interval_numbers  );
Points_left_to_Thr=zeros( 2,Interval_numbers  );
Points_rigth_to_Thr=zeros( 2,Interval_numbers  );

r=1;
l=1;
    x = [];
for T= Interval_min:Interval_step:Interval_max
    x=[x T ];
    
    % Otsu code
%     [wb,wf,mb,mf,vrb,vrf]=cal(T,b,m);
%     weightb(1,r)=wb;
%     weightb(2,r)=mb;
%     weightb(3,r)=vrb;
%     
%     weightf(1,l)=wf;
%     weightf(2,l)=mf;
%     weightf(3,l)=vrf;
    
    
    
 %--- Overlap----------------   
    [c1,i1] = find( a1 > T );
    [c2,i2] = find( a2 < T );
    Class1_errors(1, r ) = length( c1);
    Class2_errors(1, r ) = length( c2);
    
    [c1,i1] = find( a1 < T );
    [c2,i2] = find( a2 > T );
    Class1_errors(2, r ) = length( c1);
    Class2_errors(2, r ) = length( c2);
 %-------------------------------  
    r=r+1;
    l=l+1;
end
min_class_erros_r1 = min( [Class1_errors(1,: )'  Class2_errors(1,: )' ] , [] ,2);
min_class_erros_r2 = min( [Class1_errors(2,:)'  Class2_errors(2,:)' ] , [] ,2); 
min_class_erros = [ min_class_erros_r1  min_class_erros_r2 ];

   if max( min_class_erros_r1 ) < max( min_class_erros_r2 ) 
      [ max_error , Threshold_o_num  ] = max( min_class_erros_r1 );
      Class_num  = 1 ;
   else
      [ max_error , Threshold_o_num  ] = max( min_class_erros_r2 );
      Class_num  = 2 ;
   end 
   
    errors_graph = [ Class1_errors(Class_num,: )' Class2_errors(Class_num,: )' ] ;
   Max_errors = max( errors_graph ,[], 2 ); 
   [c,Threshold_o_num]= min( Max_errors );
   
   
   Class1_errors_num_points = Class1_errors(1,Threshold_o_num ) ;
   Class2_errors_num_points = Class2_errors(1,Threshold_o_num ) ;
   overlapped_values = Class1_errors_num_points + Class2_errors_num_points 
   
  Threshold_o =  Threshold_o_num * Interval_step + Interval_min-1 ;
  
  
  
figure
Nx = 1;Ny=3;
subplot( Ny,Nx,1) 
    hold on

    plot( x,Class1_errors( 1,:) ,'*-' )
    plot( x,Class2_errors( 1,:) ,'r*-'  )
    plot( x, min_class_erros_r1 +0.1, 'g' ) 
     legend('a1','a2', 'min'  )
    hold off
subplot( Ny,Nx,2) 
    hold on 
    plot( x,Class1_errors( 2,:) ,'*-' )
    plot( x,Class2_errors( 2,:) ,'r*-'  ) 
    plot( x, min_class_erros_r2+0.1 , 'm' )
     legend('a1','a2', 'min2')
    hold off
subplot( Ny,Nx,3)     
  plot( x , Max_errors )
   
% subplot( Ny,Nx,2)
k = Threshold_o;


% Otsu code
% %Within class variance
% wcv=zeros(1, Interval_numbers );
% for g=1: Interval_numbers 
% wcv(1,g)=((weightb(1,g)*weightb(3,g))+((weightf(1,g)*weightf(3,g))));
% end
% 
% % min(wcv)
% [threshold_value,val]=min(wcv) ;
% threshold_value
% val
 
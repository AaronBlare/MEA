function [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , overlap_values_Optim_Thres_precent ...
    ,overlap_values_Optim_Thres , Zero_values_total_precent,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent , ...
    Zero_values_in_Data1 , Zero_values_in_Data2 ] ...
    = Overlapping_Values( Data1 , Data2 , Count_zero_values    )
 % overlapped_values - number of not unique values using middle of clusters
 % as overlap
 % How many similar overlapping values share 2 vectors, Optimal_Threshold -
 % value to separate sets, overlap_values_Optim_Thres_precent - how many
 % values not separated using Optimal_Threshold
 
 CALC_ACCURACY = false ; % false == calc overlap, true - calc accuracy
 
 overlapped_values =0;
 overlapped_valuse_precent =0;
Optimal_Threshold =0;
overlap_values_Optim_Thres_precent = 50 ; % maximum overlap = 50%
overlap_values_Optim_Thres = 0 ;
 
Zero_values_total_precent = 0 ;

   Zero_values_in_Data1 = find(Data1==0); 
   Zero_values_in_Data2 = find(Data2==0);  
   Zero_values_in_Data1 = length(Zero_values_in_Data1 ) ; 
   Zero_values_in_Data2 = length(Zero_values_in_Data2 );  
   Zero_values_in_Data1_precent = 100 *  Zero_values_in_Data1  / length( Data1);
   Zero_values_in_Data2_precent = 100 *  Zero_values_in_Data2  / length( Data2);

if Count_zero_values == false 
   ss1= find(Data1==0);
   ss2= find(Data2==0); 
   Zero_values_total_precent = ( length( ss1) + length( ss2) ) / ( length( Data1) + length( Data2)) ;
   Data1(ss1) = [];
   Data2(ss2) = []; 
end 

x_size=length(Data1); 
y_size=length(Data2); 
 
if x_size > 1 &  y_size>1
 e1S2=0;e1S1=0;
 
 Zero_values_total_precent = 100*Zero_values_total_precent / (x_size+y_size) ;
 if CALC_ACCURACY
Zero_values_total_precent=100 - Zero_values_total_precent ;
end
 
% whos maxD

if max(Data1) < max(Data2)
   if min(Data1) < min(Data2)
   e1S2 = length( find( Data2 < max(Data1) ) );
   e1S1 = length( find( Data1 > min(Data2 ) ) );
   else
     e1S2 = length( find( Data2 < max(Data1) &  Data2 > min(Data1) ) );
     e1S1 = length( find( Data1 > min(Data2 ) ) ); 
   end
else
   if min(Data1) > min(Data2)
   e1S2 = length( find( Data2 > min(Data1) ) );
   e1S1 = length( find( Data1 < max(Data2 ) ) );
   else
       e1S2 = length( find( Data2 > min(Data1)   ) );
       e1S1 = length( find( Data1 < max(Data2 ) &  Data1 > min(Data2) ) );
   end
end
  
overlapped_values = e1S2 + e1S1 ;
if e1S1 > 0
     Data1;
     Data2;
     e1S2;
     e1S1;
end
if max(Data1) == max(Data2) & min(Data1) == min(Data2)
   overlapped_values=length( Data1 ) + length( Data2 );
end
overlapped_valuse_precent = 100 * overlapped_values / ( length( Data1 ) + length( Data2 ) );
overlapped_valuse_precent;



 minD = min( min( Data1) , min(Data2 ) ) ;
 maxD = max( max( Data1 ) , max(Data2 ) );
 
 if maxD > minD
  
   
Not_distinguishable_points_num_E=[];
Sum_Error=[];
  OriginClass = ones( 1, length(Data1)    );
    OriginClass ;
    OriginClass = [OriginClass 2*ones( 1, length(Data2)   ) ]; 
T=1; cc=[];cv=[];TT=[];
cluster_index = ones( 1,  length(Data1) + length(Data2) ); 
for T = minD : abs(maxD-minD)/  100  :maxD 
    cluster_index(:)=1;
    TT=[TT T];
    s1 =  Data1 > T  ;
    s2 = length(Data1) + find( Data2 > T ) ;
    cluster_index( s1 ) = 2 ;
    cluster_index( s2 ) = 2 ; 
    [ldaResubCM,grpOrder] = confusionmat( cluster_index  ,  OriginClass );
%     ldaResubCM
    [ ErrX , ErrX_index ] = min( ldaResubCM( : , 1 ));
    [ ErrY , ErrY_index ] = min( ldaResubCM( : , 2 ));
    
    if ErrX < ErrY
        ss=find( ldaResubCM( : , 1 ) ==ErrX );
        if length( ss ) >1
            ErrY = min( ldaResubCM( ss , 2 ) );
        else
            if ErrX_index == 1 
              ErrY =   ldaResubCM( 2 , 2 );
            else 
              ErrY =   ldaResubCM( 1 , 2 );
            end
        end
    else
       ss=find( ldaResubCM( : , 2 ) ==ErrY );
        if length( ss ) >1
            ErrX = min( ldaResubCM( ss , 1 ) );
        else
            if ErrY_index == 1 
              ErrX =   ldaResubCM( 2 , 1 );
            else 
              ErrX =   ldaResubCM( 1 , 1 );
            end
        end 
        
    end
    
    %     ErrY = min( ldaResubCM( : , 2 ));
%     ErrX
%     ErrY

    Not_distinguishable_points_num_E = [Not_distinguishable_points_num_E abs(ErrX -  ErrY) ]  ;
    Sum_Error=  [Sum_Error  (ErrX +   ErrY) ] ;
    cc = [cc  ErrY ]  ;
    cv = [cv ErrX ]  ;
end
[m,mi]=max(cc);[m2,mi2]=max(cv);

% figure
% hold on
% plot( TT , Not_distinguishable_points_num_E )
% hold off
% title( 'ERR' )

ERRORS_diff = Not_distinguishable_points_num_E(  min( mi , mi2 ) : max( mi , mi2 ) );
ERRORS = Sum_Error(  min( mi , mi2 ) : max( mi , mi2 ) );
Not_distinguishable_points_num_E(  max( mi , mi2 ) : end )=[];
newTT = TT(  min( mi , mi2 ) : max( mi , mi2 ) );
[m,Threshold_i] = min( ERRORS_diff ) ;
Threshold_i;
Optimal_Threshold = newTT( Threshold_i );
overlap_values_Optim_Thres= ERRORS( Threshold_i );
if ~isfinite( overlap_values_Optim_Thres );
    overlap_values_Optim_Thres = 0 ;
end
ERRORS( Threshold_i ) ;
overlap_values_Optim_Thres_precent = 100 * ERRORS( Threshold_i ) / ( length( Data1 ) + length( Data2 ) );

if CALC_ACCURACY
overlap_values_Optim_Thres_precent=100 - overlap_values_Optim_Thres_precent ;
end


 end

% figure
% hold on
% plot( newTT , ERRORS_diff )
% hold off
% title( 'ERR' )

end
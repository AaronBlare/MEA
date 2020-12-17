% input - 2 sets of 1D vectors - check if they are distinguishable 
function [ accuracy , error_points_precent , Not_distinguishable_points_num_E] = SVM_check_accuracy_1D_data( X1 , X2 , Nb , Nb2 , N )


group2 = zeros( 1 , Nb + Nb2   );
 group2( 1: Nb )= 0 ;
group2( Nb+1: end )= 1 ;
xdata = zeros( Nb + Nb2   , N );
xdata( 1:Nb , : ) = X1( 1:Nb , 1:N);
xdata( Nb+1: end , : ) = X2( : , 1:N);
 

% svmtrain(group2', xdata, '-v 3') 
 
rbf_sigma_non_linearity = 2 ;
svmStruct = svmtrain( xdata , group2', 'kernel_function', 'rbf', 'rbf_sigma' ,rbf_sigma_non_linearity , 'showplot',true  );
% [predict_label, accuracy2, dec_values] = svmpredict(group2', xdata, model) ; 
% accuracy2
%  accuracy = accuracy2(1);
% samples = [ 0  0 ]; 

% figure
group_recovered = svmclassify(svmStruct,xdata,'showplot',true); 

        [ldaResubCM,grpOrder] = confusionmat( group_recovered  ,   group2' );
% ldaResubCM
        
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

        Not_distinguishable_points_num_E = ErrX +  ErrY ;
        error_points_precent = 100 * ( ErrX +  ErrY )/  ( Nb + Nb2 )  ;
        accuracy = 100* ( ( ( Nb + Nb2 )- Not_distinguishable_points_num_E ) / ( Nb + Nb2 ) );
 
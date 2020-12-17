% A_procent=data_matrix_all_files{1,2};
% B_procent = data_matrix_all_files{1,3};
% 
% 
% % for i=1:4
% % ai=A_procent(:,i);
% % bi=B_procent(:,i);
% % end
% 
% 
% 
% a1=A_procent(:,1);
% a2=A_procent(:,2);
% a3=A_procent(:,3);
% a4=A_procent(:,4);
% 
% b1=B_procent(:,1);
% b2=B_procent(:,2);
% b3=B_procent(:,3);
% b4=B_procent(:,4);
% 
% data_meana1 = mean( a1);
% data_meana2 = mean( a2);
% data_meana3 = mean( a3);
% data_meana4 = mean( a4);
% data_mean_a = [data_meana1, data_meana2, data_meana3, data_meana4];
% 
% 
% data_meanb1 = mean( b1);
% data_meanb2 = mean( b2);
% data_meanb3 = mean( b3);
% data_meanb4 = mean( b4);
% data_mean_b = [data_meanb1, data_meanb2, data_meanb3, data_meanb4];
% 
% 
% data_stda1 = std( a1); 
% data_stda2 = std( a2); 
% data_stda3 = std( a3); 
% data_stda4 = std( a4);
% data_std_a= [data_stda1, data_stda2, data_stda3, data_stda4];
% 
% data_stdb1 = std( b1); 
% data_stdb2 = std( b2); 
% data_stdb3 = std( b3); 
% data_stdb4 = std( b4); 
% data_std_b= [data_stdb1, data_stdb2, data_stdb3, data_stdb4];
% 
% % x=[1,2,3,4]
% 
% figure
% 
% hold on
% bar( x , data_mean_a , 'b' )
% errorbar( x , data_mean_a , data_std_a,'b')
% 
% bar( x+0.4 , data_mean_b , 'g' )
% errorbar( x+0.4 , data_mean_b , data_std_b,'g')
% 
% 

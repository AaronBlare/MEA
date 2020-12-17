function Result = CalcMatrixAllChannels( N , Data_times , Connectiv_data , Total_Spike_Rates )
%%
%баллансированное распределение нагрузки по всем процессам
% каждому процессу выделяем size(RasterMatrix,2)/numlabs * (size(RasterMatrix,2)-1) пар клеток
n2p_count = floor(N/numlabs) ; % N=4 , numlabs = , n2p_count =2

if(labindex~=numlabs)
  jr=labindex*n2p_count;
else
  jr=N;
end
%вычисление каждым процессом фактора совпадений для отведенного ему
%количества пар
tau_number = Connectiv_data.params.tau_number ;
% ch_i_start = 1 ;
% ch_i_end = N ;
ch_i_start  = 1+(labindex-1)*n2p_count ;
ch_i_end  = jr  ;

% rates = ones(N,1);
 [  Connectiv_matrix  M_of_tau ] = Spikes_transferred_all_data2(  ch_i_start-1 , ch_i_end-1  , Connectiv_data.params.tau_delta , ...
   tau_number-1  , Connectiv_data.params.epsilon_tau , 1  , N , ...
   Connectiv_data.params.MaxSpikesPerChannelPerBurst , Data_times , Total_Spike_Rates ,  Connectiv_data.params.Conn_Spikes_num_min  ) ;
%  Connectiv_data.Conn_Spikes_num_min

 
% Connectiv_matrix_M_on_tau_Block =zeros( ch_i_end - ch_i_start + 1 ,N  ,  tau_number ); 


% //    tau_max , epsilon_tau , Nb , N ,MaxSpikesPerChannelPerBurst ,Data_times , Total_Spike_Rates ,  Conn_Spikes_num_min ) 
% whos Connectiv_matrix
a = Connectiv_matrix ;
a=reshape(a,[],1); 
%  
% %  #define  Connectiv_matrix( ch_i , ch_j , tau_i )  Connectiv_matrix[(ch_i)*N + (ch_j)  +(tau_i)*N*N ] 
Connectiv_matrix_M_on_tau_Block = zeros( ch_i_end - ch_i_start + 1 , N ,  tau_number );
ind = 1 ;
for i = 1 : ch_i_end - ch_i_start + 1
    for j = 1: N
        for tau =1 :  tau_number
            Connectiv_matrix_M_on_tau_Block( i , j , tau ) = a( (i-1)*N  + j + (tau-1) * (N*(ch_i_end - ch_i_start + 1))    );
            ind = ind + 1;
        end
    end    
end




% k=1;
% for ch_i = 1+(labindex-1)*n2p_count:1:jr
%   for ch_j=1:1:N 
%     if ch_i==ch_j 
%       M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ; 
%       Connectiv_matrix_M_on_tau_Blocks( k , ch_j , :) = M_of_tau ;
%       continue;
%     end;      
%       M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ; 
%       if Total_Spike_Rates( ch_i) > Connectiv_data.params.Conn_Spikes_num_min && ...
%              Total_Spike_Rates( ch_j)  > Connectiv_data.params.Conn_Spikes_num_min
%           M_of_tau  = Spikes_transferred( bursts{ ch_i }   , bursts{ ch_j }   , ...
%                                 Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
%                                 Connectiv_data.params.epsilon_tau )  ; 
%             
% %              [ M , c ] =     Spikes_transferred_all_data2( ch_i   , ch_j  , ...
% %                                 Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
% %                                 Connectiv_data.params.epsilon_tau , Connectiv_data.Nb , N , ...
% %                                 Connectiv_data.params.tau_number  , bursts , Total_Spike_Rates , Connectiv_data.Conn_Spikes_num_min )  ;
% 
%       end
%       Connectiv_matrix_M_on_tau_Blocks( k , ch_j , :) = M_of_tau ;      
%   end
%   k=k+1;
% end
                            
                            
 
Result =  Connectiv_matrix_M_on_tau_Block ;
% Result{1}=TimeIJ;
% Result{2}=SigIJ;
end


function Result = CalcMatrixAllChannelsCycle( N , bursts , Connectiv_data , Total_Spike_Rates )
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
 
Connectiv_matrix_M_on_tau_Blocks0 =zeros(jr-(labindex-1)*n2p_count,N , Connectiv_data.params.tau_number ); 

ch_i_interval( 1 ) = 1+(labindex-1)*n2p_count ;
ch_i_interval( 2 ) = jr  ;
% Connectiv_matrix_M_on_tau_Blocks = Spikes_transferred_all_data( ch_i_interval(1)   , ch_i_interval( 2 )  , ...
%                                 Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
%                                 Connectiv_data.params.epsilon_tau , Connectiv_data.Nb , N , ...
%                                 Connectiv_data.MaxSpikesPerChannelPerBurst , bursts , Total_Spike_Rates , Connectiv_data.Conn_Spikes_num_min )  ;
% % [  Connectiv_matrix  M_of_tau ] = Spikes_transferred_all_data( ch_i_interval_start , ch_i_interval_end , tau_delta , ...
% % //    tau_max , epsilon_tau , Nb , N ,MaxSpikesPerChannelPerBurst ,Data_times , Total_Spike_Rates) 
                           
                            
k=1;
for ch_i = 1+(labindex-1)*n2p_count:1:jr
  for ch_j=1:1:N 
    if ch_i==ch_j 
      M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ; 
      Connectiv_matrix_M_on_tau_Blocks( k , ch_j , :) = M_of_tau ;
      continue;
    end;      
      M_of_tau = zeros( Connectiv_data.params.tau_number  , 1 ) ; 
      if Total_Spike_Rates( ch_i) > Connectiv_data.params.Conn_Spikes_num_min && ...
             Total_Spike_Rates( ch_j)  > Connectiv_data.params.Conn_Spikes_num_min
          M_of_tau  = Spikes_transferred( bursts{ ch_i }   , bursts{ ch_j }   , ...
                                Connectiv_data.params.tau_delta , Connectiv_data.params.tau_max ,...
                                Connectiv_data.params.epsilon_tau )  ; 
      end
      Connectiv_matrix_M_on_tau_Blocks( k , ch_j , :) = M_of_tau ;      
  end
  k=k+1;
end
Result = Connectiv_matrix_M_on_tau_Blocks  ;
% Result{1}=TimeIJ;
% Result{2}=SigIJ;
end


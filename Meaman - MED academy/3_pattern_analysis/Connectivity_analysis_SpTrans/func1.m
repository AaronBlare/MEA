function Result = func1( N  , Spiketimes_all )
%%
%баллансированное распределение нагрузки по всем процессам
% каждому процессу выделяем size(RasterMatrix,2)/numlabs * (size(RasterMatrix,2)-1) пар клеток
n2p_count = floor(N/numlabs) % N=4 , numlabs = , n2p_count =2

if(labindex~=numlabs)
  jr=labindex*n2p_count;
else
  jr=N;
end
%вычисление каждым процессом фактора совпадений для отведенного ему
%количества пар
 
M_of_tau =cell(jr-(labindex-1)*n2p_count,N ); 

k=1;
for ch_i = 1+(labindex-1)*n2p_count:1:jr
  for ch_j=1:1:N 
    if ch_i==ch_j 
      SigIJ{k,ch_j}=0;
      TimeIJ{k,ch_j}=0;
      continue;
    end;                  
        sigmaij=  SPtrans(  Spiketimes_all{ ch_i } , Spiketimes_all{ ch_j } );  
        
        M_of_tau{k,ch_j}=sigmaij ;
%         SigIJ{k,j} = sigmaij(inds);         
%         TimeIJ{k,j} = (inds-1-floor(conf.r_delay_m./conf.d_step)).*conf.d_step; 
  end
  k=k+1;
end
Result = M_of_tau ;
% Result{1}=TimeIJ;
% Result{2}=SigIJ;
end


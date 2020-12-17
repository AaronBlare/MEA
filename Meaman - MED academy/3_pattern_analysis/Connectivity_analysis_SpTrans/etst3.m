

% etst3
clear

% data1 = [ 1 2 3 ; 4 5 6 ];
N=4 ;
Nb = 2 ;
% Nb = 1 ;
tau_number = 6 ;
MaxSpikesPerChannelPerBurst = 5 ;
data =zeros( 1, N , MaxSpikesPerChannelPerBurst );
tau_delta=1;
epsilon_tau=0.3;
% data( 1 , 1 , : )= [ 11 12 13 14 15 16 19];  
% data( 1 , 2 ,  : )=[ 21 22 23 24 25 26 27];
% data( 1 , 3 ,  : )=[ 31 32 33 34 35 36 37];
data( 1 , 1 , : )= [ 11 0 0 17 20 ];  
data( 1 , 2 ,  : )=[ 0 22 23 32 0  ];
data( 1 , 3 ,  : )=[ 31 32 0 34 35  ];
data( 1 , 4 ,  : )=[ 41 42 43 0 0];  
data( 2 , 1 , : )= [ 11 12 13 0 0  ];  
data( 2 , 2 ,  : )=[ 21 22 23 24 25  ];
data( 2 , 3 ,  : )=[ 31 32 21 34 35  ];
data( 1 , 4 ,  : )=[ 41 42 43 44 45];

data_new = zeros( N , MaxSpikesPerChannelPerBurst * Nb );
MaxSpikesPerChannelPerBurst = MaxSpikesPerChannelPerBurst * Nb ;
for ch = 1 : N 
    data_line = [] ; 
    for Nbi=1:Nb
      data_l  = data( Nbi , ch , : );   
      data_l  = reshape( data_l , 1 , []);
      data_line = [ data_line data_l  ];
    end
    data_new( ch , : ) = data_line ;  
end
clear data ;
Nb = 1 ;
data = data_new ;




%   Data_times(i,j, k) Data_times[(i)*N*3 + (j) + (k)*N ]
ch_i_start = 1  ;
ch_i_end =  N ;

rates = ones(N,1);
 [  Connectiv_matrix  M_of_tau ] = Spikes_transferred_all_data2(  ch_i_start-1 , ch_i_end-1  , tau_delta , ...
   tau_number-1  , epsilon_tau , 1 , N , MaxSpikesPerChannelPerBurst  , data' , rates ,  0 ) ;
% M_of_tau
whos Connectiv_matrix
a = Connectiv_matrix ;
a=reshape(a,[],1); 
 
%  #define  Connectiv_matrix( ch_i , ch_j , tau_i )  Connectiv_matrix[(ch_i)*N + (ch_j)  +(tau_i)*N*N ] 
Connectiv_matrix0 = zeros( ch_i_end - ch_i_start + 1 , N , tau_number );
ind = 1 ;
for i = 1 : ch_i_end - ch_i_start + 1
    for j = 1: N
        for tau =1 : tau_number
        Connectiv_matrix0( i , j , tau ) = a( (i-1)*N  + j + (tau-1) * (N*(ch_i_end - ch_i_start + 1))    );
        ind = ind + 1;
        end
    end    
end

ch1=3;
ch2=1;
% Connectiv_matrix0( ch1,ch2, :);
a = Connectiv_matrix0( ch1,ch2, :) ;
a_mex_all  =reshape(a,[],1) 
%---------------------------------------------------------

            Spiketimes_all = cell(  N ,1); % each cell is array of spike times
            
               for ch = 1 : N
                  ch_times = data( ch  , : ) ;
%                   ch_times = reshape( ch_times, 1 , []);
                  ch_times( ch_times==0 )=[];       
                  Spiketimes_all{ ch } = ch_times ;
               end
    
               
Connectiv_matrix_M_on_tau_Block =zeros( N ,N  ,  tau_number );                
k=1;
Total_Spike_Rates = ones(N,1);
for ch_i =1:1:N
  for ch_j=1:1:N 
    if ch_i==ch_j 
      M_of_tau = zeros( tau_number  , 1 ) ; 
      Connectiv_matrix_M_on_tau_Blocks( k , ch_j , :) = M_of_tau ;
      continue;
    end;      
      M_of_tau = zeros(  tau_number  , 1 ) ; 
      if Total_Spike_Rates( ch_i) > 0 && ...
             Total_Spike_Rates( ch_j)  > 0
          M_of_tau  = Spikes_transferred( Spiketimes_all{ ch_i }   , Spiketimes_all{ ch_j }   , ...
                                 tau_delta , tau_number-1 ,...
                                 epsilon_tau )  ;  
      end
      Connectiv_matrix_M_on_tau_Blocks( k , ch_j , :) = M_of_tau ;      
  end
  k=k+1;
end

 
a = Connectiv_matrix_M_on_tau_Blocks( ch1,ch2, :);
a_mex_lines  =reshape(a,[],1) 








% test_spike_trans


% Spiketimes_all{1} = [   1 2 6 8    ] ;
% Spiketimes_all{2} = [   8 9 10 11 12] ;
Spiketimes_all{1} = 1:10:1000 ;
Spiketimes_all{2} = 1:10:1000 +randn(1,1000)*4 ;
tau_delta=1;
tau_max = 5 ;
epsilon_tau = 0.3 ;
dt = 0.1 ;


Spiketimes_all2{1} = Spiketimes_all{1} / dt ;
Spiketimes_all2{2} = Spiketimes_all{2} / dt ;
ch1=  2 ;
ch2 = 1 ;


X=zeros(2,1); 
X(Spiketimes_all2{ch2})=1; 
Spiketimes_all2{ch2}
X;





NN=1 ;
    


   M_of_tau_old  = Spikes_transferred( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                              tau_delta , tau_max ,...
                             epsilon_tau )       
 tic
 for i=1: NN
   M_of_tau_old  = Spikes_transferred( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                              tau_delta , tau_max ,...
                             epsilon_tau )   ;
 end
 toc                            
            


   M_of_tau_fast  = Spikes_transferred_fast01( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                              tau_delta , tau_max ,...
                             epsilon_tau )

 tic
 for i=1: NN
      M_of_tau_fast  = Spikes_transferred_fast01( Spiketimes_all{ ch1 }   , Spiketimes_all{ ch2 }   , ...
                              tau_delta , tau_max ,...
                             epsilon_tau );  
 end
 toc  
    
      M_of_tau_fast02  = Spikes_transferred_fast02( Spiketimes_all2{ ch1 }   , X   , ...
                             floor( tau_delta / dt ), floor( tau_max / dt ) ,...
                           floor(  epsilon_tau /dt ) )
                         
 tic
 for i=1: NN
      M_of_tau_fast02  = Spikes_transferred_fast02( Spiketimes_all2{ ch1 }   , X   , ...
                             floor( tau_delta / dt ), floor( tau_max / dt ) ,...
                           floor(  epsilon_tau /dt ) ) ;
 end
 toc                         
% Spiketimes_all{1} 
% Spiketimes_all{2}                      
         
%      6 7 8 9
%      +2
%      3 4 5 6
%      +3
%      4 5 6 7
%      +4
%      5 6 7 8
  
                          
                          
                          
                          
                          
                          
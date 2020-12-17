
% Connectiv_analysis_UsingTasks

  if  Comp_type == 3  
      Connectiv_data.params.crap.Nb = Nb ; 
%       Connectiv_data.MaxSpikesPerChannelPerBurst = 1000 ;
      
%         N=3;
% %         Nb = 2 ;
%         Nb = 1 ;
%         Connectiv_data.params.tau_number = 20 ;
%         MaxSpikesPerChannelPerBurst = 5 ;
%         data =zeros( 1, N , MaxSpikesPerChannelPerBurst );
%         Connectiv_data.MaxSpikesPerChannelPerBurst= MaxSpikesPerChannelPerBurst ;
%         data( 1 , 1 , : )= [ 11 12 13 0 0  ];  
%         data( 1 , 2 ,  : )=[ 21 0 23 0 25  ];
%         data( 1 , 3 ,  : )=[ 31 32 33 34 35  ];
%         bursts_absolute=data;
%       Total_Spike_Rates =ones(N,1);
%     obj = createTask(pjob, @CalcMatrixAllChannelsCycle, 1, { N , Spiketimes_all , Connectiv_data , Total_Spike_Rates } );%{conf.mode, conf.h, RASTR, conf.delay_m, conf.d_step, conf.fuzz});
    

    Data_times_new = zeros( N , Connectiv_data.params.MaxSpikesPerChannelPerBurst * Nb );
%     MaxSpikesPerChannelPerBurst = MaxSpikesPerChannelPerBurst * Nb ;
    Connectiv_data.params.MaxSpikesPerChannelPerBurst = Connectiv_data.params.MaxSpikesPerChannelPerBurst * Nb ;
    for ch = 1 : N 
        data_line = [] ; 
        for Nbi=1:Nb
          data_l  = Data_times( Nbi , ch , : );   
          data_l  = reshape( data_l , 1 , []);
          data_line = [ data_line data_l  ];
        end
        Data_times_new( ch , : ) = data_line ;  
    end
    clear Data_times ;
    Nb = 1 ;
    Data_times = Data_times_new' ;
    obj = createTask(pjob, @CalcMatrixAllChannels, 1, { N , Data_times , Connectiv_data , Total_Spike_Rates } );%{conf.mode, conf.h, RASTR, conf.delay_m, conf.d_step, conf.fuzz});
    
    
    submit(pjob); waitForState(pjob); 
    parallel_results = getAllOutputArguments(pjob) 
    
    
        errmsgs = get(pjob.Tasks, {'ErrorMessage'});
        nonempty = ~cellfun(@isempty, errmsgs);
        celldisp(errmsgs(nonempty));
    
    whos parallel_results
    destroy(pjob)
      
    Result_all ={};
    for i=1:length( parallel_results )
       Result_all = [ Result_all ;  parallel_results{i} ] ;
    end
    Result_all;
    % res = res_produce(results);

    clear parallel_results
    Result_all_mat = cell2mat(Result_all);
     for Current_Data_Block = 1: Nb_blocks  
         for i = 1 : N
               for j = 1 : N
                 Connectiv_matrix_M_on_tau_Blocks(  i , j ,Current_Data_Block , :  )= Result_all_mat(  i , j , :  ) ;
               end
         end
     end 
     
  end
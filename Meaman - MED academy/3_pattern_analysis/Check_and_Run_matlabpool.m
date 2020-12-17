% Check_and_Run_matlabpool

    if matlabpool('size')== 0
       num_cores = feature( 'numCores') ;
       if num_cores < 8
        matlabpool  
       else
%         matlabpool('local',num_cores - 1 )
        matlabpool( 'local', 4 )
%         matlabpool('local',num_cores - 7 )
       end
    end
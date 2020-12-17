
% T_act_Pattern_similarity
% Patterns1.burst_activation Patterns2.burst_activation ->
% Tact_Clustering_error_precent_KMEANS ...

    mR_difference_arr = [] ;
    R1s = [];
    R2s = [];
    R3s =[] ;R4s =[] ;
    ix = [];
    % Nb2 = Nb ;

    nbursts = 0 ;
    % nbursts = nbursts - 1 ;
    
    %-- compare each patterns timelapse
    if 1> 2 
    
        n11 = 1 ; n12 = 1+ nbursts ;
        for n21 = 1 :1: Nb2 - 1*nbursts
            % for n21 = Nb2 - nbursts - 1 :-1: 1
            [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4 , R5 ] = Two_sets_compare_similarity( ...
                       Patterns1.burst_activation , Patterns2.burst_activation , 0 , 0 , n21 , n21 + 1*0 , ...
                       'n' , PHASE_ON , ADJUST_SPIKES , 2 , T_act );


            %        [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4 ] = Two_sets_compare_similarity( ...
            %            Patterns1.burst_activation , Patterns2.burst_activation , 0 , 0 , n21 , n21 + 1*0 , 'n' , PHASE_ON , ADJUST_SPIKES );
            mR_difference_arr = [ mR_difference_arr mR_difference ] ;
            R1s = [ R1s R1 ];R2s = [ R2s R2 ];R3s = [ R3s R3 ];R4s = [ R4s R4 ];
            ix = [ ix Patterns2.artefacts(n21)/1000 ];
        end
        % figure
        % plot( ix , mR_difference_arr )
        if SHOW_FIGURES 
            figure
            subplot( 2,1,1)
            hold on
        plot(ix , R2s , '-o' ) 
        plot(  ix , R1s  ,ix , R3s ,'-o' ) 
        hold off
        title( 'Pattern distance to center mass' )

    %     figure
        subplot( 2,1,2)
        % plot(ix , R1s , ix , R2s , ix , R3s )
        ix2 = ix ; ix2(end) = ix(end)*2 + 30 ;
        hold on
        plot(ix , R2s , '-o' )
        plot( ix2 , R1s , ix+ix(end)+30 , R3s , '-o' )
        hold off
        title( 'Pattern distance to center mass' )
        end

    end


[P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4,R5,R6 , T_act ] = Two_sets_compare_similarity( ...
           Patterns1.burst_activation , Patterns2.burst_activation , 0 , 0 , 0 ,0 , SHOW_FIGURES , PHASE_ON , ADJUST_SPIKES , 2 , T_act);   
% title( 'first 10% of bursts VS last 10%' ) 

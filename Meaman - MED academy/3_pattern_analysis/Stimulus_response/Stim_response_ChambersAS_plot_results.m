% Stim_response_ChambersAS_plot_results

 
 
timebins = POST_STIM_RESPONSE.Timebin_x_ms ;
%  sr_div  =  Patterns.DT_bin / 1000  ; % find firing rate each bin

 sr_div  =  POST_STIM_RESPONSE.DT_bin / 1000  ; % find firing rate each bin

 
 sr_div_A =  sr_div * length( Global_flags.Search_Params.Chamber_A_electrodes );
 sr_div_ax = sr_div * numel( Global_flags.Search_Params.Chamber_channels_electrodes );
 sr_div_B =  sr_div * numel( Global_flags.Search_Params.Chamber_B_electrodes );
 
    %         bb1 =  subplottight(Ny , Nx , 6 ) ;

            figure_title = ['Stim response in chambers A,B. A evoked B = ' num2str( POST_STIM_RESPONSE.Chambers_A_B_evoked_percent ) '%' ] ;
            f = figure ;
            set(f, 'name',  figure_title ,'numbertitle','off' )

            Nx =1;Ny=1;

         subplot( Ny, Nx , 1 )
            hold on
%             plot(timebins , ChambersStim_A.Timebin_srprofile / sr_div_A, 'LineWidth' , 2 );
            plot(timebins , POST_STIM_RESPONSE.Timebin_A_srprofile_firing_HZ , 'LineWidth' , 2 );
            
             plot(timebins , POST_STIM_RESPONSE.Timebin_Axon_srprofile_firing_HZ ,'r' , 'LineWidth' , 2 ); 
%             plot(timebins , Patterns.Timebin_Axon_srprofile / sr_div_ax, 'r' , 'LineWidth' , 2 );       

%             plot(timebins , ChambersStim_B.Timebin_srprofile / sr_div_B , 'g' , 'LineWidth' , 2 );
             plot(timebins , POST_STIM_RESPONSE.Timebin_B_srprofile_firing_HZ , 'g' ,'LineWidth' , 2 );
             
             
    %         errorbar( timebins,  ANALYZED_DATA.Timebin_A_srprofile , ANALYZED_DATA.Timebin_A_srprofile_std);
    %         errorbar(timebins , ANALYZED_DATA.Timebin_Axon_srprofile , ...
    %             ANALYZED_DATA.Timebin_Axon_srprofile_std , 'r' , 'LineWidth' , 2 );  
    %         errorbar(timebins , ANALYZED_DATA.Timebin_B_srprofile ,...
    %              ANALYZED_DATA.Timebin_B_srprofile_std , 'g' , 'LineWidth' , 2 );
    
    
 
    

    % Mark if Stim evoked bursts in chambers
     Stim_A_evoked = '(random)'  ;
%     if ChambersStim_A.artefacts_evoked_bursts
    if    POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_number > 0
        Stim_A_evoked = '(Non-random)'  ;
    end
    
    Stim_B_evoked = '(random)'  ;
%     if ChambersStim_B.artefacts_evoked_bursts  
    if  POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_number > 0
        Stim_B_evoked = '(Non-random)'  ;
    end
    
%             legend( ['Stimulus > A = ' num2str( ChambersStim_A.artefacts_evoked_percent ) '% ' Stim_A_evoked] ,  ...
%                     [ 'Stimulus > B = ' num2str( ChambersStim_B.artefacts_evoked_percent ) '% ' Stim_B_evoked ] )
           legend( ['Stimulus evokes A = ' num2str( POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_percent ) '% ' Stim_A_evoked] ,  ...
               [ 'Axonal spikes' ] , ...
                    [ 'Stimulus evokes B = ' num2str( POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_percent ) '% ' Stim_B_evoked ] )    
                  
%             xlim( [ 1   timebins( end)-3*POST_STIM_RESPONSE.DT_bin])
     xlim( [ 1   timebins( end) ])

            title( figure_title);
            xlabel( 'Burst time offset, ms' )
    %         ylabel( 'Mean spikes' ) 
            ylabel( 'Firing rate, Hz' ) 
        
        
            
                
%     figure_title = ['Stim response in chambers A,B. A evoked B = ' num2str( POST_STIM_RESPONSE.Chambers_A_B_evoked_percent ) '%' ] ;
%             f2 = figure ;
%             set(f2, 'name',  figure_title ,'numbertitle','off' ) 
%             Nx =1;Ny=1; 
%          subplot( Ny, Nx , 1 )
%             hold on 
%             plot(timebins , POST_STIM_RESPONSE_A.TimeBin_Total_Spikes_mean / sr_div_A , 'LineWidth' , 2 ); 
%             plot(timebins , POST_STIM_RESPONSE_chan.TimeBin_Total_Spikes_mean / sr_div_ax   , 'r' ,'LineWidth' , 2 );
%              plot(timebins , POST_STIM_RESPONSE_B.TimeBin_Total_Spikes_mean / sr_div_B ,'g' , 'LineWidth' , 2 );  
%               
%              legend( ['Stimulus evokes A = ' num2str( POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_percent ) '% ' Stim_A_evoked] ,  ...
%                [ 'Axonal spikes' ] , ...
%                     [ 'Stimulus evokes B = ' num2str( POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_percent ) '% ' Stim_B_evoked ] )    
%                  
%                 
%            xlim( [ 1   timebins( end) ]) 
%             
      % Plot raster and mark A>B and B>A bursts

Art = artefacts_origin      ;
      
if POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_number > 0
SA_starts = POST_STIM_RESPONSE_A.artefacts( POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_index  );
else
    SA_starts =[];
end
if  POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_number > 0   
SB_starts = POST_STIM_RESPONSE_B.artefacts( POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_index );
else
    SB_starts = [] ;
end

if  POST_STIM_RESPONSE.Chambers_A_B_evoked_index_of_A_artefacts
AB_starts = POST_STIM_RESPONSE_A.artefacts( POST_STIM_RESPONSE.Chambers_A_B_evoked_index_of_A_artefacts );
else
    AB_starts = [] ;
end
 
 
f = figure;
figure_title  = 'Raster, A-B bursts marked' ;
 set(f, 'name', figure_title , 'numbertitle','off' )
 x = [  ]; y = [  ]; 
 xt= [  ]; yt = [  ]; 
 burst_start = [] ; 
 
 index_r = index_r_spont;
Plot_Detailed_Raster
 
hold on 

dy = 0.5;
plot( Art /1000  ,  61 + dy  , 'v', 'Linewidth' , 1  )
 
if ~isempty(SA_starts)
plot( SA_starts /1000  ,  62+ dy   , 'x', 'Linewidth' , 1  )
end
if ~isempty(SB_starts)
plot( SB_starts/1000  ,  63 + dy  , '*','Linewidth' , 1  )
end

if ~isempty(AB_starts)
plot( AB_starts/1000  ,  64 + dy  , 'o','Linewidth' , 1  )
end

legend( 'Spikes', 'v Artifacts','X Stim-A' , '+ Stim-B', 'o - AB responses'  )  
 
hold off     
           
           
           
           
           
           
           
%             % Stimuli evoked bursts :
%                 ChambersStim_A.artefacts_evoked_index  
%             % Number of stimuli evoked bursts
%                 ChambersStim_A.artefacts_evoked_percent  
%             % Number of stimuli evoked bursts
%                 ChambersStim_A.artefacts_evoked_number  
%             % Did stimuli evoked bursts
%                 ChambersStim_A.artefacts_evoked_bursts  
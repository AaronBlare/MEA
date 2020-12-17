%  Stim_resp_Connectiv_analyze_AB
% input Connectiv_data struct :POST_STIM_RESPONSE
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24   ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [  51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes

if ~exist( 'Connectiv_analyze_AB_show_figures' , 'var' )
    Connectiv_analyze_AB_show_figures = true ;
end

Connectiv_data_AB_M = Connectiv_data.Connectiv_matrix_max_M ;
Connectiv_data_AB_M(:)=0;
Connectiv_data_AB_tau =Connectiv_data_AB_M;
% Connectiv_data_AB

for ci = 1 : N
   
    i = find( ci == Global_flags.Search_Params.Chamber_A_electrodes );
    if ~isempty( i )
       Connectiv_data_AB_M( ci ,  Global_flags.Search_Params.Chamber_B_electrodes ) = ...
           Connectiv_data.Connectiv_matrix_max_M( ci ,  Global_flags.Search_Params.Chamber_B_electrodes );
       Connectiv_data_AB_tau( ci ,  Global_flags.Search_Params.Chamber_B_electrodes ) = ...
           Connectiv_data.Connectiv_matrix_tau_of_max_M( ci ,  Global_flags.Search_Params.Chamber_B_electrodes );
         
    end
end



H1 = Connectiv_data_AB_M;
H1( Connectiv_data_AB_M == 0 ) = [];


non_zero_delays = Connectiv_data_AB_tau;
non_zero_delays( Connectiv_data_AB_tau == 0 ) = [];

Bins_num = 20 ;
Ny =2 ; Nx=2 ;

if Connectiv_analyze_AB_show_figures
figure
subplot(Ny,Nx,1)
    imagesc( Connectiv_data_AB_M );
    title( 'Connections strength matrix');
colorbar
        axis square
        
subplot(Ny,Nx,2)
    imagesc( Connectiv_data_AB_tau );
    title( 'Connections delays matrix');
colorbar
        axis square
        
subplot(Ny,Nx,3)
    hist( non_zero_delays , Bins_num )
         xlabel( 'Connections delay (>0)')
         ylabel('Count #')
         title( 'Delays histogram');

subplot(Ny,Nx,4)
         hist( H1 , Bins_num )
         xlabel( 'Connections strength')
         ylabel('Count #')
         title( 'Strength histogram');
end




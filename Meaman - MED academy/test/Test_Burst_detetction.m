



% Test_Burst_detetction

filename = 'Nlearn_RASTER_burst.txt' ;
filename_test = 'Nlearn_RASTER_burst_test.txt' ;
RealDuration = 165.9 ; % ms
Max_burst_number_in_rec =  200   ; % how much will realy fit into
Rec_dur_sec = 40 ;
Iterations = 1 ;
RAND_SHIFT_BURST = 5;

Search_Params.TimeBin = 50 ;
Search_Params.AWSR_sig_tres = 0.4 ;
Search_Params.save_bursts_to_files = 'y' ; 
% Search_Params.Arg_file  ; 
Search_Params
Search_Params.Arg_file.Use_meaDB_raster = false ;
Search_Params.Show_figures = false;
Search_Params.use6well_raster = false ; 
Search_Params.SsuperBurst_scale_sec = 50 ;



Mean_Burst_Duration_all = [] ;
Mean_Burst_Duration_all_2d = [];
number_of_burst_to_use_all = []; 
Mean_Threshold_AWSR  = [] ;

number_of_burst_to_use= 130 ;


%------- load one burst and prepare -------------
            index_r_one_burst = load( filename ); 
            [c,i]=max(index_r_one_burst( :,1)) ;
            index_r_one_burst( i  ,:) = [];
            
            [c,i]=max(index_r_one_burst( :,1)) ;
            index_r_one_burst( i  ,:) = [];
            
            [c,i]=max(index_r_one_burst( :,1)) ;
            index_r_one_burst( i  ,:) = [];      
            
            [c,i]=max(index_r_one_burst( :,1)) ;
            index_r_one_burst( i  ,:) = [];           
            
            [c,i]=max(index_r_one_burst( :,1)) ;
            index_r_one_burst( i  ,:) = [];                   

            OneSpike = [ Rec_dur_sec * 1000  1  -0.0200 ];
%             index_r_one_burst  = [ index_r_one_burst ;  OneSpike ];
     %--------------------------------       
     
            [cmax,i]=max(index_r_one_burst( :,1)) ; 
          [cmin,i]=min(index_r_one_burst( :,1)) ; 
         RealDuration  = cmax-cmin  

for number_of_burst_to_use = 0  : 10  : Max_burst_number_in_rec
    
    number_of_burst_to_use
    
    Mean_Burst_Durs_1nb_all_iters = []; 
    Threshold_AWSR_itera = [];
    for It = 1 : Iterations 

            Random_shifts_sec = EraseRandomChannles( number_of_burst_to_use , Max_burst_number_in_rec )-1;
            Random_shifts_sec = Random_shifts_sec * (   Rec_dur_sec / Max_burst_number_in_rec) ;
            Search_Params



            index_r = [];
            for bi=1 : number_of_burst_to_use  

                % --- shift random one burst 
                 index_r_one_burst_new  = index_r_one_burst ;
                index_r_one_burst_new( :,1) = index_r_one_burst( :,1) + floor( randn()* RAND_SHIFT_BURST ) + Random_shifts_sec( bi )*1000  ;

                index_r = [ index_r ;  index_r_one_burst_new ];

            end
            index_r = [ index_r ; OneSpike ];
            % index_r(:,1) = index_r( :,1) + 300 ;
            % % 

             [a,p] = size(index_r);
            fid = fopen(filename_test , 'w');
              if p == 4 
            fprintf(fid, '%.3f  %d  %.4f %.4f\n', index_r');
              end

             if p == 3 
            fprintf(fid, '%.3f  %d  %.4f\n', index_r');
             end
             if p == 2
            fprintf(fid, '%.3f  %d\n', index_r');     
             end 




        ANALYZED_DATA = MED_AWSR_Find_Bursts( filename_test  ,  Search_Params ) ;
        % function MED_AWSR_Find_Bursts( filename , TimeBin , AWSR_sig_tres , save_bursts_to_files  , Arg_file , Search_Params)
        close all


        Mean_Burst_Duration = mean( ANALYZED_DATA.BurstDurations ) ;
        Mean_Burst_Duration_all = [Mean_Burst_Duration_all Mean_Burst_Duration ];
        Mean_Burst_Durs_1nb_all_iters = [ Mean_Burst_Durs_1nb_all_iters Mean_Burst_Duration ] ;
        Threshold_AWSR_itera = [  Threshold_AWSR_itera ANALYZED_DATA.Threshold_AWSR ] ;
        
    end
    Mean_Threshold_AWSR = [Mean_Threshold_AWSR  mean( Threshold_AWSR_itera ) ] ;
    Mean_Burst_Duration_all_2d = [ Mean_Burst_Duration_all_2d ; Mean_Burst_Durs_1nb_all_iters ] ;
    number_of_burst_to_use_all = [ number_of_burst_to_use_all  number_of_burst_to_use-1 ];
end

 

    %-  Mean all iterations for each bursts number
    Mean_Burst_Duration_all_mean = mean( Mean_Burst_Duration_all_2d , 2 );
    whos Mean_Burst_Duration_all_mean
    Mean_Burst_Duration_all = Mean_Burst_Duration_all_mean ;
    eval(['save   Mean_Burst_Duration_all_2d.mat  Mean_Burst_Duration_all_mean  number_of_burst_to_use_all Mean_Burst_Duration_all -mat']); 
    

Bias_all = 100 *  (( Mean_Burst_Duration_all - RealDuration ) / RealDuration );

figure
    plot( number_of_burst_to_use_all , ( Mean_Burst_Duration_all ) , 'LineWidth' , 2 )
    title( 'Mean burst duration')
figure
    plot( number_of_burst_to_use_all , Mean_Threshold_AWSR , 'LineWidth' , 2 )    
    
figure
    plot( number_of_burst_to_use_all , abs( Bias_all ), 'LineWidth' , 2 )
    xlabel( 'Number of bursts in 40 sec')
    ylabel( 'Burst duration detection bias, %')
    title( 'Burst duration bias')









 
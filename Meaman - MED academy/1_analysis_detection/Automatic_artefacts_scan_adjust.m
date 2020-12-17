
% Automatic_artefacts_scan_adjust

Automatic_artefacts_scanning = 1 

% calls from amp_detect3_artefacts.m

%        option_data.Optimal_art_criteria = 0 ;
%        option_data.Optimal_art_Optimal_Closest_interval_to_expected = 0 ;
%        option_data.Optimal_art_Optimal_Number_of_Artifacts=0 ;
%        option_data.Optimal_art_Optimal_Interval_variability_std_sec = 0 ;
      

if New_Artefact_detect_method 
    
x_diff = diff( x );
% x_diff = x_diff.^3/ 10 ;
% 
% figure
% plot( x_diff   )

if handles.par.ARTEFACT_threshold_Polarity_autosearch 
sig_diff_neg = abs( mean( x_diff( x_diff < -0.02 ) )  ) ; 
sig_diff_pos = abs( mean( x_diff( x_diff > 0.02 ) )   );

if sig_diff_neg > sig_diff_pos
   ARTEFACT_threshold = - abs(ARTEFACT_threshold) ;
else
    ARTEFACT_threshold = abs(ARTEFACT_threshold) ; 
end   
  ARTEFACT_threshold ;  
    
end

% ARTEFACT_thr_search_expected = 1 ;
ARTEFACT_thr_search_expected 


if ARTEFACT_thr_search_expected == 0 
    Art_auto_search = false ;
    art_find_Method_by_min_ISI_std = true ;
    
   if handles.par.Art_auto_search_if_no_ISI
       Art_auto_search = true ;
   else
         Art_auto_search = false ;
   end
    
else
    Art_auto_search = true ;
    art_find_Method_by_min_ISI_std = false ;
end



% if ARTEFACT_thr_search_expected > 0 
    if Art_auto_search
    
%     ARTEFACT_interval_defined = 1
    
 
    ARTEFACT_search = 1 
    
% A0 = 0.005 ;
% A1 = 0.2 ;
A0 = handles.par.ARTEFACT_threshold_A0  ;
A1 = handles.par.ARTEFACT_threshold_A1 ;
Astep = (A1 - A0 )/ 500 ;

 from1 = 1+  handles.par.collect_sigma_from *sr ;
 To2 =   handles.par.collect_sigma_to *sr ;
 
 if length( x_diff) < To2
    To2  = length( x_diff-1) ;
 end
 
noise_diff = handles.par.ARTEFACT_threshold_sigma_min * median(abs(x_diff( from1  : To2 )))/0.6745;
% noise_diff_mv = handles.par.ARTEFACT_threshold_sigma_min * median(abs(x( from1  : To2 )))/0.6745;

if noise_diff < handles.par.ARTEFACT_minimum_median_thr
    noise_diff = handles.par.ARTEFACT_minimum_median_thr ;
end

% figure ; hold on ;
% plot(x_diff)
% plot( [ 1 length( x_diff ) ]  , [noise_diff noise_diff] , '-r')
% plot( [ 1 length( x_diff ) ]  , [-noise_diff -noise_diff] , '-r')
 
Art_all = A0 : Astep : A1 ;

Art_all( Art_all == 0 ) = [] ;

Na = length( Art_all ) ;
Art_num_all = zeros( Na , 1);
Art_most_freq_Interval_sec =  zeros( Na , 1);
Ax = zeros( Na , 1);
artefacts_diff_sec = zeros( Na , 1);

% x_diff = x_diff.^3 ;
% figure ; hold on ;
% plot(x_diff)

testn = 5000 ;    
x_diff_test = x_diff(1:testn);

%  whos artefacts
% max_arts_found_all = [] ;
% skip_iterations = 0 ;
% analyze_only_pos_art = false ;
%------------ parfor ----------------
  parfor  ai = 1 : Na 
% or use :
%  for  ai = 1 : Na 
    ARTEFACT_threshold = Art_all( ai )  
if abs( ARTEFACT_threshold ) >= noise_diff 

   

%  if ai > 3 && skip_iterations == 0 
%          if  max_arts_found_all(end) > handles.par.ARTEFACT_maximum_arts_per_channel   
% %              max_arts_found_all(end-1) > handles.par.ARTEFACT_maximum_arts_per_channel 
%               
%             if ARTEFACT_threshold < 0 
%                 analyze_only_pos_art = true ;
%             else
%                 skip_iterations = 100 ;
%             end
%          else
%               skip_iterations = 0 ;
%          end
%     end
    
     
% if skip_iterations > 0 
%     analyze_next = false ;
%     skip_iterations = skip_iterations - 1 ;
% else
%     analyze_next = true ;
% end

%  analyze_next  = true ;
%      
%   if analyze_only_pos_art && analyze_next
%       if ARTEFACT_threshold > 0  
%       analyze_next  = true ;
%       else
%            analyze_next  = false ;
%       end
%   end
    
% if    analyze_next  

 
    if ARTEFACT_threshold < 0 
     xaux = find( x_diff_test <  ARTEFACT_threshold   ) ; 
     
    else
       xaux = find( x_diff_test >  ARTEFACT_threshold   ) ; 
    end   
%     length( xaux )
    
 if length( xaux )< handles.par.ARTEFACT_maximum_arts_per_channel  

    if ARTEFACT_threshold < 0 
     xaux = find( x_diff <  ARTEFACT_threshold   ) ; 
     
    else
       xaux = find( x_diff >  ARTEFACT_threshold   ) ; 
    end
 end
%     max_arts_found_all =  [ max_arts_found_all length( xaux ) ] ;
      

 xaux2 = xaux ;
 length( xaux ) ;
  if ~isempty( xaux ) 
      if length( xaux )< handles.par.ARTEFACT_maximum_arts_per_channel  
       
% Min_inter_art_points = 100 ;
Min_inter_art_sec = 0.1 ;
Min_inter_art_points = Min_inter_art_sec * sr ; 
DDDT = 30 ;
xaux2 = [ ] ; 
Nxx = length(xaux) ;
Xnx = length( xaux) ;
% new_art_times = zeros( Nxx , 1 ) ;
new_art_times = [ ] ;
% Nxx = 10 ; 
       for i=1: Nxx
%---- copy of adjust_artefacts_3.m---------------------
%---- copy of adjust_artefacts_3.m---------------------
%---- copy of adjust_artefacts_3.m---------------------
            diff_a = abs( xaux(  i+1 : Xnx  ) - xaux( i ) ) ;
            d = find( diff_a < Min_inter_art_points ) ; 
            d = d + i ;
            check_is = [ i d ]  ;
            xaux(  check_is );
%             local_amps = xf_detect( xaux(  check_is ) ) ;
         local_amps = x_diff( xaux(  check_is ) ) ;

            [ min_amp, min_i ] = min( local_amps ) ;
            X1 = xaux( check_is( min_i ) ) - DDDT ;
            X2 =  xaux( check_is( min_i ) ) + DDDT ;
            if X1 >=1 && X2 < length( x )
                
%             art_sig = x( X1  : X2 );
            art_sig = x_diff( X1  : X2 );
%             figure 
%             plot( abs( art_sig ) )
%             [ ap , art_peak_i ] = max( abs( art_sig )) ;
            if ARTEFACT_threshold < 0 
%                  xaux = find( x_diff <  ARTEFACT_threshold   ) ; 
                  [ ap , art_peak_i ] = min( ( art_sig )) ;
            else
                 [ ap , art_peak_i ] = max( ( art_sig )) ;
            end
%             ap
            new_art_i = xaux( check_is( min_i ) ) - DDDT + art_peak_i - 1   ; 
%             ap_check = x( new_art_i ) 
%             ap_check = x( new_art_i -4 : new_art_i +4  ) 
%             new_art_i_ms = new_art_i * ( 1e3/handles.par.sr)  
%             amp_curr =   abs(  xf_detect(  xaux(  i )  ) ) ; 
         if numel ( new_art_times ) > 0 
             if   abs( xaux( i )  -  new_art_times( end)) > Min_inter_art_points   
                 new_art_times = [ new_art_times  new_art_i ] ;
             else
                ;
%                 xaux2 = [ xaux2 xaux( i )];  
             end
         else
            new_art_times =  new_art_i  ; 
         end
            end 
       end 
xaux2 = new_art_times ; 
%---- copy of adjust_artefacts_3.m---------------------
%---- copy of adjust_artefacts_3.m---------------------
%---- copy of adjust_artefacts_3.m---------------------
        artefacts_buf = xaux2;
        
     Thr_from = collect_sigma_from ;
    Thr_To =  collect_sigma_to ;
    if Thr_To > 0   
        artefacts_buf = artefacts_buf(  artefacts_buf > collect_sigma_from );
        artefacts_buf = artefacts_buf( artefacts_buf < collect_sigma_to );
     end
        
        artefacts_diff = diff( artefacts_buf ); 
        artefacts_diff_sec_buf = diff(  ( artefacts_buf / sr ) )  ;
        if numel(artefacts_buf)  < handles.par.ARTEFACT_thr_search_max_artefacts
        Art_num_all(ai) = numel(artefacts_buf)   ; 
        
        
        artefacts_points_diff = diff(artefacts_buf) ;
%         figure
%                        plot(  artefacts_ms_diff )
%                        ylabel( 'Inter artifact intervals, ms ' ) 

 artefacts_ms_diff_filt = ( artefacts_points_diff / sr ) * 1000  ;
 artefacts_ms_diff_filt0=artefacts_ms_diff_filt/1000;
                       
                       eras = find( artefacts_ms_diff_filt > handles.par.Max_interArtifact_interval_sec * 1000 ) ;
                       artefacts_ms_diff_filt( eras ) = []   ; 
%                         art_x  = 1:numel( artefacts_ms_diff ) ;
%                        art_x( eras ) = [] ; 
                       % %% filtered intervals for optimal artifact search
%                        plot( art_x , artefacts_ms_diff_filt , '*r')
                       % %% 'Adequate intervals'
                       [h,p]= hist( artefacts_ms_diff_filt , 50 ) ;
                       [mx,mxi] = max( h ) ; % find peak in hist 
%                        most_frequent_interval = p( mxi ) / 1000   % get interval at that peak ;
                       most_frequent_interval = median(   artefacts_points_diff / sr )  ;

                      
%                        [ most_frequent_interval , max_int_i ] = max( artefacts_ms_diff_filt ) ;
                       if ~isempty( most_frequent_interval ) 
                           mfi = most_frequent_interval ;
                       else
                           mfi = 0 ;
                       end
                           
                       mfi = min( artefacts_ms_diff_filt0) ;
                        if ~isempty( mfi ) 
                           mfi = mfi ;
                       else
                           mfi = 0 ;
                       end
                       
                            Art_most_freq_Interval_sec(ai) =  mfi    ;

        
        Ax(ai) = ARTEFACT_threshold  ;
        artefacts_diff_sec(ai) = std( artefacts_diff_sec_buf )  ;
        end
         
        
      end
  end
 
% end
end
 end
%------------ parfor ----------------
 
%  whos artefacts

% figure
% hold on
% plot( Ax , Art_num_all , 'b-*' )
% plot( Ax , artefacts_diff_sec  , 'r-*')
% plot( Ax , Art_most_freq_Interval_sec ,'g-*') 




      
 Art_most_freq_Interval_sec(Art_most_freq_Interval_sec==0) = NaN ;
 
  Art_most_freq_Interval_sec( Art_most_freq_Interval_sec  <=  handles.par.Art_freq_Interval_sec_Minimum ) = NaN ;
 
 f = find( isnan( Art_most_freq_Interval_sec  ));
  Art_num_all( f ) = NaN ;
  
 Art_num_all(Art_num_all==0) = NaN ;
 
 

Art_num_all( Art_num_all < handles.par.Art_num_all_minimum ) = NaN ;
 
  artefacts_diff_sec(artefacts_diff_sec==0) = NaN ;
 
 Diff_to_most_freq_and_expected = Art_most_freq_Interval_sec - ARTEFACT_thr_search_expected ;
 low_T =0 - handles.par.ARTEFACT_deviation_sec  ;
high_T =0 + handles.par.ARTEFACT_deviation_sec  ;

dfd1 = find( Diff_to_most_freq_and_expected < low_T ) ;
dfd2 = find( Diff_to_most_freq_and_expected > high_T ) ;
% & Diff_to_most_freq_and_expected < high_T ) ;
Diff_to_most_freq_and_expected_cleam = Diff_to_most_freq_and_expected ; 
Diff_to_most_freq_and_expected_cleam(  dfd1 ) = NaN ;
Diff_to_most_freq_and_expected_cleam(  dfd2 ) = NaN ;
 Diff_to_most_freq_and_expected_cleam=abs(Diff_to_most_freq_and_expected_cleam) ;


 
a1 = Diff_to_most_freq_and_expected_cleam ; % a1 - diff to expect
a2 = artefacts_diff_sec ; % 'art std, sec'

% a1=a1/max(a1) ;
if max(a1)-min(a1) == 0 
%     a1(:) = min(a1) ;
else
a1=(a1- min(a1))/(max(a1)-min(a1) ) ;
end

if max(a2)-min(a2) == 0 
    a2(:) = min(a2) ;
     
    a2( Ax == 0 )  = NaN ;
    
else
a2=(a2- min(a2))/(max(a2)-min(a2) ) ;
end


a3 = (Art_num_all - min( Art_num_all)) / ...
    ( max( Art_num_all ) - min( Art_num_all) );
% a3(a3==0)= NaN ;


if ~art_find_Method_by_min_ISI_std
 %++++++++++++++
axx  = a1   + 1*( 1 - a3) + a2 ;
%++++++++++++++++++++++
else

% axx  = a1.* a2 ;

% Art_num_all_minimum = 5 ;
 
f = find( isnan(Art_num_all) ) ;
a2( f  ) = NaN ;
  
axx  = a2 ;

end
% figure ;
% hold on
% plot( Ax , Art_num_all/60 , 'r-' )
% plot( Ax , a2 )


%++++++++++++++++++++++

if  ~handles.plot_multiple_signals
     if show_figures

 figure; 
 Ny = 5 ; Nx = 1 ;
% hold on
h1 = subplot( Ny , Nx , 1 ) ;


 plot( Ax , Art_num_all , '-*' )
 title( 'Art num ') 
 
 h2 = subplot( Ny , Nx , 2 ) ;

 
%   plot( Ax , ( art_std_all / max(Ymx) ) * Ymx   , '-r*' )

  plot( Ax ,  artefacts_diff_sec     , '-r*' )
%     plot( Ax ,  a2     , '-r*' )

   title( 'int-art std, sec') 
   
h3 =  subplot( Ny , Nx , 3 ) ;

 plot( Ax , ( Art_most_freq_Interval_sec  )    , '-g*' )
 title( 'most frequent Interval (a1), sec') 
 
 
 
 
 
 h4 =  subplot( Ny , Nx , 4 ) ;

hold on
plot( Ax , ( a1 )    , '-g*' )
 plot( Ax , ( a2 )    , '-r*' )
plot( Ax , ( 1 - a3 )    , '-b*' )
legend( 'a1 = Diff expctd int' , 'a2 = int-art std ', '1 - a3 = 1-art num');
hold off


%  plot( Ax , ( Diff_to_most_freq_and_expected_cleam )    , '-g*' )
%  title( 'difference - expexted and most freq, sec') 

 h5 =  subplot( Ny , Nx , 5 ) ; 

 
hold on
%  plot(  Ax , a1  )
 
% plot( Ax , Art_num_all / max( Art_num_all ) , '-*r' )



plot(  Ax , axx , '-*g'  )
title(  'a1 * a2')
% title(  'Diff expctd int + (1-art num) + int-art std = ( a1+10*(1-a3)+a2 )')



xlabel( 'Threshold' ) 
 
%  legend( 'Art_num_all','art_std_all','most_freq_Interval_sec')
linkaxes( [ h1 h2 h3 h4 h5] ,'x' )
 
     end
end
 
axx2 = axx ;

% axx2( axx2 == NaN ) = 0 ;
% axx2( isnan( axx2) ) = 0 ;
[ minaxx , min_axx_i ] = min( axx2 ) ;

            [ minaxx , min_axx_i ] = min( axx2 ) ;
    
            
             ARTEFACT_threshold_optimal =  Ax( min_axx_i(1) )  
             ARTEFACT_threshold = ARTEFACT_threshold_optimal ;

             Optimal_Interval_variability_std_sec = artefacts_diff_sec( min_axx_i(1)  ) / 1000   
Optimal_Number_of_Artifacts = Art_num_all( min_axx_i(1)  )  

%+++++++++++++++++++++++++++
%+++++++++++++++++++++++++++
Optimal_Closest_interval_to_expected = Art_most_freq_Interval_sec( min_axx_i(1)  )  
%+++++++++++++++++++++++++++
%+++++++++++++++++++++++++++

           
            %%'Diff most expctd intrv + (1-artf number)')
            option_data.Optimal_art_criteria = minaxx ;
            option_data.Optimal_art_Optimal_Closest_interval_to_expected = Optimal_Closest_interval_to_expected ;
            option_data.Optimal_art_Optimal_Number_of_Artifacts=Optimal_Number_of_Artifacts ;
            option_data.Optimal_art_Optimal_Interval_variability_std_sec = Optimal_Interval_variability_std_sec ;
      
            
            


%  whos Art_num_all
 
%  aex = handles.par.ARTEFACT_thr_search_expected ;

Optimal_electrode_is_minimal_std = false ;

if Optimal_electrode_is_minimal_std 
     axi   = find( Art_num_all == ARTEFACT_thr_search_expected ) ;
      if ~isempty( axi )
            ARTEFACT_threshold_optimal =  Ax( axi(1) ) ; 
            if numel( axi ) > 1  
            std_find = artefacts_diff_sec( axi(1) ) ;
            [ minstd , min_std_i ] = min( std_find ) ;
            minstd 
            min_std_i = find( minstd == artefacts_diff_sec );
             ARTEFACT_threshold_optimal =  Ax( min_std_i(1) ) ;
            end
      end
 
  
ARTEFACT_threshold_optimal

ARTEFACT_threshold = ARTEFACT_threshold_optimal ;
% find artifacts with new optimal threshold


else
   ARTEFACT_thr_search_expected 
   
%    handles.par.Good_interArtifact_interval_sec = 1 ; 
    
    if handles.par.Good_interArtifact_interval_sec > 0 
    
    Art_most_freq_Interval_sec = Art_most_freq_Interval_sec / 1000 ;

    Art_most_freq_Interval_sec( Art_most_freq_Interval_sec == 0 ) = NaN ;
    
Diff_to_expected_interval = Art_most_freq_Interval_sec - handles.par.Good_interArtifact_interval_sec ;

% figure 
% plot( Diff_to_expected_interval )
% title( 'Diff to expected interval' )


% Diff_to_expected_interval = Diff_exp_int
[ Closest_diff_interval_to_expected , min_index_Diff_exp_int ] = min( Diff_to_expected_interval ) ;
Closest_diff_interval_to_expected ;

index_of_closest_found_interval = min_index_Diff_exp_int ;


Optimal_Interval_variability_std_sec = artefacts_diff_sec( index_of_closest_found_interval ) / 1000   
Optimal_Number_of_Artifacts = Art_num_all( index_of_closest_found_interval )  

%+++++++++++++++++++++++++++
%+++++++++++++++++++++++++++
Optimal_Closest_interval_to_expected = Art_most_freq_Interval_sec( index_of_closest_found_interval ) 
Found_interval_to_expected = Optimal_Closest_interval_to_expected;
Found_Number_of_Artifacts = Optimal_Number_of_Artifacts  
%+++++++++++++++++++++++++++
%+++++++++++++++++++++++++++
 

% min_std_i = find( minstd == art_std_all );

%     Art_most_freq_Interval_ms(1)
  ARTEFACT_threshold_optimal =  Ax( index_of_closest_found_interval(1) ) ;  
    end
end



  
end    

 testn = 5000 ;    
x_diff_test = x_diff(1:testn);
x_diff_test = x_diff ;
    if ARTEFACT_threshold < 0 
     xaux = find( x_diff_test <  ARTEFACT_threshold   ) ; 
     
    else
       xaux = find( x_diff_test >  ARTEFACT_threshold   ) ; 
    end   
    
    if length( xaux )< handles.par.ARTEFACT_maximum_arts_per_channel  
 
                if ARTEFACT_threshold < 0 
                 xaux = find( x_diff <  ARTEFACT_threshold   ) ; 
                else
                   xaux = find( x_diff >  ARTEFACT_threshold   ) ; 
                end

             xaux2 = xaux ;
              if ~isempty( xaux ) 
                   adjust_artefacts_3 
                    artefacts = xaux2;
                    
                       Thr_from = collect_sigma_from ;
    Thr_To =  collect_sigma_to ;
    if Thr_To > 0  
%         whos artefacts
    artefacts = artefacts(  artefacts > collect_sigma_from );
    artefacts = artefacts(  artefacts < collect_sigma_to );
%     whos artefacts
    end
%                     if numel(artefacts)  < handles.par.ARTEFACT_thr_search_max_artefacts
%                     Art_num_all = [ Art_num_all numel(artefacts) ] ; 
%                     Ax = [ Ax ARTEFACT_threshold ] ;
%                     end
                    artefacts_diff = diff( artefacts ); 
%                     artefact_amps  = x( artefacts ) ; 
              end
  
    else
        ARTEFACT_threshold_to_small = 1 
        
        ARTEFACT_threshold        
       
        Please_Increase_absolute_value_threshold = 1 
         artefacts =  [] ;
    end

 


end
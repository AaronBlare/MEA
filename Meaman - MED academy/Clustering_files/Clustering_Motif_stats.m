
function clus_results = Clustering_Motif_stats( cluster_index , Clusters_number , var ) 
% var.superbursts_times_mark = true ;
% var.burst_index_in_each_Superbursts


 
nbins = 23 ;

     Nx = 2 ; Ny =3 ;

     index_ms = [] ; 
     if isfield( var , 'index_ms' )
        index_ms = var.index_ms ;          
     end
     
     Spb_switch_prob_global = 0 ; 
     patt_in_clust = 0 ; 
     Pattern_switch_prob = 0 ; 
   Pattern_switch_prob_global= 0 ; 
   SPb_clus_index = 0 ; 
   Spb_clus_optim2 = 0 ; 
   Spb_switch_prob_global = 0 ; 
%      index_ms = [] ; 
     
 patt_in_clust = [] ;
motifs_times = cell( Clusters_number ,1 ) ;
motifs_times_samp = cell( Clusters_number ,1 ) ;
for i = 1 : Clusters_number
    [ f , fi ]  = find( cluster_index == i ) ;
    patt_in_clust = [ patt_in_clust  length( f) ] ;
    if ~isempty( index_ms)
    f = index_ms( f  )/1000;
    end
    motifs_times_samp{ i } = f ; 
    f = diff( f );
    motifs_times{ i } = f ;
end 
patt_in_clust_sort =  sort( patt_in_clust  ,'descend');
patt_in_clust_sort = 100 * patt_in_clust_sort / length( cluster_index );

Pattern_switch_prob = zeros( Clusters_number , 1 ) ;
Pattern_switch_prob_global = 0 ; 
for i = 1 : length( cluster_index ) - 1
  if   cluster_index( i ) ~= cluster_index( i + 1)
      Pattern_switch_prob( cluster_index( i ) ) = Pattern_switch_prob( cluster_index( i ) ) + 1 ;
      Pattern_switch_prob_global = Pattern_switch_prob_global + 1 ;
  end    
end
Pattern_switch_prob_global = 100 * Pattern_switch_prob_global /  length( cluster_index ) 
Pattern_switch_prob = Pattern_switch_prob ./ patt_in_clust'  ;
Pattern_switch_prob = 100 * Pattern_switch_prob ;

fi = 0 ; 

         fig_patt_clus = figure ;
        subplot( 1,3,1)
         bar( Pattern_switch_prob );
         title( ['Motif switch probability' ])
         ylabel( 'Switch probability, %' )
         xlabel( 'Motif #')
        subplot(1,3,2)
         bar( 100 *patt_in_clust / length( cluster_index ));
         title( ['Motif appearance' ])
         ylabel( 'Appear probability, %' )
         xlabel( 'Pattern #') 
        subplot(1,3,3)
         plot( 100 *patt_in_clust / length( cluster_index ) , Pattern_switch_prob , '*' , 'Linewidth' , 3 );
         title( ['Switch vs. appear' ])
         ylabel( 'Appear probability, %' )
         ylabel( 'Switch probability, %' )
         
%          legend( Legend_str );
        %------------------------- 
        
%         colormap( fig_patt_clus , summer );
        colormap( fig_patt_clus , jet );

%% Superburst stats -------------- 
Legend_str = {} ;
if isfield( var , 'superbursts_times_mark' )
    if var.superbursts_times_mark
        
        % checking how good SuperB separated by motifs
        var.burst_index_in_each_Superbursts;
        Cluster_found_SPb = [] ;
        for SBi = 1 : var.Number_of_Superbursts 
           ind = var.burst_index_in_each_Superbursts{ SBi} ;
%            f =   cluster_index( ind) ;
           clus_ind = cluster_index( ind ) ;
           c_ind = [] ;
           for ci = 1 : Clusters_number
               ci_n = find( clus_ind == ci );
               ci_n = length( ci_n );
               c_ind = [ c_ind  ci_n ] ;
           end
           Cluster_found_SPb = [ Cluster_found_SPb ; c_ind ];  
        end
        N_clus_Spb = floor(var.Number_of_Superbursts / 2 ) ;
        [centers2,clusters2, err, DB_all] = kmeans_clusters(Cluster_found_SPb , N_clus_Spb  , 25 ); % find clusterings
        [minDB,i] = min( DB_all) ; % select the one with smallest index
         minDB;
         Spb_clus_optim2 = 2 ;
         SPb_clus_index = clusters2{ Spb_clus_optim2 } ; 
         
         % find whne spb swithes
         Num_swithes = 0 ;
         for SPb_i = 1 : var.Number_of_Superbursts - 1
            if  SPb_clus_index( SPb_i ) ~= SPb_clus_index( SPb_i + 1 )
               Num_swithes = Num_swithes + 1; 
            end
         end
         Spb_switch_prob_global = 100* Num_swithes / var.Number_of_Superbursts ;
         
         Cluster_found_sum = []; 
         for clust_spb = 1 : Spb_clus_optim2 
            f = find( SPb_clus_index ==  clust_spb );
            b = [];
            for ci = 1 : Clusters_number 
                a = sum( Cluster_found_SPb( f , ci ) );
                b=[ b a ] ;
            end
            Cluster_found_sum = [ Cluster_found_sum ; b];
            num_burst_in_spb = sum(  Cluster_found_sum( clust_spb , : ) );
            for ci = 1 : Clusters_number
                Cluster_found_sum( clust_spb , ci ) = 100 * Cluster_found_sum( clust_spb , ci ) ...
                    / num_burst_in_spb ; 
            end
         end
         for ci = 1 : Clusters_number 
             new_str = ['Motif #' num2str( ci) ];
                Legend_str = [ Legend_str new_str ] ;
         end   
         
           figure
             plot( DB_all , 'Linewidth' , 2  )
             title( 'SPb Clusterisation quality')
%              xlim( [ 2 length( DB_all ) ] );
%              xlim( [ 2 length( DB_all ) ] );
             ylabel( 'DB index')
             xlabel( 'Clusters number' )
 
         
         fig_spb_clus = figure ;
         bar( Cluster_found_sum );
         title( ['Motif probability in superburst, Switch f=' num2str( Spb_switch_prob_global ) ' %' ])
         ylabel( 'Motif probability, %' )
         xlabel( 'Superburst type')
         legend( Legend_str );
        %------------------------- 
        
%         colormap( fig_spb_clus , summer );
%          colormap( fig_spb_clus , hsv );
          colormap( fig_spb_clus , jet );
        fi = 2; 
        Ny = Ny + 1 ;
        var.burst_index_in_each_Superbursts = var.burst_index_in_each_Superbursts ;
       

       s = length( var.burst_index_in_each_Superbursts );
       
        motifs_color = zeros( 1 , length( cluster_index )) ;
       for SBi = 1 : s 
           motifs_color( var.burst_index_in_each_Superbursts{ SBi}(1):var.burst_index_in_each_Superbursts{ SBi}(end) ) = ...
               SPb_clus_index( SBi ) ;
           motifs_color( var.burst_index_in_each_Superbursts{ SBi}(1)) = Spb_clus_optim2 + 1 ;
           motifs_color( var.burst_index_in_each_Superbursts{ SBi}(end)) = Spb_clus_optim2 + 1 ;
       end
       
       f0 = figure ;
       cmap = colormap( f0 , hot ) ;   
       
       h1 = subplot( Ny , Nx ,1:2  );
        imagesc( motifs_color )
        colorbar
        colormap hot
        title( 'Superburst marker') 
    else
            f0 = figure ;
    cmap = colormap( f0 , hot ) ; 
    end
else
    
    f0 = figure ;
    cmap = colormap( f0 , hot ) ; 
end

clus_results.patt_in_clust = patt_in_clust ; % вектор размерность - количество мтотивов, каждое число - сколько берстов в каждом мотиве
clus_results.Pattern_switch_prob = Pattern_switch_prob ; 
clus_results.Pattern_switch_prob_global= Pattern_switch_prob_global ; % вероятность смены  мотива в последовательности берстов. это число,
% которое говорит, как часто берст переключался с одного мотива на другой в
% очереди берстов (Fig 5 C)
clus_results.SPb_clus_index = SPb_clus_index ;
clus_results.Spb_clus_optim2 = Spb_clus_optim2 ;
clus_results.Spb_switch_prob_global = Spb_switch_prob_global ;
 
%% Figures



h2 = subplot( Ny , Nx ,1+ fi:2 + fi );
    var.new_figure = false ;
    Clustering_motifs_timelapse_color( cluster_index  , var )

if isfield( var , 'superbursts_times_mark' )
    if var.superbursts_times_mark
        linkaxes( [ h1 h2 ], 'x' )
    end
end

subplot( Ny , Nx , 3 +fi  )
    bar( patt_in_clust_sort )
    
%     plot( log10( 1:Clusters_number ) , log10( patt_in_clust_sort  ))
    
    xlabel( 'Pattern #')
    ylabel( 'Probability, %')

    
    

    
    
    
% cmap = colormap( 'copper' ); 

 nclr = size(cmap,1);

% figure
subplot( Ny , Nx , 4 + fi)
hold on


 nclr = size(cmap,1);

    legend_str = {};
    data_for_hist = {} ;
    max_val = 0 ;
%     figure
    for i = 1 : Clusters_number
        f = motifs_times{ i } ;
        data_for_hist = [ data_for_hist f ] ;
        if max_val < max(f)
           max_val = max(f) ; 
        end
        if length( f) > 3 
          [nelements,xcenters] = hist( f , nbins );
         ci  = floor( (  i  ) / (Clusters_number )   *  nclr  )    ;
%         plot( xcenters , nelements , ...
%              'Color' , cmap(ci     ,:) , 'Linewidth' , 2 )
% %         plot( log10( xcenters ) , log10( nelements ), ...
% %              'Color' , cmap(ci     ,:) , 'Linewidth' , 2 )         
%          legend_str = [ legend_str num2str( i ) ] ;
%          xlabel( 'Interval')
%          ylabel( 'Probability')
        end
        
        times = motifs_times_samp{ i };
        
        if length( times ) > 20 
        %----------------- 
        legend_str = [ legend_str num2str( i ) ] ;
        
        
        Nsamps =1 + max( times ); 
        Fs = 1    ;
        t = (1/Fs)*(1:Nsamps);         %Prepare time data for plot
        y = zeros( 1 , Nsamps );
        
%         y  = 1 * sin(  t  *0.5 ) ;
        
        y( floor( times + 1 ))= 1;
%         y(  (  ( y1 ) > 0.5 ))= 1;
        
        %Do Fourier Transform
        y_fft = abs(fft(y));            %Retain Magnitude
        y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
        y_fft = smooth( y_fft  , 3 );
        f = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot

        %Plot Sound File in Time Domain
%         figure
%         plot(t, y)
%         xlabel('Time (s)')
%         ylabel('Amplitude')
%         title('Tuning Fork A4 in Time Domain')
%         figure
        %Plot Sound File in Frequency Domain
        
        ci  = floor( (  i  ) / (Clusters_number )   *  nclr  )    ; 
        
%         plot(f * (2*pi), y_fft ,  'Color' , cmap(ci     ,:) )
         plot(f , y_fft ,  'Color' , cmap(ci     ,:) )

%         xlim([0 1000])

        xlabel('Frequency (pattern/time)')
        ylabel('Amplitude')
        title('Frequency Response of Tuning Fork A4')
        %-0-------------------
        end
        
        

    end
    legend( legend_str )
    
    
    legend_str = {};
    if max_val / nbins < 1 
        x = 0 :  ( 1): max_val ;
    else
        x = 0 :  ( max_val / nbins ): max_val ;
    end
%     x = -1 : 3  : max_val ;
    hist_all = [] ;
    for i = 1 : Clusters_number 
        f = motifs_times{ i } ;
        if length( f) > 3 
           nelements  = histc( f , x );
           nelements = nelements/ length( f) ;
           if ~iscolumn( nelements )
               nelements = nelements';
           end
           hist_all = [ hist_all      nelements ];  
           legend_str = [ legend_str num2str( i ) ] ;
        end
    end
    
%     figure
subplot( Ny , Nx , 5 + fi  )


% Pattern_switch_prob

    plot(   x , hist_all) 
         xlabel( 'Interval')
         ylabel( 'Probability')
    legend( legend_str )
    
    hold off

    
    
    if ~isempty( var.centers )
        whos var.centers
        subplot( Ny , Nx , 6 + fi)
     
%             centers_m = [] ;
%             for i = 1 : Clusters_number 
%                 f = var.centers{ i } ;
%                 centers_m = [ centers_m ;  ( f ) ] ; 
%             end
%                 centers_m =  ( var.centers  );
% centers_m =  ( var.centers  );
        centers_m = cell2mat( var.centers' );
            imagesc( centers_m )
            colorbar
%             colormap hot 
            xlabel( 'Pattern #')
            ylabel( 'Motif #')
        
        
        
    end

colormap( f0 ,  hot)




% amp_Calc_characteristics.m
                                                                        if Calc_characteristics == 'y'


                                                                        DDT = 50 ; % Bin in ms
                                                                        FreqBin_ms = 50 ;
                                                                        SPDT_Thr = 5 ; % spikes per DT threshold for burst detect
                                                                        Rmax = 2 ;
                                                                        Nsteps = 20  ;


                                                                        DT = floor( DDT * sr/1000 ) ;
                                                                        FreqBin = floor( FreqBin_ms * sr/1000 ) ;
                                                                        ASR = [] ;
                                                                        k = 1 ;
                                                                        for ti = 1 : DT : ( length( xf ) - DT )
                                                                          s = length( find( ( index >= ti ) & ( index < ti + DT ) ) ) ;
                                                                          ASR( k ) = s ;
                                                                          k = k + 1 ;
                                                                        end
                                                                        ti = 1 : DT : ( length( xf ) - DT ) ;
                                                                        figure
                                                                         plot( ti , ASR )



                                                                        [c,i] = max( ASR ) ;
                                                                        [cmin,imin] = min( ASR ) ;
                                                                        bi = i ;
                                                                        T_start_burst = bi ;

                                                                        Msx_freq_spikes = c  ;
                                                                        Min_freq_spikes = cmin   ;
                                                                        T_msx_freq = i*DT ;
                                                                        T_min_freq = imin*DT ;



                                                                        noise = zeros(1 , DT ) ;
                                                                        signal = zeros(1 , ( Nsteps + 500 ) * DT  ) ;
                                                                         b = zeros( 1 ,  (Nsteps + 500 ) * DT )   ;

                                                                        signal( 1 : DT ) = xf( T_msx_freq : T_msx_freq + DT - 1 ) ;
                                                                        noise( 1 : DT ) = xf( T_min_freq : T_min_freq + DT - 1 ) ;

                                                                        R = 0.1 : 0.2 : 2 ;

                                                                        Dr_SD = zeros( 1 , length(R) );
                                                                        Dr_absX = zeros( 1 , length(R) );
                                                                        Dr_x2 = zeros( 1 , length(R) );

                                                                        Rk = 0 ;
                                                                        R = 1 ;
                                                                        %   for R = 0.2 : 0.1 : Rmax  %------------
                                                                        Rk = Rk + 1 ;

                                                                        sigma1 = [] ;
                                                                        sigma2 = [] ;
                                                                        sigmaSD = [] ;
                                                                        freq = [] ;


                                                                          for i= 1 :  DT
                                                                             b(i)=signal(i)*signal(i);
                                                                          end
                                                                          sigma2( 1 ) = median( b( 1  : DT ) / ( R * std(signal( 1  : DT  )) ) ); 
                                                                          sigm( 1 ) = median(abs( signal( 1  : DT  ) / R  )); 
                                                                          sigmaSD( 1 ) = std( signal( 1  : DT  ) /  R );  
                                                                          freq( 1 ) = Msx_freq_spikes / ( ( DT ) / (sr/1000) ) ;
                                                                          F( 1 ) = freq( 1 ) ;

                                                                        k = 2 ;
                                                                        Ns = 20 ;
                                                                        TTT  = DT ;
                                                                        for i=1 : Ns
                                                                          signal( DT * i : DT*i + DT - 1 ) =   signal( 1 : DT ) ;
                                                                          TTT = TTT + DT ;
                                                                        end





                                                                        N_noise_added = 0 ;
                                                                        for ni = 1 : Nsteps

                                                                          for tn = 1 :  ni 
                                                                          TTT = TTT + DT ;
                                                                          signal( TTT - DT + 1 : TTT    )  = noise ;
                                                                          N_noise_added = N_noise_added + 1 ;
                                                                          end
                                                                          sigma1( k ) = median(abs( signal( 1   : TTT ) / R  ));

                                                                          for i= 1 : TTT
                                                                             b(i)=signal(i)*signal(i);
                                                                          end
                                                                          sigma2( k ) = median( b( 1  : TTT ) / ( R * std( signal( 1  : TTT )) ) ); 
                                                                            sigmaSD( k ) = std( signal( 1  : TTT ) /  R ); 
                                                                          freq( k ) = (Msx_freq_spikes*Ns + N_noise_added * Min_freq_spikes) / ( (    TTT ) / (sr/1000) ) ;% spikes per ms
                                                                          F( ni ) = freq( k ) ; 

                                                                          k = k + 1 ;  
                                                                        end  





                                                                          for i= 1 : DT
                                                                             b_noise(i)=noise(i)*noise(i);
                                                                          end
                                                                        %   sigma2( k ) = median( b( T1  : T_start_burst ) / ( R * std(xf( T1  : T_start_burst )) ) ); 
                                                                        %   sigma1( k ) = median(abs( xf( T1   : T_start_burst ) / R  )); 
                                                                        %   sigmaSD( k ) = std( xf( T1  : T_start_burst ) /  R );  
                                                                          sigma2( k ) = median( b_noise(1:end) / ( R * std( noise ) ) ); 
                                                                          sigma1( k ) = median( abs( noise(1:end) / R  )); 
                                                                          sigmaSD( k ) = std( noise(1:end) /  R );  

                                                                          freq( k ) = Min_freq_spikes / ( (  TTT ) / (sr/1000) ) ; 

                                                                          figure
                                                                        % %    plot( freq ,  sigma1 , freq , sigma2  )  
                                                                        plot( freq , sigmaSD , freq , sigma1 , freq ,  sigma2  )

                                                                        % delta1 =  max( sigma1 ) - min( sigma1 ) ;
                                                                        % delta2 =  max( sigma2 ) - min( sigma2 ) ;
                                                                        % 
                                                                        % delta1
                                                                        % delta2

                                                                        % Dr_SD( Rk ) = max( sigmaSD ) - min( sigmaSD ) ;
                                                                        % Dr_absX( Rk ) = max( sigma1 ) - min( sigma1 ) ;
                                                                        % Dr_x2( Rk ) = max( sigma2 ) - min( sigma2 ) ;
                                                                        R_absX = sigma1(k) / sigmaSD(k) ;
                                                                        R_x2 = sigma2(k) / sigmaSD(k) ;
                                                                        sigma1 = sigma1 / R_absX ;
                                                                        sigma2 = sigma2 / R_x2 ;
                                                                        R_absX
                                                                        R_x2
                                                                        Dr1_SD = max( sigmaSD ) - min( sigmaSD ) ;
                                                                        Dr1_absX = max( sigma1 ) - min( sigma1 ) ;
                                                                        Dr1_x2 = max( sigma2 ) - min( sigma2 ) ;
                                                                        Dr1_SD 
                                                                        Dr1_absX 
                                                                        Dr1_x2

                                                                        %   end  %------------------
                                                                        %  R = 0.2 : 0.1 : Rmax 
                                                                        figure
                                                                        % plot( R , Dr_SD , R , Dr_absX , R ,Dr_x2 )
                                                                        plot( freq , sigmaSD , freq , sigma1 , freq ,  sigma2  )  

                                                                        end

 




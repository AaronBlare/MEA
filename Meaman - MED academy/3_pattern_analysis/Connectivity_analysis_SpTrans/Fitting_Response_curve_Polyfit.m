                          Fitting_Response_curve_Polyfit
                           %----Poly  fitting ------------ 
                           % Input:
                           % M_of_tau_original , tau_x , Connectiv_data ,
                           % Total_Spike_Rates
                           % Output : tau_max , M_max , M_of_tau
                           
                           
                          ftype = fittype( 'poly6') ;  
    %                       warning off
                                 
                          fresult = fit( x_normed' ,M_of_tau_original , ftype );
                          p = [  fresult.p1 fresult.p2 fresult.p3 fresult.p4 fresult.p5  fresult.p6 fresult.p7 ];
                          M_of_tau_poly_fit = polyval(p,x_normed);
                          y_fit = M_of_tau_poly_fit ;
                          M_max = max( M_of_tau_poly_fit );  
                          tau_max_index = find( M_of_tau_poly_fit == M_max ,1) ;            
                           tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
                           if Total_Spike_Rates( chi ) > 0 &&  Total_Spike_Rates( chj ) > 0
                                     Connection_OK = true ;
                                    M_of_tau  =   M_of_tau_poly_fit ;
                           end
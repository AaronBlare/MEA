                          Fitting_Response_curve_Smooth
                           %---- Smooth fitting ------------ 
                           % Input:
                           % M_of_tau_original , tau_x , Connectiv_data ,
                           % Total_Spike_Rates
                           % Output : tau_max , M_max , M_of_tau 
                           
                           
%                            M_of_tau0 = M_of_tau ;
                          y_fit = smooth(M_of_tau, 45 , 'rloess' );
%                           y_fit = smooth(M_of_tau,55  );
                          M_of_tau_fit = y_fit ;
                          M_max = max( M_of_tau_fit );  
                          tau_max_index = find( M_of_tau_fit == M_max ,1) ;            
                           tau_max = ( tau_max_index - 1)*Connectiv_data.params.tau_delta ;  
                           if Total_Spike_Rates( chi ) > 0 &&  Total_Spike_Rates( chj ) > 0
                                     Connection_OK = true ;
                                    M_of_tau  =   M_of_tau_fit ;
                                    
%                           x= ;y=;xi= ;  xs=  0 : 5 : Connectiv_data.params.tau_max ;         
                           end
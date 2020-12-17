          
% Plot_differencies_Dots

%---- Plot dots - x-diff ctrl1-ctrl2, y- diff ctrl2-tet1  //// 
% //////  diff_mean_only_active
            figure
            TotalRate_num = 1 ; % low responses
            
            hold on
            
%             plot(  [ - 300 300 ] , [ 0 0 ] , 'b' )
%             plot(  [  0  0 ] , [ -300 300 ] , 'b' )
            %-- Ctrl 1 - ctrl 2 
                    plot( All_data_all_exp_ctrl( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , ...
                          All_data_all_exp_ctrl( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , '*b' )
            %-- Ctrl 2 - Tet1 
                    plot( All_data_all_exp_Tet1( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , ...
                          All_data_all_exp_Tet1( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , '*r' )    
            %-- Ctrl 2 - Tet2 
                    plot( All_data_all_exp_Tet2( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , ...
                          All_data_all_exp_Tet2( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , '*g' )                   
                
                grid on
                hold off
                legend( 'Ctrl' , 'Tet1' , 'Tet2')
            xlabel( 'Difference Ctrl1-Ctrl2')
            ylabel( 'Difference Ctrl2-Tet')
            title('Low responses. One dot-one channel. Mean difference ') 
            axis square
           %------------------------------ Plot dots
           
  %---- Plot dots - x-diff ctrl1-ctrl2, y- diff ctrl2-tet1  //// 
% //////  diff_mean_only_active
            figure
            TotalRate_num = 1 ; % low responses
            
            hold on
            
%             plot(  [ - 300 300 ] , [ 0 0 ] , 'b' )
%             plot(  [  0  0 ] , [ -300 300 ] , 'b' )
            %-- Ctrl 1 - ctrl 2 
                    plot( All_data_all_exp_ctrl( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , ...
                          All_data_all_exp_ctrl( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , '*b' )
            %-- Ctrl 2 - Tet1 
                    plot( All_data_all_exp_Tet1( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , ...
                          All_data_all_exp_Tet1( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , '*r' )    
            %-- Ctrl 2 - Tet2 
                    plot( All_data_all_exp_Tet2( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , ...
                          All_data_all_exp_Tet2( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , '*g' )                   
                
                grid on
                hold off
                legend( 'Ctrl' , 'Tet1' , 'Tet2')
            xlabel( 'Difference Ctrl1-Ctrl2')
            ylabel( 'Difference Ctrl2-Tet')
             title('Low responses. One dot-one channel. Mean difference ratio') 
             axis square
           %------------------------------ Plot dots         
           
           
%-----------------------------------           
%/////// High responses
%-------------------------------------
           
           
   figure
            TotalRate_num = 2 ; % low responses
            
            hold on
            
%             plot(  [ - 300 300 ] , [ 0 0 ] , 'b' )
%             plot(  [  0  0 ] , [ -300 300 ] , 'b' )
            %-- Ctrl 1 - ctrl 2 
                    plot( All_data_all_exp_ctrl( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , ...
                          All_data_all_exp_ctrl( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , '*b' )
            %-- Ctrl 2 - Tet1 
                    plot( All_data_all_exp_Tet1( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , ...
                          All_data_all_exp_Tet1( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , '*r' )    
            %-- Ctrl 2 - Tet2 
                    plot( All_data_all_exp_Tet2( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , ...
                          All_data_all_exp_Tet2( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_only_active , '*g' )                   
                
                grid on
                hold off
                legend( 'Ctrl' , 'Tet1' , 'Tet2')
            xlabel( 'Difference Ctrl1-Ctrl2')
            ylabel( 'Difference Ctrl2-Tet')
            title('High responses. One dot-one channel. Mean difference ') 
            axis square
           %------------------------------ Plot dots
           
  %---- Plot dots - x-diff ctrl1-ctrl2, y- diff ctrl2-tet1  //// 
% //////  diff_mean_only_active
            figure
            TotalRate_num = 2 ; % low responses
            
            hold on
            
%             plot(  [ - 300 300 ] , [ 0 0 ] , 'b' )
%             plot(  [  0  0 ] , [ -300 300 ] , 'b' )
            %-- Ctrl 1 - ctrl 2 
                    plot( All_data_all_exp_ctrl( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , ...
                          All_data_all_exp_ctrl( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , '*b' )
            %-- Ctrl 2 - Tet1 
                    plot( All_data_all_exp_Tet1( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , ...
                          All_data_all_exp_Tet1( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , '*r' )    
            %-- Ctrl 2 - Tet2 
                    plot( All_data_all_exp_Tet2( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , ...
                          All_data_all_exp_Tet2( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio_only_active , '*g' )                   
                
                grid on
                hold off
                legend( 'Ctrl' , 'Tet1' , 'Tet2')
            xlabel( 'Difference Ctrl1-Ctrl2')
            ylabel( 'Difference Ctrl2-Tet')
             title('High responses. One dot-one channel. Mean difference ratio') 
             axis square
           %------------------------------ Plot dots              
           
           
           
           
           
           
           
           
           
           
           
           
           
           
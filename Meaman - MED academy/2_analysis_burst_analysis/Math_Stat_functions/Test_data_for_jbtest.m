

function result = Test_data_for_jbtest( data ) 
                              fin_num = isfinite( data );
                              fin_num = fin_num( fin_num > 0 );
                              fin_num = length( fin_num ) ;
                              
                              if fin_num > 2
                                  result = true ;
                              else
                                  result = false ;
                              end
                               
                              
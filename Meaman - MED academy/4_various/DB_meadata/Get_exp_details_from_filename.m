
% Test_func

function Exp_date_label = Get_exp_details_from_filename( name )
% Exp_DateAsVector , Culture_DateAsVector = [ yyyy mm dd ]

Exp_date_label = []; 
%  name = '2013_03_17-15_02_2013_h1_gentam-02_stim09_10min__Nlearn_RASTER.mat'  ;
 k=  strfind(   name , '-')   ;
 if length( k )>2
 h =  strfind(   name( k(1)+1:k(2)) , '_')   ;
  
 
 Exp_date =  name(1:k(1)-1) ;
 Culture_date = [] ;
 Culture_label = '' ;
 if length( h ) > 2 
 Culture_date =  name( k(1)+1: k(1)+h(3)-1 ) ;
 Culture_label = name(  k(1)+h(3)+1 : k(2) -1) ;
 end


 Date_str = Exp_date ;
 DateAsVector='';
 k=  strfind(  Date_str , '_')   ;
 if numel( k )>1
     DateAsVector = [ str2num( Date_str(k(2)+1 : end))   ...
                str2num( Date_str(k(1)+1:k(2)-1 )) ...
                str2num( Date_str(1:k(1)-1))  ] ;  
 end
 if ~isempty( k )
     if k(1) == 5 % date '2013_03_23' and year first
        DateAsVector = [ str2num( Date_str(1:k(1)-1))  ...
                    str2num( Date_str(k(1)+1:k(2)-1 )) ...
                    str2num( Date_str(k(2)+1 : end))  ] ;
     end
 end
Exp_DateAsVector = DateAsVector ;


 Date_str = Culture_date ;
 k=  strfind(  Date_str , '_')   ;
  if ~isempty( k )
     if k(1) == 5 % date '2013_03_23' and year first
        DateAsVector = [ str2num( Date_str(1:k(1)-1))  ...
                    str2num( Date_str(k(1)+1:k(2)-1 )) ...
                    str2num( Date_str(k(2)+1 : end))  ] ;
     else
        DateAsVector = [ str2num( Date_str(k(2)+1 : end))   ...
                    str2num( Date_str(k(1)+1:k(2)-1 )) ...
                    str2num( Date_str(1:k(1)-1))  ] ;  
     end
  end
Culture_DateAsVector = DateAsVector ;
 
 
 Exp_date_label.Exp_date_str =  Exp_date ;
 Exp_date_label.Exp_DateAsVector =  Exp_DateAsVector ; 
 Exp_date_label.Culture_date_str =  Culture_date ;
 Exp_date_label.Culture_DateAsVector =  Culture_DateAsVector ; 
 Exp_date_label.Culture_label = Culture_label ;
 
 end
 
 
 
 
 
 
 
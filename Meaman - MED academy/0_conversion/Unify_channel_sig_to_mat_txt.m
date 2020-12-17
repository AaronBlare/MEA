% Unify_channel_sig_to_mat_txt

channels_num = 2 ;
channels_num = 4 ;

all_sig = [];

Cut_fraction = 0  ;

% figure
for fi = 1 : channels_num

  [filename  ,PathName  ] = uigetfile('*.*','Select file');
  fullname  = [PathName  filename ]; 
  reading_file_number = fi
  filename
  
  sig_i = load( fullname );
%   plot( sig_i )
  
  whos sig_i
  if Cut_fraction > 0 
      sig_i( floor( Cut_fraction * length( sig_i )) :  end ) = [] ;
  end
  
  all_sig = [ all_sig   sig_i ];
   
end

whos all_sig
 Combined_file =[ 'Signals_'  num2str(channels_num)  '_channels.txt'    ]  
 
        fid = fopen(Combined_file , 'w');
%      fprintf(fid, '%.4f\t%.4f\n', all_sig');
      fprintf(fid, '%.4f\t%.4f\t%.4f\t%.4f\n', all_sig');
      fclose(fid);


  
  
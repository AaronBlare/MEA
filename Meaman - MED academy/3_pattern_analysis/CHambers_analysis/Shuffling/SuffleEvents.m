% Suffle events times of Es with Ed durations
function [ Es_rand , Ee_rand ] = SuffleEvents( Es , Ed , MinT , MaxT )
% Es = starts of the events
% Ed = durations
% MinT MaxT - interval for shuffling

if nargin == 2
    MinT = min( Es );
    MaxT = max( Es ) + max(Ed);
%         MinT = 0 ;
%     MaxT = max( Es ) + max(Ed);
else
    
end
ShuffleInterval = MaxT - MinT ;

Es_rand =[];
Ee_rand=[];

if numel( Es ) > 2 && numel( Ed ) > 2
last = Es(end) + max(Ed); 

for i = 1 : length( Es )
                 
    found_rand_place = false ;
%     i
    if ~isempty( Es_rand )
    while ~found_rand_place
       es1 =round( ( ShuffleInterval - 1 ) * rand() ) + 1 + MinT ;
       overlap = false ;
       for j = 1 : length( Es_rand )
%            j
         if i~= j
             % if new event start < other event end or new event end >
             % other event start
          if es1 < Es_rand(j)+Ed(j) && es1 > Es_rand(j)
              overlap = true; 
          end 
          if es1+Ed(i) < Es_rand(j)+Ed(j) && es1+Ed(i) > Es_rand(j)
              overlap = true; 
          end
          
         end
       end
       if ~overlap
           found_rand_place = true ;
       end       
    end
    Es_rand = [ Es_rand es1  ];
    Ee_rand = [ Ee_rand es1  + Ed(i) ];
    else
      Es_rand = round( ( last - 1 ) * rand() ) +1 ;
      Ee_rand = [ Ee_rand  Es_rand  + Ed(i) ];
    end
                    
end
 
end



% v1
% 
% % Es = starts of the events
% % Ed = durations
% % MinT MaxT - interval for shuffling
% 
% if nargin == 2
%     MinT = min( Es );
%     MaxT = max( Es ) + max(Ed);
%     
% else
%     
% end
% ShuffleInterval = MaxT - MinT ;
% 
% Es_rand =[];
% Ee_rand=[];
% 
% if numel( Es ) > 2 && numel( Ed ) > 2
% last = Es(end) + max(Ed); 
% 
% for i = 1 : length( Es )
%                  
%     found_rand_place = false ;
% %     i
%     if ~isempty( Es_rand )
%     while ~found_rand_place
%        es1 =round( ( last - 1 ) * rand() ) +1 ;
%        overlap = false ;
%        for j = 1 : length( Es_rand )
% %            j
%          if i~= j
%              % if new event start < other event end or new event end >
%              % other event start
%           if es1 < Es_rand(j)+Ed(j) && es1 > Es_rand(j)
%               overlap = true; 
%           end 
%           if es1+Ed(i) < Es_rand(j)+Ed(j) && es1+Ed(i) > Es_rand(j)
%               overlap = true; 
%           end
%           
%          end
%        end
%        if ~overlap
%            found_rand_place = true ;
%        end       
%     end
%     Es_rand = [ Es_rand es1  ];
%     Ee_rand = [ Ee_rand es1  + Ed(i) ];
%     else
%       Es_rand = round( ( last - 1 ) * rand() ) +1 ;
%       Ee_rand = [ Ee_rand  Es_rand  + Ed(i) ];
%     end
%                     
% end
%  
% end
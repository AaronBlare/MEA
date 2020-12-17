
function AWSR_bin = AWSR_to_binary( timebin , maxtime , burst_max )
% a = [100 250 300]'
% time=500
x= (0: timebin : maxtime )' ;
% numel(x)
y= (1:numel(x))';
for i=1:numel(x)  ;
     y(i) =  y(i)==0  ;
end;

for i=1:numel(x)  ;
    for k=1:numel(burst_max);
        y(i)= y(i)+[x(i) == burst_max(k)] ;
    end;
end;

AWSR_bin = y ;
% p=cat(2,x,y)
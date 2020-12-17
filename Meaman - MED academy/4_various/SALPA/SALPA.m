function [ filt_v ] = SALPA( v, n, init, duration )
%SALPA [Wagenaar et al., J Neurosci Method, 2002]
% stimulus artifact suppression with local polynominal fitting
% filt_v, filtered v
% default, n=75
% 

if 2 > nargin
    n =  43; % 75
end
if 4 > nargin
    duration = length(v) - 2*n - 2;
%     duration = length(v) -  2*n - 2;
end
if 3 > nargin
    init = n+1;
end

a = zeros(size(v));

%% calculate invS
t0 = 2*n + 1;
t2 = n*(n+1)*(2*n+1)/3;
t4 = 2*power(n,5)/5+power(n,4)+2*power(n,3)/3-n/15;
t6 = 2*power(n,7)/7+power(n,6)+power(n,5)-power(n,3)/3+n/21;
S = [[t0, 0, t2, 0]; [0, t2, 0, t4]; [t2, 0, t4, 0]; [0, t4, 0, t6]];
invS = inv(S);

%% initial value of W
W0 = 0;
W1 = 0;
W2 = 0;
for k = -n:n
    W0 = W0 + v(init+k);
    W1 = W1 + k*v(init+k);
    W2 = W2 + k^2*v(init+k);
end

%% filtration
for i = init:init+duration %init:init+duration
    a(i) = invS(1,1)*W0 + invS(1,3)*W2;
    W2 = W0 -2*W1 + W2 + n^2*v(i+n+1) -(n+1)^2*v(i-n);
    W1 = -W0 +W1 + n*v(i+n+1) + (n+1)*v(i-n);
    W0 = W0 + v(i+n+1) - v(i-n);
end

filt_v = v - a;


end


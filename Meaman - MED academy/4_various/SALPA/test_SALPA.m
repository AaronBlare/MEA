% sample program for using SALPA function
% test data (25kHz sampling) contains a stimulation artifact and some evoked spikes
% blue and red line indicate original and filtered data, respectively
% 

load('testdata')
filtered = SALPA( original );

figure
x = 0.02:0.04:length(original)/25-0.02;
plot(x, original, 'b')
hold on
plot(x, filtered, 'r')
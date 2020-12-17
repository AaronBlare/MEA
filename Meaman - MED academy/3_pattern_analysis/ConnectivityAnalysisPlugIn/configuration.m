conf.h=0.05; % time discretization step, in msec
conf.r_delay_m=100; % time for shift, for significance testing
conf.delay_m=150; % maximum connection lag, in msec
conf.d_step=conf.h; % lag step
conf.fuzz=0.5; % half of hat-function width (window of searching for spikes), in msec
conf.decreaser=0.5; % decreaser of sigma-factor for significance testing
conf.mode=[3 0]; % mode of sigma-factor calculation 
conf.dir=  'D:\Meaman\ConnectivityAnalysisPlugIn'; % path to plug-in

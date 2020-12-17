function [ SigIJ, TimeIJ ] = ConnectivityAnalysis( PimRastrFile, Number_of_electrodes, plot_on )
%ConnectivityAnalysis Meamanx module
%   Takes PimRastr and return FunctiuonalConnectivity matrices
  configuration;
  RASTR = convert2RASTRmatrix( Number_of_electrodes, PimRastrFile, conf.h  );
  Spikes = FindSpikes( RASTR );
  %{
  res = dopjob_fun(@allsigmax_Cell, @res_produce_sigma, {RASTR, Spikes, conf}, conf);
  SigIJ=res.s;
  TimeIJ=res.t;
  %}
  %%{
  res = allsigmax_Cell(RASTR, Spikes, conf);
  SigIJ=res{2};
  TimeIJ=res{1};
  %}
  clear res;  
  if plot_on
    ConDiagSaveCell( '', SigIJ );
  end
end


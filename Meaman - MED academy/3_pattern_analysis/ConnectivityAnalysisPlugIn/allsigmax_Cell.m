function output = allsigmax_Cell(n, Spikes, conf)
%%
%баллансированное распределение нагрузки по всем процессам
% каждому процессу выделяем size(RasterMatrix,2)/numlabs * (size(RasterMatrix,2)-1) пар клеток
n2p_count = floor(n/numlabs)

if(labindex~=numlabs)
  jr=labindex*n2p_count;
else
  jr=n;
end
%вычисление каждым процессом фактора совпадений для отведенного ему
%количества пар

%SigIJ=zeros(jr-(labindex-1)*n2p_count,size(RasterMatrix,2));
%TimeIJ=zeros(jr-(labindex-1)*n2p_count,size(RasterMatrix,2));
SigIJ=cell(jr-(labindex-1)*n2p_count,n);
TimeIJ=cell(jr-(labindex-1)*n2p_count,n);
%%{ 
%slow cicle
k=1;
for i=1+(labindex-1)*n2p_count:1:jr
  for j=1:1:n
%}
%{
for j=1:1:size(RasterMatrix,2)
  k=1;
  for i=1+(labindex-1)*n2p_count:1:jr
    %}
    if j==i 
      SigIJ{k,j}=0;
      TimeIJ{k,j}=0;
      continue;
    end;                 
      if conf.mode(2)==1     %sigma-   
        X=zeros(n,1); X(Spikes{j})=1;
        sigmaij=two_channels_cpp(conf.h, X, Spikes{i}, conf.r_delay_m,-conf.delay_m-conf.r_delay_m, -conf.d_step, conf.fuzz);      
      elseif conf.mode(2)==2 %sigma+
        X=zeros(n,1); X(Spikes{i})=1;
        sigmaij=two_channels_cpp(conf.h, X, Spikes{j}, -conf.r_delay_m,conf.delay_m+conf.r_delay_m, conf.d_step, conf.fuzz);  
      elseif conf.mode(2)~=3
        %sigma+-             
        X=zeros(n,1); X(Spikes{j})=1;
        sigma_ij.m = two_channels_cpp(conf.h, X, Spikes{i}, conf.r_delay_m,-conf.delay_m-conf.r_delay_m, -conf.d_step, conf.fuzz);           
        X=zeros(n,1); X(Spikes{i})=1;
        sigma_ij.p = two_channels_cpp(conf.h, X, Spikes{j}, -conf.r_delay_m,conf.delay_m+conf.r_delay_m, conf.d_step, conf.fuzz);
        sigmaij=sqrt(sigma_ij.p.*sigma_ij.m);       
        clear sigma_ij;
      end         
      %{
      ind=FindMinSignificantPeak_n( sigmaij, [0, 0], 0.01, 0.4, conf );
      if ind
        SigIJ(k,j) = sigmaij(ind);         
        TimeIJ(k,j) = (ind-1-floor(conf.r_delay_m./conf.d_step)).*conf.d_step;
      end   
      %}
      %inds=FindMinSignificantPeak_Cell( sigmaij, [0, 0], 0.01, 0.5, conf );
      inds=FindMinSignificantPeak_Cell_s( sigmaij, 0.01, conf );
      %fz=floor(conf.fuzz/conf.h);
      %inds=FindMinSignificantPeak_Cell( sigmaij, [fz, fz], 0.01, 0.5, conf );
      if ~isempty(inds)  
        SigIJ{k,j} = sigmaij(inds);         
        TimeIJ{k,j} = (inds-1-floor(conf.r_delay_m./conf.d_step)).*conf.d_step;
      else
        SigIJ{k,j} = 0;  
        TimeIJ{k,j} = 0;
      end         
  end
  k=k+1;
end
output{1}=TimeIJ;
output{2}=SigIJ;
end


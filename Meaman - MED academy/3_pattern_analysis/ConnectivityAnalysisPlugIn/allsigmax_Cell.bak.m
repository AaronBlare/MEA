function output = allsigmax_Cell(RasterMatrix, Spikes, conf)
%%
%баллансированное распределение нагрузки по всем процессам
% каждому процессу выделяем size(RasterMatrix,2)/numlabs * (size(RasterMatrix,2)-1) пар клеток
n2p_count = floor(size(RasterMatrix,2)/numlabs)

if(labindex~=numlabs)
  jr=labindex*n2p_count;
else
  jr=size(RasterMatrix,2);
end
%вычисление каждым процессом фактора совпадений для отведенного ему
%количества пар

%SigIJ=zeros(jr-(labindex-1)*n2p_count,size(RasterMatrix,2));
%TimeIJ=zeros(jr-(labindex-1)*n2p_count,size(RasterMatrix,2));
SigIJ=cell(jr-(labindex-1)*n2p_count,size(RasterMatrix,2));
TimeIJ=cell(jr-(labindex-1)*n2p_count,size(RasterMatrix,2));
%%{ 
%slow cicle
k=1;
for i=1+(labindex-1)*n2p_count:1:jr
  for j=1:1:size(RasterMatrix,2)
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
        sigmaij=two_channels_cpp(conf.h, RasterMatrix(:,j), Spikes{i}, conf.r_delay_m,-conf.delay_m-conf.r_delay_m, -conf.d_step, conf.fuzz);      
      elseif conf.mode(2)==2 %sigma+
        sigmaij=two_channels_cpp(conf.h, RasterMatrix(:,i), Spikes{j}, -conf.r_delay_m,conf.delay_m+conf.r_delay_m, conf.d_step, conf.fuzz);  
      elseif conf.mode(2)~=3
        %sigma+-                        
        sigma_ij.m = two_channels_cpp(conf.h, RasterMatrix(:,j), Spikes{i}, conf.r_delay_m,-conf.delay_m-conf.r_delay_m, -conf.d_step, conf.fuzz);           
        sigma_ij.p = two_channels_cpp(conf.h, RasterMatrix(:,i), Spikes{j}, -conf.r_delay_m,conf.delay_m+conf.r_delay_m, conf.d_step, conf.fuzz);
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


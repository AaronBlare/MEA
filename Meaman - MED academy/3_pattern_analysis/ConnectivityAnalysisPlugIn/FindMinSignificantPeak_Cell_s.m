%function [ ind ] = FindMinSignificantPeak_n( Correlator, eps, alpha, decreaser, conf )
function [ newinds ] = FindMinSignificantPeak_Cell_s( Correlator, alpha, conf )
%FindMinSignificantPeak takes Correlator(positive time delay) and return
%significant Min peak index or "0" if there is no significant values of
%Correlator
%   alpha - alpha level
%   eps - interval acros peak which is removed from data from [ind-eps(1);ind+eps(2)]
    wnd = floor(conf.r_delay_m./conf.d_step);
    [none, inds] = findpeaks(Correlator(1+wnd:floor(conf.delay_m./conf.d_step)+wnd));
    
    inds = inds + wnd;
    
    newinds=[];
    for index=1:length(inds)
      %wo=[Correlator(inds(index)-wnd:inds(index)-1-eps(1)); Correlator(inds(index)+eps(2)+1:inds(index)+wnd)];
      wo=Correlator(inds(index)-wnd:inds(index)+wnd); %!!!!!!!!!!!!!!!!!!!!
      %wo=[Correlator(1:inds(index)-1); Correlator(inds(index)+1:end)];
      p=length(find(wo>=conf.decreaser*Correlator(inds(index))))./length(wo);
      %%{
      if p<alpha
        newinds=[newinds inds(index)];
      end
    end
    %{
    if isempty(newinds)
    else  
      newinds=min(newinds);
    end    
    %}
end


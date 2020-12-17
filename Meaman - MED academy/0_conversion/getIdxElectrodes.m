%------------%--------------------------------------------------------------------------
function [idxElectrodeMea] = getIdxElectrodes(EntityInfo, labl)
%--------------------------------------------------------------------------
% extract indices in EntityInfo corresponding to the label given in labl

% extract all labels from EntityInfo
crrFlCrrLbls = {EntityInfo.EntityLabel};

% indices indicating used amplifier
allElId = cellfun(@(x) x(27), crrFlCrrLbls(:), 'UniformOutput', 0);

% mea indices
idxElectrodeMea = find(~(cellfun(@isempty, regexp(allElId, labl))));

% % extract string identifier
% allNumIdent = cellfun(@(x) x(1:4), crrFlCrrLbls, 'UniformOutput', 0);
%
% % all stream electrode identifier
% allElId = cellfun(@(x) x(25:27), crrFlCrrLbls, 'UniformOutput', 0);
%
% % indices of all stream containing an electrode name
% logicAll = ~(cellfun(@isempty, regexp(allNumIdent, '(\<elec\>)|(\<spks\>)|(\<filt\>)|(\<chtl\>)')));
%
% % indices of all stream containing label
% logicAllElId = ~(cellfun(@isempty, regexp(allElId, labl)));
%
% % non-empty indices for streams
% idxAll = find(logicAll);
%
% % non-empty indices for electrodes
% idxAllElId = find(logicAllElId);
%
% % meaA indices
% idxElectrodeMea = intersect(idxAll,idxAllElId);

end
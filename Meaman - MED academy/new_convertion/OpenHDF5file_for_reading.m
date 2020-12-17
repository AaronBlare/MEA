import McsHDF5.*

nMeas = 2;

data = McsHDF5.McsData(FILENAME);

FileInfo.EntityCount = length(data.Recording{1, 1}.AnalogStream{1, 1}.Info.ChannelID);
FileInfo.TimeSpan = double(data.Recording{1, 1}.AnalogStream{1, 1}.ChannelDataTimeStamps(end)-data.Recording{1, 1}.AnalogStream{1, 1}.ChannelDataTimeStamps(1)+data.Recording{1, 1}.AnalogStream{1, 1}.Info.Tick(1)) / double(1000000); %time in microseconds

TimeSpanSamples = length(data.Recording{1, 1}.AnalogStream{1, 1}.ChannelDataTimeStamps);

FileInfo.TimeStampResolution = double(FileInfo.TimeSpan) / double(TimeSpanSamples);

handles.par.sr=1/FileInfo.TimeStampResolution;

if nMeas == 2
    [idxElecMeaA]=find(ismember(data.Recording{1, 1}.AnalogStream{1, 1}.Info.ElectrodeGroup,0));
    [idxElecMeaB]=find(ismember(data.Recording{1, 1}.AnalogStream{1, 1}.Info.ElectrodeGroup,1));
    
    for i = 1:length(data.Recording{1, 1}.AnalogStream{1, 1}.Info.ElectrodeGroup)
        intlEntityInfoLABELS(i).EntityLabel = data.Recording{1, 1}.AnalogStream{1, 1}.Info.ElectrodeGroup(i);
        intlEntityInfoLABELS(i).EntityType = data.Recording{1, 1}.AnalogStream{1, 1}.Info.ChannelID(i);
        intlEntityInfoLABELS(i).ItemCount = double(TimeSpanSamples);
    end
    
    if isempty(idxElecMeaB) && isempty(idxElecMeaA)
        idxElecMeaA = 1:length(intlEntityInfoLABELS);
    end
end

fldScMap = {'elec', 'anlg', 'filt', 'chtl','digi', 'spks', 'trig'}';
fldMCDMap = {'_Mat_files', '_Ana_files','_Filt_files', '_Chtl_files', '_Digi_files', '_Spks_files', '_Trig_files'}';
mcdDttp = {'chtl', 'digi', 'spks', 'trig'}';
anChsn = {};

V_to_uV = 1000;
rawDataConversionFlag = true;
anaConversionFlag = false;

filtConversionFlag = true;

if rawDataConversionFlag
    anChsn = [anChsn; 'elec'];
end

if anaConversionFlag
    anChsn = [anChsn; 'anlg'];
end

if filtConversionFlag
    anChsn = [anChsn; 'filt'];
end

usChtmp = [anChsn; mcdDttp];
idxem = cellfun(@isempty, usChtmp);
usCh = usChtmp(~idxem);

if data.Recording{1, 1}.AnalogStream{1, 1}.DataSubType == 'Electrode'
    EntityInfo = intlEntityInfoLABELS;
    for i = 1:length(data.Recording{1, 1}.AnalogStream{1, 1}.Info.ElectrodeGroup)
        EntityInfo(i).EntityType = 2;
    end
end

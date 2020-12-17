% OpenMCDfile_for_reanding

% FILENAME - specify before call this function

nMeas =2 ;

winbit =  computer('arch') ;
if strcmp( winbit , 'win64' )
    dll_file = ffpath('nsMCDLibrary64s.dll');
    dll_file=[dll_file '\nsMCDLibrary64s.dll'];
else
   dll_file = ffpath('nsMCDLibrary.dll');
   dll_file=[dll_file '\nsMCDLibrary.dll']; 
end
[ns_RESULT] = ns_SetLibrary( dll_file );

[nsresult, hfile] = ns_OpenFile( FILENAME );

% get .mcd file's info
[nsresult, FileInfo] = ns_GetFileInfo(hfile);
FileInfo
% get exp duration expressed in number of samples
TimeSpanSamples = ConvertTimeStamps(FileInfo.TimeSpan, FileInfo.TimeStampResolution);

handles.par.sr =  1  / FileInfo.TimeStampResolution ; 
 
% get info on all the Entities contained in the file
[nsresult, intlEntityInfo] = ns_GetEntityInfo(hfile, 1 : FileInfo.EntityCount);
intlEntityInfo;
% % % % % % % % % % % % % % % % % % % % % % %
% SEPARATE Electrode Name FOR MEA_A AND MEA_B
% % % % % % % % % % % % % % % % % % % % % % %

% if data from 2 amplifier were recorded change the index (done for
% compatibility with the old 120 channel where also channels from amplifier
% B are named as elec0001)
if nMeas == 2
    % find indices of different digital stream
    [idxElecMeaA] = getIdxElectrodes(intlEntityInfo, 'A');
    [idxElecMeaB] = getIdxElectrodes(intlEntityInfo, 'B');
    intlEntityInfoLABELS = intlEntityInfo ;
    
    if isempty( idxElecMeaB ) && isempty( idxElecMeaA )
       idxElecMeaA = 1 : length(  intlEntityInfo ) ;
    end
    
    if ~isempty(idxElecMeaA)
        for i = 1: length(idxElecMeaA)
            intlEntityInfo(idxElecMeaA(i)).EntityLabel(8) = '1';
            intlEntityInfoLABELS(idxElecMeaA(i)).EntityLabel =  'A';
        end
    end
    
    if ~isempty(idxElecMeaB)
        for i = 1: length(idxElecMeaB)
            intlEntityInfo(idxElecMeaB(i)).EntityLabel(8) = '2';
            intlEntityInfoLABELS(idxElecMeaB(i)).EntityLabel =  'B';
        end
    end
    
    % if data from a single amplifier were recorded
else
    for i = 1 : length(intlEntityInfo)
        intlEntityInfo(i).EntityLabel(8) = '1';
    end
end



% % % % % % % EXTRACT CHANNEL NUMBERS % % % % % % % % % % % % % % %
for i = 1 : length(intlEntityInfo)
    Chnum_str = [ intlEntityInfo(i).EntityLabel(17) intlEntityInfo(i).EntityLabel(18) ];
           Channel_number = str2num( Chnum_str ); 
           intlEntityInfoLABELS(i).EntityType = Channel_number ;
           
%            elec_mcs_label  = intlEntityInfo(i).EntityLabel( end - 3 : end-1) ;
%            
%            intlEntityInfoLABELS(i).label2d = elec_mcs_label ;
          
end
 % filt0002 0078 0001      15B
% % % % % % % % % % % % % % % % % % % % % %


% % % % % % % % % % % % % % % % % % % % % %

% file content to output folder name mapping
fldScMap = {'elec', 'anlg', 'filt', 'chtl','digi', 'spks', 'trig'}';
%   fldScMap = { 'filt' }';
fldMCDMap = {'_Mat_files', '_Ana_files','_Filt_files', '_Chtl_files', '_Digi_files', '_Spks_files', '_Trig_files'}';

% all .mcd data type to be compulsorily converted
mcdDttp = {'chtl', 'digi', 'spks', 'trig'}';
% mcdDttp = {  'filt' }';

% digital bits assigned to MeaA and MeaB
% meaA_bit = {'00'};
% meaB_bit = {'01'};

% analysis the user chose to do
anChsn = {};
% conversion to be performed based on user's choice and recorded data


% Volt to microVolt conversion factor
V_to_uV = 1000;
rawDataConversionFlag=true ;
anaConversionFlag=false;

% % % % % % % % % % % % % % % % % % % % % % %
filtConversionFlag=true;
% % % % % % % % % % % % % % % % % % % % % % %

        % if raw data must be converted
        if rawDataConversionFlag
            anChsn = [anChsn; 'elec'];
        end
        
        % if analog signals must be converted
        if anaConversionFlag
            anChsn = [anChsn; 'anlg'];
        end
        
        % if filtered data must be converted
        if filtConversionFlag
            anChsn = [anChsn; 'filt'];
        end
%         anChsn = [anChsn; 'elec'];


% conversion to be performed based on user's choice and recorded data
usChtmp = [anChsn; mcdDttp];
idxem = cellfun(@isempty, usChtmp);
usCh = usChtmp(~idxem);
% usCh

% % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % Manipulate labels and indices
% % % % % % % % % % % % % % % % % % % % % % %

% get all entity full name identifiers (first 8 characters of the labels)
crrFlCrrLbls = {intlEntityInfo.EntityLabel};
allFullId = cellfun(@(x) x(1:8),crrFlCrrLbls, 'UniformOutput', 0);

% get all entity short name identifiers
allSnId = cellfun(@(y) y(1:4), allFullId, 'UniformOutput', 0);

% get all entity numeric identifiers
% allNumId = cellfun(@(y) y(5:8), allFullId, 'UniformOutput', 0);

% final indices of data to be taken
idxFnl2tk = ismember(allSnId, usCh);

% final data to convert
EntityInfo = intlEntityInfo(idxFnl2tk);

% final unique full indices of entities to convert
[fnlUnFllId] = unique(allFullId(idxFnl2tk), 'last');

% final unique short name identifiers of entities to convert
fnlSnId = cellfun(@(y) y(1:4), fnlUnFllId, 'UniformOutput', 0);

% final unique numeric identifiers of entities to convert
fnlNumId = cellfun(@(y) y(5:8), fnlUnFllId, 'UniformOutput', 0);
 
TimeSpanSamples
% EntityInfo
% length(EntityInfo)
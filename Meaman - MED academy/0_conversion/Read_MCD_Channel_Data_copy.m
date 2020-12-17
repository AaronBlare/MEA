% Read_MCD_Channel_Data 
% CHANNEL_NUM
% CHANNEL_MEA_LETTER = 'A';
% output - crrData2Save vactor

CHANNEL_NUM = CHANNEL_NUM - 1 ;
channels = [];
Spec_channel_one = 0 ; 
if ~use_6well_mea
    for chan = 1 : length(intlEntityInfoLABELS) 
          if intlEntityInfoLABELS(chan).EntityType == CHANNEL_NUM && intlEntityInfoLABELS(chan).EntityLabel == CHANNEL_MEA_LETTER ...
                  && EntityInfo(chan).EntityType == 2   
              Spec_channel_one = chan;
          end
    end 
else
    for chan = 1 : length(intlEntityInfoLABELS) 
        Chan_label = str2num( EntityInfo(chan).EntityLabel( 12 : 13 ) );
          if Chan_label == CHANNEL_NUM && ...
                  intlEntityInfoLABELS(chan).EntityLabel == CHANNEL_MEA_LETTER ...
                  && EntityInfo(chan).EntityType == 2   
              Spec_channel_one = chan;
          end
    end 
end
% Spec_channel_one = 163;

if Spec_channel_one > 0
chan=Spec_channel_one;

Reading_MEA_channel = Spec_channel_one ;
Reading_MEA_channel

    % initialise array for containing current stream data
    crrData2Save = zeros(TimeSpanSamples, 1);
    
    EntityInfo(chan).ItemCount;
    % continue if current entity does not contain data 
    if EntityInfo(chan).ItemCount==0
        continue        
    end
    
    
        % bar indicating proceeding conversion
%     waitbarImproved(chan/(length(EntityInfo)), ['converting stream ' num2str(chan) ' of '   num2str(length(EntityInfo))]);
    EntityInfo(chan) ;
EntityTypeCHAN = EntityInfo(chan).EntityType ;
% EntityTypeCHAN

if EntityInfo(chan).EntityType == 2 
 switch EntityInfo(chan).EntityType
        case 1
            %--------------------------------------------------------------
            % Event channel
            %--------------------------------------------------------------
            
            % extract Event stream info
            [nsresult, EventInfo] = ns_GetEventInfo(hfile,chan);
            
            % continue if problems in opening
            if nsresult < 0
                continue
            end
            
            % extract all data for current Entity
            [nsresult, timestamps, data, datasize] =...
                ns_GetEventData(hfile, chan, 1 : EntityInfo(chan).ItemCount);  
            
            % if error in opening or no event is present continue
            if nsresult < 0 || isempty(timestamps)
                continue
            end
            
            % convert timestamps into sample number
            timestampssamples = ConvertTimeStamps(timestamps, FileInfo.TimeStampResolution) + 1;
            
            % switch between different data type
            switch EntityInfo(chan).EntityLabel(1:4)
                
                % in case current stream is digital
                case 'digi'
                    % if the number of timesamples is odd delete the last
                    if ~rem(length(timestampssamples), 2)
                        timestampssamples = timestampssamples(1 : end -1);
                    end
                    
                    % for every couple of samples update data array to save
                    for w = 1 : 2 : length(timestampssamples) - 1
                        crrData2Save(timestampssamples(w) : timestampssamples(w + 1)) = 1;
                    end
                    
                    % in case current stream is the trigger
                case 'trig'
                    % fill final data with trigger positions
                    crrData2Save(timestampssamples) = 1;
            end
            
            % extract channel's label
            ch = extractChannel(EntityInfo(chan).EntityLabel, EntityInfo(chan).EntityLabel(1:4));
            
            % save data
            writeDataToFile(crrData2Save, expNames, fnlUnFllId, crtdFld, EntityInfo(chan).EntityLabel(1:8), ch);
            
        case 2
            %--------------------------------------------------------------
            % Continuous Waveform Channel - Analog Entity
            %--------------------------------------------------------------
            
            % if data are triggered take only Segment Entity - do not save
            % 'digi' stream
            triggedData=false;
            if triggedData || ismember(EntityInfo(chan).EntityLabel(1:4), {'digi'})
                continue
            end
            
            % extract information on analog channel
            [nsresult, AnalogInfo] = ns_GetAnalogInfo(hfile,chan);
            
%             AnalogInfo

            % continue if error in opening
            if nsresult < 0
                continue
            end
            
            % set size of data blocks to be used for conversion
            blocksize = 1e6 ; % 1e6 original 
            
            % extract number of blocks
            nblocks = floor(EntityInfo(chan).ItemCount/blocksize);
%             nblocks=1;
            % extract remainder
            tail = rem(EntityInfo(chan).ItemCount, blocksize);
            
            % read the data for every block
            for k = 1 : nblocks
                [nsresult, ContCount, data] = ns_GetAnalogData(hfile, chan,...
                    (k-1)*blocksize + 1, blocksize);
                
                % update data to be saved with current block
                crrData2Save((k-1)*blocksize + 1 : (k-1) * blocksize + ContCount) = data;
            end
            
%             LastDot = (k-1)*blocksize + 1 + blocksize 
%             TailBlock = max(0,(nblocks-0)) * blocksize+1 
%             TailBlock_end = TailBlock + tail
            
            % read data remainder with respect to block size
            if tail > 0
%                 [nsresult, ContCount, data] = ns_GetAnalogData(hfile, chan,...
%                     max(0,(nblocks-1)) * blocksize+1, tail);
                [nsresult, ContCount, data] = ns_GetAnalogData(hfile, chan,...
                    max(0,(nblocks-0)) * blocksize+1, tail);
                crrData2Save((nblocks)*blocksize + 1 : (nblocks) * blocksize + tail) = ...
                    data;
            end
            
            % normalise if requested
            setOffsetToZeroFlag=true;
            if setOffsetToZeroFlag && ismember(EntityInfo(chan).EntityLabel(1:4), {'elec', 'filt'})
                crrData2Save = crrData2Save - mean(crrData2Save);
            end
            
            % check for filtering flag

            if ismember(EntityInfo(chan).EntityLabel(1:4), {'elec'})
                crrAmplIdx = str2num(EntityInfo(chan).EntityLabel(5:8));
%                 crrData2Save = filtDataUser(crrData2Save, performFiltering{1}(crrAmplIdx), cutOffFrequencies{1}(crrAmplIdx), AnalogInfo.SampleRate);
            end
            
            % conversion to microVolt
            crrData2Save = crrData2Save * V_to_uV;
%             figure 
%             plot(crrData2Save)
            % convert to mV if analog data
            if ismember(EntityInfo(chan).EntityLabel(1:4), {'anlg'})
                crrData2Save = crrData2Save/1000;
            end
            
            % conversion to int16
%             crrData2Save = int16(crrData2Save);
            
            % extract channel name
            EntityInfo(chan).EntityLabel;
            intlEntityInfoLABELS(chan).EntityType;
            intlEntityInfoLABELS(chan).EntityLabel;
            
%             ch = extractChannel(EntityInfo(chan).EntityLabel, EntityInfo(chan).EntityLabel(1:4));
             
%             crrData2Save
            % write data to file
%             writeDataToFile(crrData2Save, expNames, fnlUnFllId, crtdFld, EntityInfo(chan).EntityLabel(1:8), ch);
            
        case 3
            %--------------------------------------------------------------
            % Segment Data
            %--------------------------------------------------------------
            
            
            
            if ismember(EntityInfo(chan).EntityLabel(1:4), {'digi'})
                continue
            end
            EntityInfo(chan).EntityLabel
            % get segment info
            [nsresult, SegmentInfo] = ns_GetSegmentInfo(hfile, chan);
             
            
            % variable for saving data
            crrData2Save = zeros(1, TimeSpanSamples);
            
            % segment source info
            [nsresult, SegmentSourceInfo] = ns_GetSegmentSourceInfo(hfile, chan, 1);
            
            % read all items
            [nsresult, timestamps, temp, samplecount, UnitID] = ...
                ns_GetSegmentData(hfile, chan, 1 : EntityInfo(chan).ItemCount) ;
             ItemCount = EntityInfo(chan).ItemCount ;
             ItemCount
            whos timestamps
            whos temp
            whos samplecount
            figure
            plot( timestamps )
            figure
            plot( temp )
            figure
            plot( samplecount )
             
            % linearize all data extracted (done to handle different segment sample number)
            tempLin = temp(:);
            
            % convert timestamps in number of samples
            timestampsSmpl = ConvertTimeStamps(timestamps, FileInfo.TimeStampResolution) + 1;
            
            % switch between different entities
      
            switch EntityInfo(chan).EntityLabel(1:4)
                % in case of spikes data save only timestamps
                case 'spks'
                    crrLastIdx = find(timestampsSmpl <= length(crrData2Save), 1, 'last');
                    crrData2Save(timestampsSmpl(1 : crrLastIdx)) = 1;
                    whos timestampsSmpl
                    % in case of analog data save the entire chunk
                case {'elec', 'anlg', 'filt', 'chtl'}
                    % initial index for retrieving data
                    strIdx = 1;
                    
                    % for every segment
                    for k = 1 : size(samplecount)
                        
                        % extract current segment from starting index and number or samples
                        crrData = tempLin(strIdx : strIdx + samplecount(k) -1);
                        
                        % update starting index for next segment
                        strIdx = strIdx + samplecount(k);
                        
                        % starting time of current segment
                        crrTimeSmpl = timestampsSmpl(k);
                        
                        % last index to be used for saving data
                        crrLastIdx =  min( crrTimeSmpl + length(crrData) - 1, length(crrData2Save));
                        
                        % update data to save with current segment values
                        crrData2Save(crrTimeSmpl :  crrLastIdx) = crrData(1 : crrLastIdx - crrTimeSmpl + 1);
                        
                    end
                    % conversion to microVolt
                    crrData2Save = crrData2Save * V_to_uV;
                    
                otherwise
            end
            whos crrData2Save
%             figure
%             plot( crrData2Save )
            % normalise if requested
            setOffsetToZeroFlag= true ;
            if setOffsetToZeroFlag && ismember(EntityInfo(chan).EntityLabel(1:4), {'elec', 'filt'})
                % subtract mean
                crrData2Save = crrData2Save - mean(crrData2Save);
                
                % check for filtering flag
                if ismember(EntityInfo(chan).EntityLabel(1:4), {'elec'})
                    crrAmplIdx = str2num(EntityInfo(chan).EntityLabel(5:8));
                    crrData2Save = filtDataUser(crrData2Save, performFiltering{1}(crrAmplIdx), cutOffFrequencies{1}(crrAmplIdx), SegmentInfo.SampleRate);
                end
            end
            
            % convert to mV if analog data
            if ismember(EntityInfo(chan).EntityLabel(1:4), {'anlg'})
                crrData2Save = crrData2Save/1000;
            end
            
            % conversion to int16
            % crrData2Save = int16(crrData2Save);
            
            % extract channel name
%             ch = extractChannel(EntityInfo(chan).EntityLabel, EntityInfo(chan).EntityLabel(1:4));
            
            % write data to file
            whos crrData2Save
            whos expNames
            whos fnlUnFllId
            whos crtdFld
            whos EntityInfo(chan).EntityLabel
%             writeDataToFile(crrData2Save, expNames, fnlUnFllId, crtdFld, EntityInfo(chan).EntityLabel(1:8), ch);
        otherwise
%             continue
 end
end


end % Spec_channel_one
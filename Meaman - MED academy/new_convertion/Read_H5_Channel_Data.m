CHANNEL_NUM = CHANNEL_NUM - 1;
channels = [];
Spec_channel_one = 0;
if ~use_6well_mea
    for chan = 1 : length(intlEntityInfoLABELS)
        if intlEntityInfoLABELS(chan).EntityType == CHANNEL_NUM && EntityInfo(chan).EntityType == 2
            Spec_channel_one = chan;
        end
    end
end

if Spec_channel_one > 0
    chan=Spec_channel_one;
    
    Reading_MEA_channel = Spec_channel_one;
    Reading_MEA_channel
    % initialise array for containing current stream data
    x = zeros(1,TimeSpanSamples);
    EntityTypeCHAN = EntityInfo(chan).EntityType;
    if EntityInfo(chan).EntityType == 2
        triggedData=false;
        % set size of data blocks to be used for conversion
        blocksize = 1e6; % 1e6 original
        % extract number of blocks
        nblocks = floor(EntityInfo(chan).ItemCount/blocksize);
        tail = rem(EntityInfo(chan).ItemCount, blocksize);
        for k = 1 : nblocks
            curr_data = data.Recording{1, 1}.AnalogStream{1, 1}.ChannelData(chan, (k-1)*blocksize+1:k*blocksize);
            % update data to be saved with current block
            x((k-1)*blocksize + 1 : k * blocksize) = curr_data;
        end
        if tail > 0
            curr_data = data.Recording{1, 1}.AnalogStream{1, 1}.ChannelData(chan, nblocks*blocksize+1:end);
            % update data to be saved with current block
            x(nblocks*blocksize + 1 : end) = curr_data;
        end
        for k = 1 : length(x)
            x(k) = x(k) * 10.^(-12); % conversion between V and pV
        end
        % normalise if requested
        setOffsetToZeroFlag=true;
        if setOffsetToZeroFlag
            x = x - mean(x);
        end
        crrAmplIdx = EntityInfo(chan).EntityLabel;
        x = x * V_to_uV;
    end
end
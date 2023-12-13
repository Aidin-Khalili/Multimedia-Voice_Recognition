% functions

function theFeactures = featuresExtract(theSignal,theSampleRate)

% signal framing

numberOfSamplePerFrame=floor(theSampleRate*0.03);

[enframedData,fractionalTime_enframe]=v_enframe(theSignal,hamming(numberOfSamplePerFrame,'periodic'));

% calculate zero crossing rate

zeroCrossingRate=zeros(size(enframedData,1),1);

for index = 1:size(enframedData,1)
    % STCR -> sample that crossed zero
    [STCR, slope] = v_zerocros(enframedData(index,:));
    zeroCrossingRatePerFrame = length(STCR)/numberOfSamplePerFrame;
    zeroCrossingRate(index,1)=zeroCrossingRatePerFrame;
end

% calculate MFCC

melCepstrum=zeros(size(enframedData,1),39);
for index = 1:size(enframedData,1)
    [melCepstrumPerFrame,fractionalTime_melcepst]=v_melcepst(enframedData(index,:), theSampleRate, '0dD');
    melCepstrum(index,:)=melCepstrumPerFrame;
end

% feactures

theFeactures=[melCepstrum,zeroCrossingRate];

end
    
function [output] = different_speech(sample1,sample2)

[signal_0,sampleRate_0]=audioread(sample1);
[signal_1,sampleRate_1]=audioread(sample2);


features_0 = featuresExtract(signal_0, sampleRate_0);
features_1 = featuresExtract(signal_1, sampleRate_1);

features_0 = features_0';
features_1 = features_1';

output= dtw(features_0,features_1);

%%%%%%%%%%%%%% function

function theFeactures = featuresExtract(theSignal,theSampleRate)

numberOfSamplePerFrame=floor(theSampleRate*0.03);

[enframedData,~]=v_enframe(theSignal,hamming(numberOfSamplePerFrame,'periodic'));

zeroCrossingRate=zeros(size(enframedData,1),1);

for index = 1:size(enframedData,1)
    % STCR -> sample that crossed zero
    [STCR, ~] = v_zerocros(enframedData(index,:));
    zeroCrossingRatePerFrame = length(STCR)/numberOfSamplePerFrame;
    zeroCrossingRate(index,1)=zeroCrossingRatePerFrame;
end


melCepstrum=zeros(size(enframedData,1),39);
for index = 1:size(enframedData,1)
    [melCepstrumPerFrame,~]=v_melcepst(enframedData(index,:), theSampleRate, '0dD');
    melCepstrum(index,:)=melCepstrumPerFrame;
end

theFeactures=[melCepstrum,zeroCrossingRate];

end

end
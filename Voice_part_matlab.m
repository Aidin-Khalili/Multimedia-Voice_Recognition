close all
clc
%file_name = input('Please enter c: ', 's');
%!dir *.voc > x.x
[signal_0,sampleRate_0]=audioread('007.wav');
[signal_1,sampleRate_1]=audioread('009.wav');
[signal_0,sampleRate_0]=detectVoiced('007.wav');
[signal_1,sampleRate_1]=detectVoiced('009.wav');
%[signal_2,sampleRate_2]=audioread('C:\Users\pcsarv\Music\Recordpad\my_voice 000.wav');
%x=dos('dir *.voc')
%dos('dir *.wav > aidin.txt')
%x=0:1:size(signal_1)-1;
%plot(x,signal_1);
features_0 = featuresExtract(signal_0, sampleRate_0);
features_0 = features_0';
features_1 = featuresExtract(signal_1, sampleRate_1);
features_1 = features_1';
distance= dtw(features_0,features_1);
if distance > 170
    disp('Rejected!');
else
    disp('Accepted');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function theFeactures = featuresExtract(theSignal,theSampleRate)
numberOfSamplePerFrame=floor(theSampleRate*0.03);
[enframedData,~]=v_enframe(theSignal,hamming(numberOfSamplePerFrame,'periodic'));
zeroCrossingRate=zeros(size(enframedData,1),1);
for index = 1:size(enframedData,1)
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


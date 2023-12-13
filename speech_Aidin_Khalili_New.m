close all
clc
% Load the audio files
[signal_0, sampleRate_0] = audioread('007.wav');
[signal_1, sampleRate_1] = audioread('009.wav');

% Delete silence from the signals
signal_0 = deleteSilence(signal_0, sampleRate_0);
signal_1 = deleteSilence(signal_1, sampleRate_1);

% Extract features from the signals
features_0 = featuresExtract(signal_0, sampleRate_0);
features_0 = features_0';
features_1 = featuresExtract(signal_1, sampleRate_1);
features_1 = features_1';

% Calculate the distance between the features using Dynamic Time Warping (DTW)
distance = dtw(features_0, features_1);

% Verify the identity
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

function theSignal = deleteSilence(theSignal, ~)
% Determine the minimum signal amplitude
minAmp = min(abs(theSignal));
% Find the indexes of non-silent parts of the signal
nonSilentIndexes = find(abs(theSignal) > 0.05*minAmp);
% Remove the silence from the signal
theSignal = theSignal(min(nonSilentIndexes):max(nonSilentIndexes));
end
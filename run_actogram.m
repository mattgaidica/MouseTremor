% % videoFile = '/Users/mattgaidica/Dropbox/Projects/Dauer Lab/20160701/videos/converted/00003-818-F63.mp4';
% % LOGGER = csvread('/Users/mattgaidica/Dropbox/Projects/Dauer Lab/20160701/LOGGER03.CSV');
% % dataFrameStart = 63;
% % 
% % frameData = videoActogram(videoFile,5);
% % 
% % holdTime = 2; %s
% % frameRate = 30; %/s
% % holdFrames = holdTime * frameRate;
% % dataTimeStart = dataFrameStart / frameRate;
% % 
% % actogramData = smooth(frameData(:,3) / mean(frameData(:,3)));
% % a = actogramData < 0.5;

compiledIdx = [];
noMoveTimes = [];
startIdx = [];
for ii=1:length(a)
    if a(ii) == 1 && ii < length(a)
        if isempty(startIdx)
            startIdx = ii;
        end
    else
        if ~isempty(startIdx)
            % exclude noMove if logger isn't activated yet
            if frameData(ii,1) - frameData(startIdx,1) >= holdFrames && frameData(startIdx,2) - dataTimeStart > 0
                compiledIdx = [compiledIdx; frameData(startIdx,1) frameData(ii,1)];
                noMoveTimes = [noMoveTimes; (frameData(startIdx,2) - dataTimeStart) (frameData(ii,2) - dataTimeStart)];
            end
            startIdx = [];
        end
    end  
end

figure;
hold on;
plot(frameData(:,1),actogramData);
plot(compiledIdx(:,1),zeros(length(compiledIdx(:,1))),'o');
plot(compiledIdx(:,2),zeros(length(compiledIdx(:,2))),'x');

% find greatest period of noMove
[~,noMoveIdx] = max(noMoveTimes(:,2) - noMoveTimes(:,1));
tLogger = (LOGGER(:,1) - LOGGER(1,1)) / 1000;
[~,fftStartIdx] = min(abs(tLogger-noMoveTimes(noMoveIdx,1)));
[~,fftEndIdx] = min(abs(tLogger-noMoveTimes(noMoveIdx,2)));
piezoData = LOGGER(fftStartIdx:fftEndIdx,2);
disp(['Time sampled: ',num2str(tLogger(fftEndIdx)-tLogger(fftStartIdx))]);

Fs = 1 / (mean(diff(LOGGER(:,1))) / 1000);
params.Fs = Fs;
params.fpass = [1 20];
params.tapers = [3 5];
params.err = [1 0.05];

colors = get(gca,'ColorOrder');
close;
alpha = 0.25;

figure;
hold on;
[SKO,fKO,SerrKO] = mtspectrumc(piezoData,params);
plot(fKO,smooth(10*log10(SKO),100),'color',colors(1,:),'linewidth',3);
plot(fKO,smooth(10*log10(SerrKO(1,:)),100),'color',[colors(1,:) alpha],'linestyle','--');
plot(fKO,smooth(10*log10(SerrKO(2,:)),100),'color',[colors(1,:) alpha],'linestyle','--');
xlabel('Frequency (Hz)');
xlim(params.fpass);
ylim([15 35]);
ylabel('Power (10*log10(X))');
title('Power Spectrum');

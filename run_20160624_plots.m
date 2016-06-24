disp('Select KO file...');
[f,p] = uigetfile('/Users/mattgaidica/Dropbox/Projects/Dauer Lab/20160624/*.csv');
LOGGERKO = csvread(fullfile(p,f));
LOGGERKO(:,2) = LOGGERKO(:,2) - mean(LOGGERKO(:,2));
ko_mouseID = input('KO Mouse ID: ','s');

disp('Select CT file...');
[f,p] = uigetfile('/Users/mattgaidica/Dropbox/Projects/Dauer Lab/20160624/*.csv');
LOGGERCT = csvread(fullfile(p,f));
LOGGERCT(:,2) = LOGGERCT(:,2) - mean(LOGGERCT(:,2));
ct_mouseID = input('CT Mouse ID: ','s');

colors = get(gca,'ColorOrder');
close;
alpha = 0.25;

Fs = 1 / (mean(diff(LOGGERKO(:,1))) / 1000);
params.Fs = Fs;
params.fpass = [1 20];
params.tapers = [3 5];

figure('position',[0 0 500 800]);

% plot 1
subplot(311);hold on;
[SKO,fKO,SerrKO]=mtspectrumc(LOGGERKO(:,2),params);
[SCT,fCT,SerrCT]=mtspectrumc(LOGGERCT(:,2),params);

plot(fKO,smooth(10*log10(SKO),100),'color',colors(1,:),'linewidth',3);
plot(fCT,smooth(10*log10(SCT),100),'color',colors(2,:),'linewidth',3);

plot(fKO,smooth(10*log10(SerrKO(1,:)),100),'color',[colors(1,:) alpha],'linestyle','--');
plot(fKO,smooth(10*log10(SerrKO(2,:)),100),'color',[colors(1,:) alpha],'linestyle','--');

plot(fCT,smooth(10*log10(SerrCT(1,:)),100),'color',[colors(2,:) alpha],'linestyle','--');
plot(fCT,smooth(10*log10(SerrCT(2,:)),100),'color',[colors(2,:) alpha],'linestyle','--');

xlabel('Frequency (Hz)');
xlim(params.fpass);
ylabel('Power (10*log10(X))');
legend(ko_mouseID,ct_mouseID);
title([ko_mouseID,' vs. ',ct_mouseID,' Power Spectrum']);

% plot 2,3
startPlot = 1e5;
plotSamples = round(Fs * 5);
t = linspace(0,(plotSamples/Fs)*1000,plotSamples);

subplot(312);
plot(t,LOGGER6410(startPlot:startPlot+plotSamples-1,2),'color',colors(1,:));
xlabel('Time (ms)');
ylabel('Amplitude (mV)');
ylim([-50 50]);
title([ko_mouseID,' Raw Piezo Waveform (5s)']);

subplot(313);
plot(t,LOGGER817(startPlot:startPlot+plotSamples-1,2),'color',colors(2,:));
xlabel('Time (ms)');
ylabel('Amplitude (mV)');
ylim([-50 50]);
title([ct_mouseID,' Raw Piezo Waveform (5s)']);

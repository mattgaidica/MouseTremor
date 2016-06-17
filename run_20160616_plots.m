% params = 
%         Fs: 81.5284
%     tapers: [3 5]
%      fpass: [0 20]
colors = get(gca,'ColorOrder');
close;
alpha = 0.25;

figure('position',[0 0 500 800]);

% plot 1
subplot(311);hold on;
[S00,f00,Serr00]=mtspectrumc(LOGGER00(:,2),params);
[S03,f03,Serr03]=mtspectrumc(LOGGER03(:,2),params);

plot(f00,smooth(10*log10(S00),100),'color',colors(1,:),'linewidth',3);
plot(f03,smooth(10*log10(S03),100),'color',colors(2,:),'linewidth',3);

plot(f00,smooth(10*log10(Serr00(1,:)),100),'color',[colors(1,:) alpha],'linestyle','--');
plot(f00,smooth(10*log10(Serr00(2,:)),100),'color',[colors(1,:) alpha],'linestyle','--');

plot(f03,smooth(10*log10(Serr03(1,:)),100),'color',[colors(2,:) alpha],'linestyle','--');
plot(f03,smooth(10*log10(Serr03(2,:)),100),'color',[colors(2,:) alpha],'linestyle','--');

xlabel('Frequency (Hz)');
ylabel('Power (10*log10(X))');
legend('KO','WT');
title('KO vs. WT Power Spectrum (90 seconds)');

% plot 2,3
start00 = 4100;
start03 = 11326;
plotSamples = round(Fs * 5);
t = linspace(0,(plotSamples/Fs)*1000,plotSamples);

subplot(312);
plot(t,LOGGER00(start00:start00+plotSamples-1,2),'color',colors(1,:));
xlabel('Time (ms)');
ylabel('Amplitude (mV)');
ylim([-50 50]);
title('KO Raw Piezo Waveform (5s, random)');

subplot(313);
plot(t,LOGGER03(start03:start03+plotSamples-1,2),'color',colors(2,:));
xlabel('Time (ms)');
ylabel('Amplitude (mV)');
ylim([-50 50]);
title('WT Raw Piezo Waveform (5s, random)');

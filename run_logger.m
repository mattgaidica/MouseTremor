data = logger(:,2);
data = data - mean(data);
Fs = 1 / (mean(diff(logger(:,1))) / 1000);
[W,freqList] = calculateComplexScalograms_EnMasse(logger(:,2),'Fs',83.33,'fpass',[1 30],'doplot',false);

figure;
subplot(2,1,1);
t = (logger(:,1)-logger(1,1)) / 1000;
plot(t,data);
xlim([0 max(t)]);
xlabel('Time (s)');
ylabel('ADC Value');

subplot(2,1,2);
imagesc(t, freqList, squeeze(mean(abs(W).^2, 2))'); 
ylabel('Frequency (Hz)');
xlabel('Time (s)');
set(gca, 'YDir', 'normal');
colormap(jet);
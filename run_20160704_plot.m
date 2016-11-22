basePath = '/Users/mattgaidica/Dropbox/Projects/Dauer Lab/20160701';

frameRate = 30; % per second
sampleTime = 5; % seconds

params.fpass = [1 30];
params.tapers = [3 5];
params.err = [1 0.05];

colors = get(gca,'ColorOrder');
close;
alpha = 0.25;
Sko = [];
Sct = [];
SerrkoLower = [];
SerrkoUpper = [];
SerrctLower = [];
SerrctUpper = [];
allFs = [];
% % allGinput = {};
for ii=1:length(sessionPaths)
    load(fullfile(basePath,'matFiles',[sessionPaths{ii,1},'_frameData']));
    
    if false
        xs = allGinput{ii,2};
    else
        h = figure('position',[0 0 800 400]);
        plot(frameData(:,2),frameData(:,3));
        [xs,~] = ginput(1);
        allGinput{ii,1} = sessionPaths{ii,1};
        allGinput{ii,2} = xs;
        close(h);
    end
    
    LOGGER = csvread(fullfile(basePath,sessionPaths{ii,3}));
    LOGGER(:,1) = (LOGGER(:,1) - LOGGER(1,1)) / 1000;
    Fs = 1 / mean(diff(LOGGER(:,1)));
    allFs = [allFs Fs];
    LOGGER(:,2) = LOGGER(:,2) - mean(LOGGER(:,2));
    
    % set this once so all lengths are the same
    if ii == 1
        addSamples = round(Fs) * sampleTime;
        params.Fs = Fs;
        smoothAmt = round(addSamples / 500);
    end
    
    xs = xs - sessionPaths{ii,4} / frameRate; % adjust time for start frame
    dataRange = [];
    dataRange(1) = closest(LOGGER(:,1),xs(1));
    dataRange(2) = dataRange(1) + addSamples;
    
    [S,f,Serr] = mtspectrumc(LOGGER(dataRange(1):dataRange(2),2),params);
    
    if sessionPaths{ii,5}
        koText = 'KO';
        curColor = colors(2,:);
        Sko = [Sko S];
        SerrkoUpper = [SerrkoUpper;Serr(1,:)];
        SerrkoLower = [SerrkoLower;Serr(2,:)];
    else
        koText = 'CT';
        curColor = colors(1,:);
        Sct = [Sct S];
        SerrctUpper = [SerrctUpper;Serr(1,:)];
        SerrctLower = [SerrctLower;Serr(2,:)];
    end
    
    figure;
    subplot(211);
    hold on;
    plot(f,smooth(10*log10(S),smoothAmt),'color',curColor,'linewidth',3);
    plot(f,smooth(10*log10(Serr(1,:)),smoothAmt),'color',[curColor alpha],'linestyle','--');
    plot(f,smooth(10*log10(Serr(2,:)),smoothAmt),'color',[curColor alpha],'linestyle','--');
    xlabel('Frequency (Hz)');
    xlim(params.fpass);
    ylim([15 35]);
    ylabel('Power (10*log10(X))');
    title([sessionPaths{ii,1},' (',koText,') Power Spectrum']);
    subplot(212);
    plot(LOGGER(dataRange(1):dataRange(2),2));
end

figure; hold on;
plot(f,smooth(10*log10(mean(Sct,2)),smoothAmt),'color',colors(1,:),'linewidth',3);
plot(f,smooth(10*log10(mean(Sko,2)),smoothAmt),'color',colors(2,:),'linewidth',3);

plot(f,smooth(10*log10(mean(SerrctUpper)),smoothAmt),'color',[colors(1,:) alpha],'linestyle','--');
plot(f,smooth(10*log10(mean(SerrctLower)),smoothAmt),'color',[colors(1,:) alpha],'linestyle','--');

plot(f,smooth(10*log10(mean(SerrkoUpper)),smoothAmt),'color',[colors(2,:) alpha],'linestyle','--');
plot(f,smooth(10*log10(mean(SerrkoLower)),smoothAmt),'color',[colors(2,:) alpha],'linestyle','--');

legend('CT','KO');
subject = '6152';
videoFile = ['/Users/mattgaidica/Documents/Data/Videos for Tremor Analysis/edits/',subject,'.mov'];
v = VideoReader(videoFile);
resizeScale = 0.5;

frame = read(v,1);
frame = imresize(frame,resizeScale);
h1 = figure;
imshow(frame);
h = imrect;
pos = getPosition(h);
close(h1);

v = VideoReader(videoFile);

allFrames = [];
ii = 1;
h1 = figure;
while hasFrame(v)
    disp(['Frame ',num2str(ii)]);
    frame = readFrame(v);
    frame = imresize(frame,resizeScale);
    frame = imcrop(frame,pos);
    frameGray = imadjust(rgb2gray(frame),[0.1 0.8]);
    imshow(frameGray);
    allFrames(ii,:,:) = frameGray;
    ii = ii + 1;
end
close(h1);

% imshow(frame);
% h = imrect;
% pos = getPosition(h);

Fs = round(v.FrameRate);
fpass = [1 Fs/2];
data = squeeze(reshape(allFrames,[size(allFrames,1) 1 size(allFrames,2)*size(allFrames,3) ]));
% [W,freqList] = calculateComplexScalograms_EnMasse(data,'Fs',Fs,'fpass',fpass,'doplot',true);

dataStd = std(data);
dataAdj = data(:,dataStd > prctile(dataStd,50));

[W,freqList,t] = calculateComplexScalograms_EnMasse(dataAdj,'Fs',Fs,'fpass',fpass,'doplot',false);
realW = squeeze(mean(abs(W).^2, 2))';

figure;
subplot(211);
imagesc(t,freqList,realW);
set(gca, 'YDir', 'normal');
xlim([t(1)+0.5 t(end)-0.5]);
colormap(jet);
xlabel('Time (s)');
ylabel('Freq (Hz)');
title(subject);
caxis([0 50]);
colorbar;

subplot(212);
plot(freqList,mean(realW,2));
xlim(fpass);
xlabel('Freq (Hz)');
ylabel('Amplitude (arb. units)');
ylim([0 40]);

% h = imfreehand;
% mask = createMask(h);
% close(hfig);
% 
% frameMasked = frameGray .* uint8(mask);
% imshow(frameMasked);
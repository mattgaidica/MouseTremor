videoFile = '/Users/mattgaidica/Dropbox/Projects/Mouse Tremor/IMG_2582-clip.mov';
v = VideoReader(videoFile);
resizeScale = 0.5;

frame = read(v,1);
frame = imresize(frame,resizeScale);
imshow(frame);
h = imrect;
pos = getPosition(h);

v = VideoReader(videoFile);

allFrames = [];
ii = 1;
figure;
while hasFrame(v)
    disp(['Frame ',num2str(ii)]);
    frame = readFrame(v);
    frame = imresize(frame,resizeScale);
    frame = imcrop(frame,pos);
    frameGray = imadjust(rgb2gray(frame),[0.1 0.9]);
    imshow(frameGray);
    allFrames(ii,:,:) = frameGray;
    ii = ii + 1;
end

% imshow(frame);
% h = imrect;
% pos = getPosition(h);

Fs = round(v.FrameRate);
fpass = [1 30];
data = squeeze(reshape(allFrames,[size(allFrames,1) 1 size(allFrames,2)*size(allFrames,3) ]));
% [W,freqList] = calculateComplexScalograms_EnMasse(data,'Fs',Fs,'fpass',fpass,'doplot',true);

dataStd = std(data);
dataAdj = data(:,dataStd > prctile(dataStd,50));

[WAdj,freqList] = calculateComplexScalograms_EnMasse(dataAdj,'Fs',Fs,'fpass',fpass,'doplot',true);
colormap(jet);
colorbar;
caxis([0 320]);

% h = imfreehand;
% mask = createMask(h);
% close(hfig);
% 
% frameMasked = frameGray .* uint8(mask);
% imshow(frameMasked);
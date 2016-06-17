function frameData = videoActogram(videoFile,frameInterval)

frameData = []; % [frame, time, diff]
v = VideoReader(videoFile);
resizeScale = 0.5;

frame = read(v,1);
frame = imresize(frame,resizeScale);
imshow(frame);
h = imrect;
pos = getPosition(h);

v = VideoReader(videoFile);

allFrames = [];
iFrame = 1;
prevFrame = [];
for ii=1:frameInterval:v.NumberOfFrames
    frame = read(v,ii);
    frame = imresize(frame,resizeScale);
    frame = imcrop(frame,pos);
    frame = rgb2gray(frame);
    imshow(frame);
    allFrames(iFrame,:,:) = frame;
    frameData(iFrame,1) = ii;
    frameData(iFrame,2) = ii / v.FrameRate;
    frameData(iFrame,3) = 0;
    if ~isempty(prevFrame)
        frameData(iFrame,3) = abs(mean2(frame - prevFrame));
    end
    
    prevFrame = frame;
    iFrame = iFrame + 1;
end

%
v = VideoReader(videoFile);

[pathstr,name,~] = fileparts(videoFile);
newVideo = VideoWriter(fullfile(pathstr,[datestr(now,'yyyymmdd-HHMMSS') '_' name]),'Motion JPEG AVI');
newVideo.Quality = 80;
newVideo.FrameRate = v.FrameRate;
open(newVideo);

t = [0:size(WAdj,1)]./Fs;

h = figure('position',[0 0 640 480]);
curFrame = 1;
realScalogram  = squeeze(mean(abs(WAdj).^2, 2))';
while hasFrame(v)
    frame = readFrame(v);
    frame = imresize(frame,0.5);
    subplot(2,1,1);
    imshow(frame);
    title([num2str(v.CurrentTime,3),'s of ',num2str(v.Duration,3), 's']);
    
    subplot(2,1,2);
    imagesc(t, freqList, realScalogram);
    caxis([0 60]);
    colormap(jet);
    colorbar;
	ylabel('Frequency (Hz)')
	xlabel('Time (s)');
	set(gca, 'YDir', 'normal')
    arrow([v.CurrentTime,0],[v.CurrentTime,1])
    
    writeFrame = getframe(h);
    writeVideo(newVideo,writeFrame);
    curFrame = curFrame + 1;
end

close(newVideo);

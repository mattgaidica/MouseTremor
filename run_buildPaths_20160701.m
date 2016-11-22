% ID, videoPath, loggerPath, frameStart, KO?
basePath = '/Users/mattgaidica/Dropbox/Projects/Dauer Lab/20160701';
sessionPaths = {
    'P4411','videos/converted/00000-P4411-F129.mp4','LOGGER00.CSV',129,0;
    'P4413','videos/converted/00001-P4413-F47.mp4','LOGGER01.CSV',47,1;
    '817','videos/converted/00002-817-F143.mp4','LOGGER02.CSV',143,0;
    '818','videos/converted/00003-818-F63.mp4','LOGGER03.CSV',63,1;
    '6410','videos/converted/00004-6410-F135.mp4','LOGGER04.CSV',135,1;
    '6400','videos/converted/00005-6400-F135.mp4','LOGGER05.CSV',135,1;
    '6402','videos/converted/00007-6402-F121.mp4','LOGGER07.CSV',121,0;
    '6403','videos/converted/00008-6403-F75.mp4','LOGGER08.CSV',75,1;
    '819','videos/converted/00009-819-F36.mp4','LOGGER09.CSV',36,1;
    '821','videos/converted/00010-821-F77.mp4','LOGGER10.CSV',77,0;
    '6138','videos/converted/00011-6138-F35.mp4','LOGGER11.CSV',35,1;
};

frameInterval = 10;
resizeScale = 0.25;
pos = [161.0000  103.0000  176.0000  155.0000];

for ii=1:length(sessionPaths)
    videoFile = fullfile(basePath,sessionPaths{ii,2});
    disp(['running ',sessionPaths{ii,1}]);
    frameData = videoActogram(videoFile,frameInterval,resizeScale,pos);
    save(fullfile(basePath,'matFiles',[sessionPaths{ii,1},'_frameData']),'frameData');
end
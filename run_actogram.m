dataFrameStart = 129;

holdTime = 2; %s
frameRate = 30; %/s
holdFrames = holdTime * frameRate;
dataTimeStart = dataFrameStart / frameRate;

actogramData = smooth(frameData(:,3));
a = actogramData < 1.5;

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
            if frameData(ii,1) - frameData(startIdx,1) >= holdFrames
                compiledIdx = [compiledIdx; frameData(startIdx,1) frameData(ii,1)];
                noMoveTimes = [noMoveTimes; (frameData(startIdx,2) - dataTimeStart) (frameData(ii,2) - dataTimeStart)];
            end
            startIdx = [];
        end
    end  
end

figure;plot(frameData(:,1),actogramData);
hold on;
plot(compiledIdx(:,1),zeros(length(compiledIdx(:,1))),'o');
plot(compiledIdx(:,2),zeros(length(compiledIdx(:,2))),'x');



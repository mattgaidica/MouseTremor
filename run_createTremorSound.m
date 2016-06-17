% Wreal(freqList,frames)
freqMult = 50;
audioFs = 44100;
nInterp = audioFs / v.FrameRate;

t = linspace(0,v.Duration,size(Wreal,2));
% t = [0:1/audioFs:size(Wreal,2)];

musicMatrix = [];
% setup music matrix
for ii=1:length(freqList)
    f = freqList(ii) * freqMult;
    A = Wreal(ii,:); % -1..1
    musicMatrix(ii,:) = A.*sin(2*pi*f*t);
end

musicMatrixInterp = interp(sum(musicMatrix),nInterp);
musicMatrixInterpNormal = normalize(musicMatrixInterp) * 2;
musicMatrixInterpNormal = musicMatrixInterpNormal - mean(musicMatrixInterpNormal);
audiowrite('tremor.mp4',musicMatrixInterpNormal*50,audioFs);
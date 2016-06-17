function loggerSpectogram(logger,frameData,binWidthSec)
% logger [ms, piezoVal, VCC]
% adjust logger to start at 0 & ms -> s
logger(:,1) = (logger(:,1) - logger(1,1)) / 1000;
logger(:,2) = logger(:,2) - mean(logger(:,2));
Fs = 1 / mean(diff(logger(:,1)));
h = figure;

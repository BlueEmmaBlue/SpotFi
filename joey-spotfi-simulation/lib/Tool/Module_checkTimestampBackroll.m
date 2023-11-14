function [ timestampList] = Module_checkTimestampBackroll( timestampList)
%check timestampList back roll
global sampleRate;
% sampleRate = 200;
timeDif = timestampList(2:end)-timestampList(1:end-1);
[timeJumpIndex ] = find(abs(timeDif)>10);
if ~isempty(timeJumpIndex)
    timeGap = timeDif(timeJumpIndex);
    correctTimeGap = 1/sampleRate;
    timeCompensation = correctTimeGap-timeGap;
    timestampList(timeJumpIndex+1:end) =   timestampList(timeJumpIndex+1:end) +timeCompensation;
end

end


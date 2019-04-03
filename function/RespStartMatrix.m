% result Matrix setting
% all the results start Matrix []
function   all = RespStartMatrix()
all.responseVector = []; %
% Make a vector to record the interval time for each trial
all.intervalTimesVector = []; % reshape(zeros(trialNumber,blockNumber),[],1);
all.dotLocaRand = [];
all.dotXpos = [];
all.dotYpos = [];
all.Trial = [];
all.Block = [];
all.condition = [];
all.responseTimeVector = [];
all.lineAngle = [];
all.gaborDistanceFromFixationDegree = [];
all.orientation = [];
end
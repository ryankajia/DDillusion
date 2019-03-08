% result Matrix setting
% all the results start Matrix []
function   [responseVector,intervalTimesVector,TrialAll,BlockAll,conditionAll,responseTimeVector,lineAngleAll,gaborDistanceFromFixationDegreeAll] = RespStartMatrix();
responseVector = []; %
% Make a vector to record the interval time for each trial
intervalTimesVector = []; % reshape(zeros(trialNumber,blockNumber),[],1);
TrialAll = [];
BlockAll = [];
conditionAll = [];
responseTimeVector = [];
lineAngleAll = [];
gaborDistanceFromFixationDegreeAll = [];
end
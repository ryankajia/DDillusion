
% put the condition in and out put the parameters to set up the gabor
% trajoctory and rotation direction
% for apparent motion direction task

function [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,gaborfixationFactor,...
    orientation,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor] = conditionRand(condition,subIlluDegreeNow);
        % InternalDriftPhaseIncrPerFrame > 0 internal drift leftward
        % InternalDriftPhaseIncrPerFrame < 0 internal drift rightward
        % cueVerDisPixFactor = 1  fixation upward
        % cueVerDisPixFactor = - 1 fixation downward
        % xframeFactor = 1  move path rightward along x axis
        % xframeFactor = - 1 gabor move path leftward along x axis
        % gaborfixationFactor = 1; fixation is in the right visual field
        % gaborfixationFactor = - 1; fixation is in the left visual field
        % yframeFactor = 1;   gabor move downward along y axis
        % yframeFactor = - 1; gabor move downward along y axis
        % orientation = 45;  gabor rotate counter clockwise 45
        % orientation = - 45;  gabor rotate clockwise 45
        
    
%  meanSubIlluDegree =  [10 50];


 
switch condition
    case 'upperRight_rightward'  
        InternalDriftPhaseIncrFactor = - 1;
        xframeFactor = - 1 ;
        yframeFactor = - 1;
%         cueVerDisPixFactor = - 1;
        gaborfixationFactor = 1;
        orientation = subIlluDegreeNow;
%         subIlluDegree = meanSubIlluDegree(1);
        gaborStartLocMoveXFactor = 1;
        gaborStartLocMoveYFactor = 1;
    case {'upperRight_leftward'}
        InternalDriftPhaseIncrFactor = 1;
        xframeFactor = 1 ;
        yframeFactor = - 1;
%         cueVerDisPixFactor =  - 1;
        gaborfixationFactor = 1;
        orientation = - subIlluDegreeNow;
%         subIlluDegree = meanSubIlluDegree(2);
        gaborStartLocMoveXFactor = - 1;
        gaborStartLocMoveYFactor = 1;
%     case {'upperLeft_rightward'}
%         InternalDriftPhaseIncrFactor = - 1;
%         xframeFactor = - 1 ;
%         yframeFactor = - 1;
%         cueVerDisPixFactor = - 1;
%         gaborfixationFactor = - 1;
%         orientation =   45;
%         subIlluDegree = meanSubIlluDegree(3);
%     case {'upperLeft_leftward'}
%         InternalDriftPhaseIncrFactor = 1;
%         xframeFactor = 1 ;
%         yframeFactor = - 1;
%         cueVerDisPixFactor =  - 1;
%         gaborfixationFactor = - 1;
%         orientation = - 45;
%         subIlluDegree = meanSubIlluDegree(4);
%     case {'lowerRight_rightward'}
%         InternalDriftPhaseIncrFactor = - 1;
%         xframeFactor = - 1 ;
%         yframeFactor = 1;
%         cueVerDisPixFactor =  1;
%         gaborfixationFactor =  1;
%         orientation = -45;
%         subIlluDegree = meanSubIlluDegree(5);
%     case {'lowerRight_leftward'}
%         InternalDriftPhaseIncrFactor =  1;
%         xframeFactor = 1 ;
%         yframeFactor = 1;
%         cueVerDisPixFactor =  1;
%         gaborfixationFactor =  1;
%         orientation = 45;
%         subIlluDegree = meanSubIlluDegree(6);
%     case {'lowerLeft_rightward'}
%         InternalDriftPhaseIncrFactor =  - 1;
%         xframeFactor =  - 1 ;
%         yframeFactor = 1;
%         cueVerDisPixFactor =  1;
%         gaborfixationFactor =  - 1;
%         orientation =  - 45;
%         subIlluDegree = meanSubIlluDegree(7);
%     case {'lowerLeft_leftward'}
%         InternalDriftPhaseIncrFactor =  1;
%         xframeFactor =  1 ;
%         yframeFactor = 1;
%         cueVerDisPixFactor =  1;
%         gaborfixationFactor =  - 1;
%         orientation = 45;
%         subIlluDegree = meanSubIlluDegree(8);
%     case {'catch_trial'}
%         % no internal motion of gabor
%         InternalDriftPhaseIncrFactor = 0;
%         xframeFactor =  1 ;
%         yframeFactor =  1;
%         cueVerDisPixFactor =  1;
%         gaborfixationFactor =  - 1;
%         orientation = 45;
%         subIlluDegree = 45;
end
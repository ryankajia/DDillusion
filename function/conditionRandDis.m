% put the condition in and out put the parameters to set up the gabor
% trajoctory and rotation direction

function [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition,blockData,trial);
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
 
        
        % rightward  7dva    leftward 7 dva  rightward 10dva  leftward 10dva
 meanSubIlluDegree =  [45 45 45 45];
 
% rightward 7dva   blockData(trial,1)   fixation distance
if  (strcmp(condition,'upperRight_rightward')  &&  blockData(trial,1) == 1)
 
        InternalDriftPhaseIncrFactor = - 1;
        xframeFactor = - 1 ;
        yframeFactor = - 1;
        cueVerDisPixFactor = - 1;
        gaborfixationFactor = 1;
        orientation = 45;       
        subIlluDegree = meanSubIlluDegree(1);
        gaborStartLocMoveXFactor = 1;
        gaborStartLocMoveYFactor = 1;
        
% leftward 7dva 
elseif  (strcmp(condition,'upperRight_leftward')  &&  blockData(trial,1) == 1)
   
        InternalDriftPhaseIncrFactor = 1;
        xframeFactor = 1 ;
        yframeFactor = - 1;
        cueVerDisPixFactor =  - 1;
        gaborfixationFactor = 1;
        orientation = - 45;
        subIlluDegree = meanSubIlluDegree(2);
        gaborStartLocMoveXFactor = - 1;
        gaborStartLocMoveYFactor = 1;
        
        % rightward  10dva 
elseif  (strcmp(condition,'upperRight_rightward')  &&  blockData(trial,1) == 2) 
    
        InternalDriftPhaseIncrFactor = - 1;
        xframeFactor = - 1 ;
        yframeFactor = - 1;
        cueVerDisPixFactor = - 1;
        gaborfixationFactor = 1;
        orientation =   45;
        subIlluDegree = meanSubIlluDegree(3);
        gaborStartLocMoveXFactor = 1;
        gaborStartLocMoveYFactor = 1;
        
        % leftward 10dva
elseif  (strcmp(condition,'upperRight_leftward')  &&  blockData(trial,1) == 2)
        InternalDriftPhaseIncrFactor = 1;
        xframeFactor = 1 ;
        yframeFactor = - 1;
        cueVerDisPixFactor =  - 1;
        gaborfixationFactor = 1;
        orientation = - 45;
        subIlluDegree = meanSubIlluDegree(4);
        gaborStartLocMoveXFactor = - 1;
        gaborStartLocMoveYFactor = 1;
 
end
%% conversions
% calculate proportion of the apparent motion from the perceived endpoint
% to the gabor test 

% function [ouput1, output2] = my_function(input1,input2)
% ----------------------------------------------------------------------
% [ouput1, output2] = my_function(input1,input2)
% ---------------------------------------------------------------------
% Goal of the function:
% calculate proportion of the apparent motion from the perceived endpoint
% to the gabor test
% ----------------------------------------------------------------------
% Input(s):
% RespMat: response from the experiment.
% gaborMatSingle: conditions of gabor directions.
% intervalTimesMatSingle: the variables here means the gabor disappeared
% and after a random interval of 0-350 ms.
% ----------------------------------------------------------------------
% Output(s):
% proporPerc: at diffrient directions the apparent motion from the perceived.
% performance: subject performance in catch trial.
% ----------------------------------------------------------------------
% Function created by Hjh (xx.xx@xx.com)
% Last update: 12 / 3 / 2018
% Project: Apparent motion of double drift target originates from physical location 
% at short delays but from closer to perceived location at longer delays
% Version: 1
% ----------------------------------------------------------------------

function [proporPerc,meanReactionTime,performance] = RespMat2propor(RespMat,gaborMatSingle,intervalTimesMatSingle);


if   ~ exist('gaborMatSingle','var') || isempty(gaborMatSingle)        
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
        'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward'};
end
if ~ exist('intervalTimesMatSingle','var') || isempty(intervalTimesMatSingle)  
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
end
    trialNumPerCondition = length(RespMat)/length(gaborMatSingle);
    % catch trial performance initial number
    ct = 0;
    
    for i = 1: numel(intervalTimesMatSingle)
        
        % timeIndex  find the different interval time in the matrix and make an
        % index   column 1 mean 0 ms column 2 means 50 ms and so on
        if i == 8;
            timeIndex(:,i) = find(str2double(RespMat(:,4)) == 0.35);
        else
            timeIndex(:,i) = find(str2double(RespMat(:,4)) == intervalTimesMatSingle(i));
        end
        

        
        % calculate response times from perceived location at each interval
        intervalResp(i) = 0;
        reactionTime(i) = 0;
        
        % condition calculate the condition response in the same interval time
        % condition 1 means upperRight_rightward and so on
        for condition = 1: size(timeIndex,1)
            
            %         conditionResp = convertStringsToChars(RespMat(timeIndex(condition,i),5));
            conditionResp = str2num(RespMat(timeIndex(condition,i),5));
            
            
            switch RespMat(timeIndex(condition,i),3)
                % left 1   right 0
                % apparent motion from perceived or real path
                case 'upperRight_rightward'
                    upperRight_rightward = conditionResp;
                    if upperRight_rightward == 1
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                case 'upperRight_leftward'
                    upperRight_leftward = conditionResp;
                    if upperRight_leftward == 0
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                    
                case 'upperLeft_rightward'
                    upperLeft_rightward = conditionResp;
                    if upperLeft_rightward == 1;
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                    
                case 'upperLeft_leftward'
                    upperLeft_leftward = conditionResp;
                    if upperLeft_leftward == 0
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                case 'lowerRight_rightward'
                    lowerRight_rightward = conditionResp;
                    if lowerRight_rightward == 1;
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                case 'lowerRight_leftward'
                    lowerRight_leftward = conditionResp;
                    if lowerRight_leftward == 0
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                    
                case 'lowerLeft_rightward'
                    lowerLeft_rightward = conditionResp;
                    if lowerLeft_rightward == 1;
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                case 'lowerLeft_leftward'
                    lowerLeft_leftward = conditionResp;
                    if lowerLeft_leftward == 0;
                        intervalResp(i) = intervalResp(i) + 1;
                    end
                    
                    
                case 'catch_trial'
                    % catch_trial is always in the lower_left  path is right downward
                    % so only answer left 1 is correct
                    catch_trial = conditionResp;
                    if catch_trial == 1;
                        ct = ct + 1;
                    end
            end
            reactionTime(i,condition) = RespMat(timeIndex(condition,i),6);
        end
    end
    
    performance = ct/trialNumPerCondition;
    meanReactionTime = mean(str2double(reactionTime),2);



proporPerc = intervalResp/size(timeIndex,1);
end



% plot(intervalTimesMatSingle,intervalResp/size(timeIndex,1));
% hold on;
% plot(intervalTimesMatSingle,mean(proporPerc,2)','k','LineWidth',3);
% 
% hold on;
% proporPerc_ste = ste(proporPerc,2);
% bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
% errorbar(1:length(intervalTimesMatSingle),mean(proporPerc,2),proporPerc_ste,'k.');
% 
% axis([0 0.4 0 1.0]);
% title('proportion of apparent motion from the end of perceived path');
% xlabel('interval time between illusion and cue');
% ylabel('proportion of apparent motion from the end of perceived path');
% % legend({'y = sin(x)','y = cos(x)'},'Location','southwest')
% ax = gca;
% ax.FontSize = 13;

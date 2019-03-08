% analysis subject's perception from the end of the perceived or from the
% end of physical  and didn't use function  RespMat2propor it's the
% original code before function

clear all;


sbjnames = {'huijiahan','mert','shriff'};
addpath '../function';
cd '../data/GaborDrift/illusionDegreeSpec/0.5dva';

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    
     gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
        'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward','catch_trial'};
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
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
        intervalResp(i,sbjnum) = 0;
        
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
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                case 'upperRight_leftward'
                    upperRight_leftward = conditionResp;
                    if upperRight_leftward == 0
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                    
                case 'upperLeft_rightward'
                    upperLeft_rightward = conditionResp;
                    if upperLeft_rightward == 1;
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                    
                case 'upperLeft_leftward'
                    upperLeft_leftward = conditionResp;
                    if upperLeft_leftward == 0
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                case 'lowerRight_rightward'
                    lowerRight_rightward = conditionResp;
                    if lowerRight_rightward == 1;
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                case 'lowerRight_leftward'
                    lowerRight_leftward = conditionResp;
                    if lowerRight_leftward == 0
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                    
                case 'lowerLeft_rightward'
                    lowerLeft_rightward = conditionResp;
                    if lowerLeft_rightward == 1;
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                case 'lowerLeft_leftward'
                    lowerLeft_leftward = conditionResp;
                    if lowerLeft_leftward == 0;
                        intervalResp(i,sbjnum) = intervalResp(i,sbjnum) + 1;
                    end
                    
                    
                case 'catch_trial'
                    % catch_trial is always in the lower_left  path is right downward
                    % so only answer left 1 is correct
                    catch_trial = conditionResp;
                    if catch_trial == 1;
                        ct = ct + 1;
                    end
            end
            reactionTime(i,condition,sbjnum) = RespMat(timeIndex(condition,i),6);
        end
    end
%     reactionTimeMat(i,sbjnum) = mean(reactionTime,2);
    performance = ct/trialNumPerCondition;
    meanReactionTime = mean(str2double(reactionTime),2);
    plot(meanReactionTime(:,:,sbjnum));
    hold on;
end
% meanReactionTime = mean(str2double(reactionTime),2);
meanReactionTimeSize = size(meanReactionTime);
meanReactionTime = reshape(meanReactionTime,meanReactionTimeSize(1)*meanReactionTimeSize(2),meanReactionTimeSize(3));
plot(meanReactionTime);
intervalTimesMatSingle = intervalTimesMatSingle * 1000;
proporPerc = (intervalResp/size(timeIndex,1))*100;
% plot(intervalTimesMatSingle,intervalResp/size(timeIndex,1),'--o');
plot(intervalTimesMatSingle,proporPerc,'--o');
hold on;
% plot mean 
% p = plot(intervalTimesMatSingle,mean(proporPerc,2)','r');

hold on;
% plot errorbar 
proporPerc_ste = ste(proporPerc,2);
% e = errorbar(intervalTimesMatSingle,mean(proporPerc,2),proporPerc_ste,'r');
e.LineStyle = '-';
e.Marker = 'o';
e.LineWidth = 2;

axis([0 400 0 100]);
title('apparent motion originate from perceived location','FontSize',30);
xlabel('interval time between illusion and test gabor (ms)','FontSize',25);
ylabel('proportion of apparent motion originate from perceived location (%)','FontSize',22);
% ax = gca;
% ax.FontSize = 13;
legend(sbjnames,'Location','northeast','FontSize',30);

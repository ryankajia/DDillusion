% control trial without illusion but with the same subIlluDegree as
% illusion trials
% Also analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../function';

cd '../data/noIllusion'
% 0.5 dva
% mark = 1 means aveDegree
mark = 1;
if mark == 1
    sbjnames = {'hjhAveDegree'};
else
    sbjnames = {'huijiahan'};
end

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
        'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward'};
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
    if mark == 1
        IllusionDegree = [15 20 25 30 35 40 45 50];
    else
        IllusionDegree = [51.6842   47.4737   26.5263   52.6316   52.5263   50.4211   11.6842   53.4737]; %
    end
    RespInDegree = zeros(1,(size(IllusionDegree,2)));
    
    for i = 1: size(RespMat,1)
        
        % conditionResp mean the participants reaction
        conditionResp = str2num(RespMat(i,5));
        
        switch RespMat(i,3)
            % left 1   right 0
            % apparent motion from the wrong side(perceived or real path)
            case 'upperRight_rightward'
                upperRight_rightward = conditionResp;
                if upperRight_rightward == 1
                    RespInDegree(1) = RespInDegree(1) + 1;
                end
                
            case 'upperRight_leftward'
                upperRight_leftward = conditionResp;
                if upperRight_leftward == 0
                    RespInDegree(2) = RespInDegree(2) + 1;
                end
                
                
            case 'upperLeft_rightward'
                upperLeft_rightward = conditionResp;
                if upperLeft_rightward == 1;
                    RespInDegree(3) = RespInDegree(3) + 1;
                end
                
                
            case 'upperLeft_leftward'
                upperLeft_leftward = conditionResp;
                if upperLeft_leftward == 0
                    RespInDegree(4) = RespInDegree(4) + 1;
                end
                
            case 'lowerRight_rightward'
                lowerRight_rightward = conditionResp;
                if lowerRight_rightward == 1;
                    RespInDegree(5) = RespInDegree(5) + 1;
                end
                
            case 'lowerRight_leftward'
                lowerRight_leftward = conditionResp;
                if lowerRight_leftward == 0
                    RespInDegree(6) = RespInDegree(6) + 1;
                end
                
                
            case 'lowerLeft_rightward'
                lowerLeft_rightward = conditionResp;
                if lowerLeft_rightward == 1;
                    RespInDegree(7) = RespInDegree(7) + 1;
                end
                
            case 'lowerLeft_leftward'
                lowerLeft_leftward = conditionResp;
                if lowerLeft_leftward == 0;
                    RespInDegree(8) = RespInDegree(8) + 1;
                end
                
                
            case 'catch_trial'
                % catch_trial is always in the lower_left  path is right downward
                % so only answer left 1 is correct
                catch_trial = conditionResp;
                if catch_trial == 1;
                    ct = ct + 1;
                end
        end
        %             reactionTime(i,condition) = RespMat(timeIndex(condition,i),6);
    end
    
end


plot(IllusionDegree,(RespInDegree/48)*100,'ro-','MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.5,0.5,0.5]);



% proporPerc_ste = ste(proporPerc,1);
% bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
% errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');

axis([0 55 -2 100]);
title('performance in the hypothesis illusion degree - with no internal motion','FontSize',30);
xlabel('degree of the direction of gabor','FontSize',30);
ylabel({'accurancy - proportion of apparent motion from the end of the wrong side(%)';'<<correct     wrong>> '}','FontSize',20);
legend('without internal motion','Location','northeast','FontSize',20)
% ax = gca;
% ax.FontSize = 30;

% cd '../../analysis'


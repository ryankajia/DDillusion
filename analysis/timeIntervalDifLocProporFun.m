% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../function';
% decide analysis which distance 
mark = 2;

if mark == 1
    cd '../data/GaborDrift/illusionDegreeSpec/0.5dva'
    % 0.5 dva
    sbjnames = {'huijiahan1','kevin','mert1','shriff1','liuchengwen','marvin','nate'};
elseif mark ~= 1
    % 1.5 dva
    cd '../data/GaborDrift/illusionDegreeSpec/1.5dva'
    sbjnames = {'huijiahan2','kevin','marvin','mert2','shriff2','sunliwei3','liuchengwen','nate'};
end

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
        'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward','catch_trial'};
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
    
    
    [proporPerc(sbjnum,:),meanReactionTime(sbjnum),performance(sbjnum)] = RespMat2propor(RespMat,gaborMatSingle,intervalTimesMatSingle);
    
    plot(intervalTimesMatSingle*1000,proporPerc(sbjnum,:)*100);
    hold on;
end
performance
% hold on;
% 
% plot(intervalTimesMatSingle*1000,proporPerc*100);
hold on;
plot(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,'r','LineWidth',3);
% plot(meanReactionTime);


proporPerc_ste = ste(proporPerc,1);
% bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');

axis([-10 400 0 100]);
title('proportion of apparent motion from the end of perceived path(0.5dva)','FontSize',40);
xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
ylabel({'proportion of apparent motion from the end of perceived path(%)';'  << more from physical      more from perceived  >> '},'FontSize',20);
legend(sbjnames,'Location','northeast')
% ax = gca;
% ax.FontSize = 13;

cd '../../../../analysis'




% control trial without illusion but with the same subIlluDegree as
% illusion trials 
% Also analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../function';

cd '../data/noIllusion'
% 0.5 dva
sbjnames = {'hjhAveDegree'};

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward','upperLeft_rightward','upperLeft_leftward',...
        'lowerRight_rightward' ,'lowerRight_leftward','lowerLeft_rightward','lowerLeft_leftward'};
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
    
    
    [proporPerc(sbjnum),meanReactionTime(sbjnum),performance(sbjnum)] = RespMat2propor(RespMat,gaborMatSingle,intervalTimesMatSingle);
    
end
performance
% proporPerc = intervalResp/size(timeIndex,1);
plot(intervalTimesMatSingle*1000,proporPerc*100);
hold on;
% plot(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,'r','LineWidth',3);
% plot(meanReactionTime);


proporPerc_ste = ste(proporPerc,1);
% bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
% errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');

axis([-10 400 0 100]);
title('proportion of apparent motion from the end of the gabor path - with no internal motion','FontSize',30);
xlabel('interval time between illusion and test gabor(ms)','FontSize',30);
ylabel('proportion of apparent motion from the end of the wrong side(%)','FontSize',20);
legend(sbjnames,'Location','northeast')
% ax = gca;
% ax.FontSize = 30;

% cd '../../analysis'




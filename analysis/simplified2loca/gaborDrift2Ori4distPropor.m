% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance 
mark = 1;

if mark == 1
    cd '../../data/GaborDrift/simplified2loca'
    % 0.5 dva
    sbjnames = {'huijiahanfinal'};
elseif mark ~= 1
    % 1.5 dva
    cd '../../data/GaborDrift/simplified2loca'
    sbjnames = {'huijiahan2','kevin','marvin','mert2','shriff2','sunliwei3','liuchengwen','nate'};
end

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 50 100 150 200 250 300 350]* 0.001;
    
    for i = 1:length(RespMat)
        
    if RespMat(i,2) == 'upperRight_leftward'  &&  str2num(RespMat(i,4)) == 5
        subIlluDegree(2) = RespMat(:,6);
   
    elseif RespMat(i,2) == 'upperRight_leftward'  &&  str2num(RespMat(i,4)) == 7
        subIlluDegree(4) = RespMat(:,6);
   
    elseif RespMat(i,2) == 'upperRight_rightward'  &&  str2num(RespMat(i,4)) == 5
        subIlluDegree(6) = RespMat(:,6);
    
    elseif RespMat(i,2) == 'upperRight_rightward'  &&  str2num(RespMat(i,4)) == 7
        subIlluDegree(8) = RespMat(:,6);    
    end
end


% first is upperRight_leftward  distance 5 & 7     upperRight_rightward  distance 5 & 7 
meanSubIlluDegree(:,sbjnum) = mean(subIlluDegree(:,5:end),2);
% scatter(ones(1,8)*8,meanSubIlluDegree,'filled');
end

hold on;

plot(intervalTimesMatSingle*1000,proporPerc*100);
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

% cd '../../../../analysis'




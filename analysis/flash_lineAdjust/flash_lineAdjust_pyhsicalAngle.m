% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance
mark = 3;

% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust'
    % 0.5 dva
    sbjnames = {'wangzetong'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
elseif mark == 2
    % 1.5 dva
    cd '../../data/GaborDrift/flash_lineAdjust'
    sbjnames = {'mert'}; 
    lineAngleColumn = 6;
    
    % for test gabor line adjust 
elseif mark == 3
    cd '../../data/GaborDrift/gabor_lineAdjust'
    % 0.5 dva
    sbjnames = {'hehuixia'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
    
end



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [7  10];
    LineDegree7dva_left = zeros(8,1);
    LineDegree7dva_right = zeros(8,1);
    LineDegree10dva_left = zeros(8,1);
    LineDegree10dva_right = zeros(8,1);
    
    
    switch s1
        case  'huijiahan664'
            meansubIlluDegree = [41.4444   41.8889   39.6667   42.3333];
        case 'guofanhua'
            meansubIlluDegree = [38.7692   45.6923   44.6154   51.0769];
        case 'linweiru'
            meansubIlluDegree = [46.9231   45.6923   51.2308   51.6923];
        case 'sunliwei'
            meansubIlluDegree = [51.2857   41.3810   55.8571   45.1905];
        case 'wangzetong'
            meansubIlluDegree = [36.0769   34.5385   41.0000   35.7692];
        case 'mert'
            meansubIlluDegree = [32.2000   21.0000   26.9200   21.0000];
        case 'huijiahan'
            meansubIlluDegree = [41.9231   34.5385   49.9231   35.4615];
        case 'hehuixia'
            meansubIlluDegree = [36.0400   28.2000   43.7200   35.2400];
        case 'jiangyong'
            meansubIlluDegree = [31.8462   20.0000   41.0769   20.3077];
    end
                    
                    
                
    
    for i = 1 : length(RespMat)
        
        if str2double(RespMat(i,5)) == 7
            
            for delay1 = 1 :length(intervalTimesMatSingle)
                
                if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay1)

                    switch RespMat(i,3)
                        % left 1   right 0
                        % record the apparent motion from perceived path
                        % leftward perceived end  lingAngle is < 0 
                        case 'upperRight_leftward'
                            LineDegree7dva_left(delay1) = LineDegree7dva_left(delay1) + str2double(RespMat(i,lineAngleColumn));
                        % rightward perceived end  lingAngle is > 0 
                        case 'upperRight_rightward'
                            LineDegree7dva_right(delay1) = LineDegree7dva_right(delay1) + str2double(RespMat(i,lineAngleColumn));
                    end
                end
            end
        elseif str2double(RespMat(i,5)) == 10
            for delay2 = 1:length(intervalTimesMatSingle)
                if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay2)
                    switch RespMat(i,3)
                        % left 1   right 0
                        % record the apparent motion from real path
                        case 'upperRight_leftward'
                            LineDegree10dva_left(delay2) = LineDegree10dva_left(delay2) + str2double(RespMat(i,lineAngleColumn));
                        case 'upperRight_rightward'
                            LineDegree10dva_right(delay2) = LineDegree10dva_right(delay2) + str2double(RespMat(i,lineAngleColumn));
                    end
                end
            end
        end
    end
% end

trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree));

% LineDegree7dva_right = - LineDegree7dva_right/trialNumPerCondition;
LineDegree7dva_left = - LineDegree7dva_left/(trialNumPerCondition/2);
LineDegree7dva_right = - LineDegree7dva_right/(trialNumPerCondition/2);
LineDegree10dva_left = - LineDegree10dva_left/(trialNumPerCondition/2);
LineDegree10dva_right = - LineDegree10dva_right/(trialNumPerCondition/2);



 % rightward  7dva    leftward 7 dva  rightward 10dva  leftward 10dva
 % meansubIlluDegree(1-4)
plot(intervalTimesMatSingle*1000,LineDegree7dva_left*180/pi,'g');
yline(-meansubIlluDegree(2)/2,'b');
hold on;
plot(intervalTimesMatSingle*1000,LineDegree7dva_right*180/pi,'r');
yline(meansubIlluDegree(1)/2,'r');
hold on;
plot(intervalTimesMatSingle*1000,LineDegree10dva_left*180/pi,'b');
yline(-meansubIlluDegree(4)/2,'g');
hold on;
plot(intervalTimesMatSingle*1000,LineDegree10dva_right*180/pi,'m');
yline(meansubIlluDegree(3)/2,'m');



end
%     hold on;
%     plot(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,'r','LineWidth',3);
%     % plot(meanReactionTime);
%
%
%     proporPerc_ste = ste(proporPerc,1);
%     % bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
%     errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');
%
    axis([-10 400 -30 30]);
%     legend('7dva-leftward-S4','7dva-rightward-S4','10dva-leftward-S5','10dva-rightward-S5');
%     legend(sbjnames);
%     legend('7dva-huijiahan','10dva-huijiahan','7dva-sunliwei','10dva-sunliwei','7dva-S3','10dva-S3'); % ,'7dva-S2','10dva-S2'
    title(sbjnames,'FontSize',40);
%     title('perceived of apparent motion from the end of perceived path','FontSize',40);
    xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
    ylabel({' << internal motion leftward      internal motion rightward  >> '},'FontSize',20);
% %     legend(sbjnames,'Location','northeast')
    ax = gca;
    ax.FontSize = 20;
%
%     cd '../../../analysis'




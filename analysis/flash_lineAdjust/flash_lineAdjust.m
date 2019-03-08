% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance
mark = 1;

if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust'
    % 0.5 dva
    sbjnames = {'wangzetong'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'
    lineAngleColumn = 7;
    
elseif mark ~= 1
    % 1.5 dva
    cd '../../data/GaborDrift/lineAdjust'
    sbjnames = {'mert'}; 
    lineAngleColumn = 6;
end



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [7 10];
    LineDegree7dva_left = zeros(8,1);
    LineDegree7dva_right = zeros(8,1);
    LineDegree10dva_left = zeros(8,1);
    LineDegree10dva_right = zeros(8,1);
    % left 1   right 0
    % record the apparent motion from real path
    
    %     oritation = RespMat(:,3);
    %     oritation_left = strcmp('upperRight_leftward',oritation);
    %     oritation_right = strcmp('upperRight_rightward',oritation);
    %
    %     distance = RespMat(:,5);
    %     distance7 = strcmp('7',distance);
    %     distance10 = strcmp('10',distance);
    %     delay = RespMat(:,4);
    %     delay1 = strcmp('0',delay);
    %     delay2 = strcmp('50',delay);
    %     delay3 = strcmp('100',delay);
    %     delay4 = strcmp('150',delay);
    %     delay5 = strcmp('200',delay);
    %     delay6 = strcmp('250',delay);
    %     delay7 = strcmp('300',delay);
    %     delay8 = strcmp('350',delay);
    %
    %     Respdis7delay1 = sum(distance7 .* delay1 .* oritation_left);
    %     Respdis7delay2 = sum(distance7 .* delay2 .* oritation_left);
    %     Respdis7delay3 = sum(distance7 .* delay3 .* oritation_left);
    %     Respdis7delay4 = sum(distance7 .* delay4 .* oritation_left);
    %     Respdis7delay5 = sum(distance7 .* delay5 .* oritation_left);
    %     Respdis7delay6 = sum(distance7 .* delay6 .* oritation_left);
    %     Respdis7delay7 = sum(distance7 .* delay7 .* oritation_left);
    %     Respdis7delay8 = sum(distance7 .* delay8 .* oritation_left);
    
    
    
    
    
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

% LineDegree7dva = (LineDegree7dva_left - LineDegree7dva_right)/trialNumPerCondition;
% LineDegree10dva = (LineDegree10dva_left - LineDegree10dva_right)/trialNumPerCondition;
LineDegree10dva_left = LineDegree10dva_left/trialNumPerCondition;
LineDegree10dva_right = LineDegree10dva_right/trialNumPerCondition;

plot(intervalTimesMatSingle*1000,LineDegree10dva_left*180/pi);
hold on;
plot(intervalTimesMatSingle*1000,LineDegree10dva_right*180/pi);
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
%     axis([-10 400 -20 20]);
%     legend('7dva-S4','10dva-S4','7dva-S5','10dva-S5');
    legend('1','2');
%     legend('7dva-huijiahan','10dva-huijiahan','7dva-sunliwei','10dva-sunliwei','7dva-S3','10dva-S3'); % ,'7dva-S2','10dva-S2'
%     title('perceived of apparent motion from the end of perceived path','FontSize',40);
    xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
    ylabel({' << more from perceived      more from physical  >> '},'FontSize',20);
% %     legend(sbjnames,'Location','northeast')
    ax = gca;
    ax.FontSize = 20;
%
%     cd '../../../analysis'




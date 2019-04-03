% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance
mark = 1;

% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/AP_angle'
    sbjnames = {'huijiahan'}; % 'huijiahan','lucy','xiahuan','gaoyige'
    lineAngleColumn = 7;
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/AP_angle_7_10dva'
    sbjnames = {'lucy'};
    lineAngleColumn = 7;
    
    % for test gabor line adjust
elseif mark == 3
    cd '../../data/GaborDrift/gabor_lineAdjust'
    
    sbjnames = {'jiangyong','huijiahan','hehuixia'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
elseif mark == 4
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    sbjnames = {'jiangyong','huijiahan'};
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
    lineAngleColumn = 7;
    
    
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
        
    
    if length(meanSubIlluDegree) == 4
        trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree));
        LineAngle = [LineDegree7dva_right LineDegree7dva_left  LineDegree10dva_right LineDegree10dva_left];
        LineAngle_ave = LineAngle/(trialNumPerCondition/2);
        
        % angle devide the physical angle is the proportion of physical  substract
        % from 1 is the proportion from perceived endpoint
        % ward = 4 7dva rightward leftward 10dva rightward leftward
        
        for ward = 1:4
            for delay = 1:8
                % internal drift rightward
                if ward ==1 || ward==3
                    if LineAngle_ave(delay,ward) < 0
                    % angle devide the physical angle
                    Physi_prop_temp(delay,ward) = 1/2 - abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                    elseif LineAngle_ave(delay,ward) > 0
                        Physi_prop_temp(delay,ward) = 1/2 + abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                    end
                    % angle devide the physical angle
%                     Physi_prop_temp(delay,ward) = 1/2 - abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                    % internal drift leftward
                elseif ward ==2 || ward==4
                    if LineAngle_ave(delay,ward) > 0
                    Physi_prop_temp(delay,ward) = 1/2 - abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                    elseif LineAngle_ave(delay,ward) < 0
                        Physi_prop_temp(delay,ward) = 1/2 + abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                    end 
%                     Physi_prop_temp(delay,ward) = 1/2 - abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                end
            end
        end
    elseif length(meanSubIlluDegree) == 2
        gaborDistanceFromFixationDegree = [10];
        trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree));
        LineAngle = [LineDegree10dva_right LineDegree10dva_left];
        LineAngle_ave = LineAngle/(trialNumPerCondition/2);
        for ward = 1:2
            for delay = 1:8
                % internal drift rightward
                if ward == 1
%                     if LineAngle_ave(delay,ward) < 0
% %                     angle devide the physical angle
%                     Physi_prop_temp(delay,ward) = 1/2 - abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
%                     elseif LineAngle_ave(delay,ward) > 0
                        Physi_prop_temp(delay,ward) = 1/2 + (LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
%                     end
                    % internal drift leftward
                elseif ward == 2
%                     if LineAngle_ave(delay,ward) > 0
                    Physi_prop_temp(delay,ward) = 1/2 - (LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
%                     elseif LineAngle_ave(delay,ward) < 0
%                         Physi_prop_temp(delay,ward) = 1/2 + abs(LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
%                     end       
                end
            end
        end
    end
    % 0 means AM from physical 100 means AM from perceived
    % Physi_prop(:,sbjnum) = mean(Physi_prop_temp,2);
    %     plot(intervalTimesMatSingle*1000,mean(Physi_prop_temp(:,1:2),2)*100);
    Physi_prop(:,sbjnum) = mean(Physi_prop_temp,2);
    
    %     legend(sbjnames(sbjnum),'Location','northeast')
    hold on;
    
    
% end
if mark == 1 || 2
    plot(intervalTimesMatSingle*1000,mean(Physi_prop,2)*100,'b');
elseif mark == 4 || 3
    plot(intervalTimesMatSingle*1000,mean(Physi_prop,2)*100,'r');
end
end
% Physi_prop_ste = ste(Physi_prop,2);
% errorbar(intervalTimesMatSingle*1000,mean(Physi_prop,2)*100,Physi_prop_ste*100,'-r','MarkerSize',3,...
%     'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',2);

% [p,tbl,stats] = anova1(Physi_prop');
axis([-10 400 0 100]);
title('percentage of apparent motion from the end of physical path(3.5dva)','FontSize',40);
xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
ylabel({'percentage from perceived'},'FontSize',20);
% legend('S1','S2','S3','S4','S5','S6','S7','Location','northeast')
% legend('S1','S2','S3','S4','Location','northeast');
[lgd, icons, plots, txt] = legend('show');

ax = gca;
ax.FontSize = 20;





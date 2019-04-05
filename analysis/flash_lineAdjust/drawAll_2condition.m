% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance
mark = 1;

% eachPercLoc = input('>>>> show each perceived location? (e.g.: n or y):  ','s');
eachPercLoc = 'n';

% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/percLocaTest'
    sbjnames = {'huijiahan'}; % 'huijiahan','lucy','xiahuan','gaoyige'
    %     lineAngleColumn = 7;
    
    
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    sbjnames = {'mert'};
    lineAngleColumn = 6;
    
    % for test gabor line adjust
elseif mark == 3
    cd '../../data/GaborDrift/gabor_lineAdjust'
    
    sbjnames = {'jiangyong','huijiahan','hehuixia'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
elseif mark == 4
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    sbjnames = {'huijiahan'};
end



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [10];
    
    [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborStartLocation_L);
    [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborEndLocation_L);
    
    [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborStartLocation_R);
    [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborEndLocation_R);
    
    dotXpos_L_Mat = [];
    dotYpos_L_Mat = [];
    dotXpos_R_Mat = [];
    dotYpos_R_Mat = [];
    
    
    for i = 1 : length(RespMat)
        switch RespMat(i,3)
            % left 1   right 0
            % record the apparent motion from real path
            case 'upperRight_leftward'
                dotXpos_L_now =  str2double(RespMat(i,6));
                dotYpos_L_now =  str2double(RespMat(i,7));
                if eachPercLoc == 'y'
                    plot(dotXpos_L_now,dotYpos_L_now,'ro');
                end
                hold on;
                dotXpos_L_Mat = [dotXpos_L_Mat;dotXpos_L_now];
                dotYpos_L_Mat = [dotYpos_L_Mat;dotYpos_L_now];
            case 'upperRight_rightward'
                dotXpos_R_now =  str2double(RespMat(i,6));
                dotYpos_R_now =  str2double(RespMat(i,7));
                if eachPercLoc == 'y'
                    plot(dotXpos_R_now,dotYpos_R_now,'bo');
                end
                dotXpos_R_Mat = [dotXpos_R_Mat;dotXpos_R_now];
                dotYpos_R_Mat = [dotYpos_R_Mat;dotYpos_R_now];
                hold on;
        end
        
    end
    % end
    
    % plot centroid of each perceived location
    percLoca_L = plot(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
    hold on;
    percLoca_R = plot(mean(dotXpos_R_Mat),mean(dotYpos_R_Mat),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
    
    
    originX_L = [dotXpos_L_st,dotXpos_L_end];
    originY_L = [dotYpos_L_st,dotYpos_L_end];
    originX_R = [dotXpos_R_st,dotXpos_R_end];
    originY_R = [dotYpos_R_st,dotYpos_R_end];
    
    % plot the gabor trajactory
    gaborTraj_L = plot(originX_L,originY_L,'r-','MarkerFaceColor','r');
    hold on;
    gaborTraj_R = plot(originX_R,originY_R,'b-','MarkerFaceColor','b');
    % set the origin on the left top
    set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
    
    cd '../AP_angle'
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
%     gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
%     intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
%     gaborDistanceFromFixationDegree = [10];
    
    LineDegree10dva_left = zeros(8,1);
    LineDegree10dva_right = zeros(8,1);
    lineAngleColumn = 7;
    
    
    for i = 1 : length(RespMat)
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
        

        trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree));
        LineAngle = [LineDegree10dva_right LineDegree10dva_left];
        LineAngle_ave = LineAngle/(trialNumPerCondition/2);
        for ward = 1:2
            for delay = 1:8
                % internal drift rightward
                if ward == 1
                    Physi_prop_temp(delay,ward) = 1/2 + (LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                elseif ward == 2
                    Physi_prop_temp(delay,ward) = 1/2 - (LineAngle_ave(delay,ward)/ang2radi(meanSubIlluDegree(ward)));
                end
            end
        end
  
    
    %     LineDegree10dva_right = [0.3229    0.3142   -0.2967   -0.8028   -0.6283   -0.8989   -1.8588   -2.2078]/18;
    %     LineDegree10dva_left = [1.6319    1.0210   -0.2705   -0.0960   -1.0210   -1.1781   -2.0682   -2.0420]/18;
    
    % rightward    leftward
    lineLengthDegree = 3.5;
    lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth);
    
    colorMap_R = mycolorMap(10,1);
    colorMap_L = mycolorMap(10,4);
    LineDegree10dva_right_ave = LineDegree10dva_right/trialNumPerCondition;
    LineDegree10dva_left_ave = LineDegree10dva_left/LineDegree10dva_left;
    % plot the adjustable line position of where the apparent motion from
    for number = 1:length(LineDegree10dva_right_ave)
        if LineDegree10dva_right_ave(number) > 0
            RealxDis_R(number) = lineLengthPixel * tan(LineDegree10dva_right_ave(number));
            graph(number) = plot((dotXpos_R_st + RealxDis_R(number)),dotYpos_R_end,'color',colorMap_R(number,:),'marker','o','MarkerFaceColor',colorMap_R(number,:));
            hold on;
        elseif  LineDegree10dva_right_ave(number) < 0
            RealxDis_R(number) = lineLengthPixel * tan(abs(LineDegree10dva_right_ave(number)));
            graph(number) = plot((dotXpos_R_st - RealxDis_R(number)),dotYpos_R_end,'color',colorMap_R(number,:),'marker','o','MarkerFaceColor',colorMap_R(number,:));
            hold on;
        end
        
    end
    
    for number = 1:length(LineDegree10dva_left_ave)
        if LineDegree10dva_left_ave(number) > 0
            RealxDis_L(number) = lineLengthPixel * tan(LineDegree10dva_left_ave(number));
            graph(number) = plot((dotXpos_L_st + RealxDis_L(number)),dotYpos_L_end,'color',colorMap_L(number,:),'marker','o','MarkerFaceColor',colorMap_L(number,:));
            hold on;
        elseif  LineDegree10dva_left_ave(number) < 0
            RealxDis_L(number) = lineLengthPixel * tan(abs(LineDegree10dva_left_ave(number)));
            graph(number) = plot((dotXpos_L_st - RealxDis_L(number)),dotYpos_L_end,'color',colorMap_L(number,:),'marker','o','MarkerFaceColor',colorMap_L(number,:));
            hold on;
        end
        
    end
    
    
    h = [percLoca_L;percLoca_R;gaborTraj_L;gaborTraj_R];
    for pic = 1:length(graph)
        h = [h;graph(pic)];
    end
    %     legend(h,'centriod perceived location_','centriod perceived location_R','gabor physical path_L','gabor physical path_R','0 ms','50 ms','100 ms','150 ms','200 ms','250 ms','300 ms','350 ms','FontSize',10)
    % legend({'0 ms';'50 ms';'100 ms';'150 ms';'200 ms';'250 ms';'300 ms';'350 ms'});
    
    xlim([690 770]);
    ylim([300 460]);
end

% title('percentage of apparent motion from the end of physical path(3.5dva)','FontSize',40);
% xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
% ylabel({'percentage from perceived'},'FontSize',20);
% % legend('S1','S2','S3','S4','S5','S6','S7','Location','northeast')
% legend('S1','S2','S3','S4','Location','northeast');
% [lgd, icons, plots, txt] = legend('show');
%
% ax = gca;
% ax.FontSize = 20;

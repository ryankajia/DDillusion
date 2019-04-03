%% my first gabor drift
% illusion in the 2 different location and 2 directions
% with test gabor change to green flash

%% clear the workspace
close all;
clearvars;
sca;

tic;

subject_name = input('>>>> Participant name (e.g.: AB):  ','s');
%  debug 1  no    debug  2  yes
debug = input('>>>> debug? (e.g.: no debug press n; yes debug press y):  ','s');
% moveMark = input('>>>> test dot strict to move horizontal or freely? (e.g.: h or f):  ','s');
moveMark = 'f';
%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------

Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
% cd '../function';
% add shared scripts to path
addpath('../../function');

%     Screen('Preference','VisualDebugLevel',1); % warning triangle

% set up screens
screens = Screen('Screens');
screenNumber = max(screens);
% Define black, white and grey
blackcolor = BlackIndex(screenNumber);
whitecolor = WhiteIndex(screenNumber);
grey = whitecolor / 2;
% set the window size
winSize = [0 0 1024 768];   %[0 0 1024 768];





%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

[window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
[xCenter, yCenter] = RectCenter(winRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
% Set the text size
Screen('TextSize', window, 40);
framerate = FrameRate(window);
Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
viewingDistance = 60; % subject distance to the screen

%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------
gabor = gaborParaSet(window,screenXpixels,displaywidth,viewingDistance,framerate);

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
% Make KbName use shared name mapping of keys between PC and Mac
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
spaceKey = KbName('space');

%----------------------------------------------------------------------
%%%                         experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
% fprintf('subject_name is',);

trialNumber = 48; % have to triple times of 8 which is the number of the interval time and 9 conditions
blockNumber = 6;
% Response start matrix setting
all = RespStartMatrix();

if debug == 'n'
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    % gaborMatSingle = {'upperLeft_rightward','lowerLeft_rightward'};
    % interval time between cue and gabor
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];   % intervalTime second
    gaborDistanceFromFixationDegree = [10];   % visual angle degree
elseif debug == 'y'
    gaborMatSingle = {'upperRight_leftward'};
    % gaborMatSingle = {'upperLeft_rightward','lowerLeft_rightward'};
    % interval time between cue and gabor
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];   % intervalTime second
    gaborDistanceFromFixationDegree = [10];   % visual angle degree
end


% gabor location from center in angle  but fixation move left 3 degree [4 5
% 6 7] means [7 8 9 10] dva
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;




% trial repeatTimes of each combined condition
repeatTimes = trialNumber/(length(gaborMatSingle)*length(intervalTimesMatSingle)...
    *length(gaborDistanceFromFixationDegree));
% randomized the different conditions 4 locations 8 directions
blockData = [];
k = 0;
factor1 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 1
factor2 = [1:length(gaborMatSingle)]; % blockData 2
factor3 = [1:length(intervalTimesMatSingle)]; % blockData 3
for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        for i3 = 1:length(factor3)
            k = k + 1;
            pickupData(k,:) = [factor1(i1),factor2(i2),factor3(i3)];
        end
    end
end

subData = repmat(pickupData,repeatTimes,1);

if debug == 'n'
    blockData = [subData(Shuffle(1:length(subData)),:)];
elseif debug == 'y'
    blockData = subData;
end

% 3 means 3 locations  1 is physical  2 mid 3 perceived location
%  dotLoca = [gaborLocationPhy; gaborEndLocaMid; gaborLocationPerc];
dotLocaMat = repmat([1; 2; 3],trialNumber/3,1);
dotLocaRand = dotLocaMat(Shuffle(1:length(dotLocaMat)));



%----------------------------------------------------------------------
%%%                         test gaobor parameter
%----------------------------------------------------------------------

time.secondFlashShow = 0.0167;  % before 0.2   0.0167 is for one frame
time.lineDelay = 0.9;
% Make a vector to record the response for each trial
cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);
% flash dot colot of gaussian dot
gauss.dotSizePix = 200;

% gauss.DimVisualAngle = 4;  % gabor visual angle
gauss.Dim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

gauss.testDotDelay = 0.8;
gauss.standDevia = 7 ;% small 7    big 4
gauss.dotFlag = 2;   %  grey flash
% gauss.dotAppeartime = 0.5;

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for block = 1:blockNumber
    
    
    
    %----------------------------------------------------------------------
    %%%                         stimulus Recording
    %----------------------------------------------------------------------
    % Record the stimulus by frame
    rec = 0;   % Rec = 1 begin recording
    mov.name = 'doubledrift';
    mov.framerate = 60;
    mov.dir = cd;
    mov = recdisplay(rec,mov,'create');
    
    
    for trial = 1: trialNumber
        
        gabor.InternalDriftPhaseIncrPerFrame = gabor.InternalDriftCyclesPerFrame/framerate;
        
        
        % If this is the first trial we present a start screen and wait for a key-press
        if trial == 1
            
            formatSpec = 'This is the %dth of %d block. Press Any Key To Begin';
            A1 = block;
            A2 = blockNumber;
            str = sprintf(formatSpec,A1,A2);
            DrawFormattedText(window, str, 'center', 'center', blackcolor);
            %             DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', blackcolor);
            %             fprintf(1,'\tBlock number: %2.0f\n',blockNumber);
            
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        
        condition = string(gaborMatSingle(blockData(trial,2)));
        
        
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
            orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition,blockData,trial);
        
        yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
        xframe =  yframe * tan(subIlluDegree*pi/360);
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(blockData(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path
            gaborStartLocMoveXDegree =  (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
            gaborStartLocMoveYDegree =  gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
            gaborStartLocMoveXPixel = deg2pix(gaborStartLocMoveXDegree,viewingDistance,screenXpixels,displaywidth);
            gaborStartLocMoveYPixel = deg2pix(gaborStartLocMoveYDegree,viewingDistance,screenXpixels,displaywidth);
            
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
%             cueLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel,  ...
%                 yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);
            
            if frame == 1
                if condition == 'upperRight_rightward'
                    gaborStartLocation_R = gaborLocation;
                elseif  condition == 'upperRight_leftward'
                    gaborStartLocation_L = gaborLocation;
                end
            end
                    
                    
                    % at the end of the gabor generate a green flash
                    % N > 0 : round to N digits to the right of the decimal point.
            % so -2 means generate flash for 1 frame
            
            
            Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            
            
            %             Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            % Draw fixation
            Screen('DrawDots', window,[xCenter,  yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
            
        end
        
        
        
        Screen('DrawDots', window,[xCenter,   yCenter], 10, whitecolor, [], 2);
        Screen('Flip',window);
        % wait 0.3 to present adjustable dot
        WaitSecs(gauss.testDotDelay);
        
        %----------------------------------------------------------------------
        %%%                         adjustable dot setting
        %----------------------------------------------------------------------
        
        % Now we wait for a keyboard button signaling the observers response.
        % The left arrow key signals a "left" response and the right arrow key
        % a "right" response. You can also press escape if you want to exit the
        % program
        if condition == 'upperRight_rightward' 
           gaborEndLocation_R = gaborLocation;
        elseif  condition == 'upperRight_leftward'
            gaborEndLocation_L = gaborLocation;       
        end
        
        t1 = GetSecs;
        respToBeMade = true;
        
        % set 3 conditions of perceived location test dot        
        gaborLocationPhy = gaborLocation;
        gaborLocationPerc = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                - xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));        
        gaborEndLocaMid = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
           , yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));

        dotLoca = [gaborLocationPhy; gaborEndLocaMid; gaborLocationPerc];
        

             
        [dotXpos,dotYpos] = findcenter(dotLoca(dotLocaRand(trial),:));
        
              
        moveStep = 1;        
        while respToBeMade
            
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, whitecolor, [], 2);
            
            [dstRects,flash] = gaussianDot(gauss.dotSizePix,gauss.Dim,dotXpos,dotYpos,grey,whitecolor-0.1,gauss.standDevia,gauss.dotFlag);
            Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            masktex = Screen('MakeTexture', window, flash);
            Screen('DrawTextures', window, masktex,[],dstRects);
            %             Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            %Screen('DrawDots', window,[dotXpos,   dotYpos], 25, grey+0.1, [],2);
            
            Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            Screen('Flip',window);
            
            if moveMark == 'h'
                % only move horizontally
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(leftKey)
                    response = 1;
                    dotXpos = dotXpos - moveStep;
                elseif keyCode(rightKey)
                    response = 0;
                    dotXpos = dotXpos + moveStep;
                elseif keyCode(spaceKey)
                    response = NaN;
                    %                 dotXpos = dotXpos;
                    respToBeMade = false;
                end
                
            elseif moveMark == 'f'
                % the gauss dot could move either horizontally or vertically
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(leftKey)
                    response = 1;
                    dotXpos = dotXpos - moveStep;
                    dotYpos = dotYpos;
                elseif keyCode(rightKey)
                    response = 2;
                    dotXpos = dotXpos + moveStep;
                    dotYpos = dotYpos;
                elseif keyCode(upKey)
                    response = 3;
                    dotXpos = dotXpos;
                    dotYpos = dotYpos - moveStep;
                elseif keyCode(downKey)
                    response = 4;
                    dotXpos = dotXpos;
                    dotYpos = dotYpos + moveStep;
                elseif keyCode(spaceKey)
                    response = NaN;
                    dotXpos = dotXpos;
                    dotYpos = dotYpos;
                    respToBeMade = false;
                end
            end
           
            
        end
        
        Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
%         WaitSecs(gauss.testDotDelay);
        t2 = GetSecs;
        %         Record the response
        responseTime = t2-t1;
        all.dotLocaRand = [all.dotLocaRand;dotLocaRand(trial)];
       
        all.dotXpos = [all.dotXpos;dotXpos];
        all.dotYpos = [all.dotYpos;dotYpos];
        all.responseTimeVector = [all.responseTimeVector;responseTime];
        all.responseVector = [all.responseVector;response];
        all.Trial =  [all.Trial; trial];
        all.Block =[all.Block; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        all.condition = [all.condition;condition];
        all.gaborDistanceFromFixationDegree = [all.gaborDistanceFromFixationDegree; gaborDistanceFromFixationDegreeNow];
        %         all.intervalTimesVector = [all.intervalTimesVector;intervalTimes];
        all.orientation = [all.orientation;orientation];
        WaitSecs(1);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        RespMat = [all.Block all.Trial  all.condition all.gaborDistanceFromFixationDegree all.responseVector all.dotXpos all.dotYpos all.responseTimeVector all.dotLocaRand];  %
        
        
    end
    %----------------------------------------------------------------------
    %                      save parameters files
    %----------------------------------------------------------------------
    %     time = clock;
    %     RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
    %     fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
    %     save(fileName,'RespMat','subIlluDegree','intervalTimesVector','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber','blockNumber');
    
end

toc;
% close(vidObj);


%----------------------------------------------------------------------
%                      save parameters files
%----------------------------------------------------------------------
time = clock;
% RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
fileName = ['../../data/GaborDrift/flash_lineAdjust/percLocaTest/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
% save(fileName,'RespMat','meanSubIlluDegree','time','all','gauss','cueVerDisDegree','gabor','viewingDistance','trialNumber','blockNumber');
save(fileName);

%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;

fprintf(1,'\n\nThis part of the experiment took %.0f min.',(toc)/60);
fprintf(1,'\n\nOK!\n');

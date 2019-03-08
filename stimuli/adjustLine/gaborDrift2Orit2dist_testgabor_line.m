%% my first gabor drift
% illusion in the 2 different location and 2 directions
% with test gabor change to green flash

%% clear the workspace
close all;
clearvars;
sca;

tic;

name = input('>>>> Participant name (e.g.: AB):  ','s');
subject_name = name;
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
% test = input('Name of the subject:    ');
viewingDistance = 60; % subject distance to the screen

%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------
gabor = gaborParaSet(window,screenXpixels,displaywidth,viewingDistance,framerate);
orientationAll = [];


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
spaceKey = KbName('space');

%----------------------------------------------------------------------
%%%                         experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
% fprintf('subject_name is',);

trialNumber = 64; % have to triple times of 8 which is the number of the interval time and 9 conditions
blockNumber = 6;
% Response start matrix setting
[responseVector,intervalTimesVector,TrialAll,BlockAll,conditionAll,responseTimeVector,lineAngleAll,gaborDistanceFromFixationDegreeAll] = RespStartMatrix();

% all the conditions 9
gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};

% interval time between cue and gabor
intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];   % intervalTime second


% gabor location from center in angle  but fixation move left 3 degree [4 5
% 6 7] means [7 8 9 10] dva
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;

gaborDistanceFromFixationDegree = [7 10];   % visual angle degree





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
blockData = [subData(Shuffle(1:length(subData)),:)];
% blockData = subData;


%----------------------------------------------------------------------
%%%                         test gaobor parameter
%----------------------------------------------------------------------

cueShowTime = 0.0167;  % 0.2
% Make a vector to record the response for each trial
cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);
% flash dot colot of gaussian dot
dotColor = [0 0.1 0];
dotSizePix = 200;
% gaussDim = 50;

gaussDimVisualAngle = 5;  % gabor visual angle
gaussDim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

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
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor] = conditionRandDis(condition,blockData,trial);

        yframe = [1:gabor.SpeedFrame:500];
        xframe =  yframe * tan(subIlluDegree*pi/360);
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(blockData(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path
            gaborStartLocMoveXDegree =  (gabor.pathLengthDegree/2)* tan(subIlluDegree/180*pi);
            gaborStartLocMoveYDegree =  gabor.pathLengthDegree/2;
            gaborStartLocMoveXPixel = deg2pix(gaborStartLocMoveXDegree,viewingDistance,screenXpixels,displaywidth);
            gaborStartLocMoveYPixel = deg2pix(gaborStartLocMoveYDegree,viewingDistance,screenXpixels,displaywidth);
            
            % xCenter has already set left to the original center.
            % gaborDistanceFromFixationPixel  7/10
            
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
            cueLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel,  ...
                yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);
            
            % at the end of the gabor generate a green flash
%             if frame > (round(gabor.stimulusTime * framerate) - 1)
%                 dotXpos_gabor = (gaborLocation(1)+gaborLocation(3))/2;
%                 dotYpos_gabor = (gaborLocation(2)+gaborLocation(4))/2;
%                 
%                 [dstRects,flash] = gaussianDot(dotSizePix,gaussDim,dotXpos_gabor,dotYpos_gabor,grey,whitecolor);
%                 % Draw the dot to the screen. For information on the command used in
%                 % this line type "Screen DrawDots?" at the command line (without the
%                 % brackets) and press enter. Here we used good antialiasing to get nice
%                 % smooth edges
%                 %Screen('DrawDots', window, [dotXpos_gabor dotYpos_gabor], gabor.DimPix, dotColor, [], 2);
%                 
%                 % Draw the gaussian apertures  into our full screen aperture mask
%                 Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%                 masktex = Screen('MakeTexture', window, flash);
%                 Screen('DrawTextures', window, masktex,[],dstRects);
%                 
%             else
                
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
                
                % Randomise the phase of the Gabors and make a properties matrix
                gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
%             end
            
%             Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            % Draw fixation
            Screen('DrawDots', window,[xCenter,  yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
            
            %Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            % Record the stimulus by frame
            mov = recdisplay(rec,mov,'record',window);
            
            
            %             gabor.SpeedFrame = gaborMoveSpeedPixel + gabor.SpeedFrame;
        end
        
        
        
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        
        
        intervalTimes = intervalTimesMatSingle(blockData(trial,3));
        WaitSecs(intervalTimes);
        
        % stimulus recording
        mov = recdisplay(rec,mov,'record',window,intervalTimes);
        t0 = GetSecs;
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        
        
        %         % Draw the cue gabor
        %         Screen('DrawTextures', window, gabor.tex, [], cueLocation, orientation, [], [], [], [],...
        %             kPsychDontDoRotation, gabor.propertiesMatFirst');
        %         [dstRects,masktex]= gaussianDot[gabor.DimPix, dotXpos,dotYpos];
        
        %----------------------------------------------------------------------
        %                       draw test gabor
        %----------------------------------------------------------------------
        
        
        
%         % draw the green gaussian flash at the cue location
        dotXpos_cue = (cueLocation(1) + cueLocation(3))/2;
        dotYpos_cue = (cueLocation(2) + cueLocation(4))/2;
% %         Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%         
%         [dstRects,flash] = gaussianDot(dotSizePix,gaussDim,dotXpos_cue,dotYpos_cue,grey,whitecolor);
%         masktex = Screen('MakeTexture', window, flash);
%         %                 Screen('DrawDots', window, [dotXpos_cue dotYpos_cue], dotSizePix, dotColor, [], 2);
%         
%         % Draw the gaussian apertures  into our full screen aperture mask
%         
%         Screen('DrawTextures', window, masktex,[],dstRects);
        
        Screen('DrawTextures', window, gabor.tex, [], cueLocation, orientation, [], [], [], [],...
            kPsychDontDoRotation, gabor.propertiesMatFirst');
        Screen('Flip',window);
        WaitSecs(cueShowTime);
        
        
%         Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
%         Screen('Flip',window);
        
        
%         WaitSecs(cueShowTime);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        WaitSecs(0.9);     
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
                
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'record',window,cueShowTime);
        %         Screen('Flip',window);
        % Draw fixation after stimuli in buffer             
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'record',window,1);
        
        %----------------------------------------------------------------------
        %%%                         adjustable line setting
        %----------------------------------------------------------------------       
        
        % Now we wait for a keyboard button signaling the observers response.
        % The left arrow key signals a "left" response and the right arrow key
        % a "right" response. You can also press escape if you want to exit the
        % program
        t1 = GetSecs;
        respToBeMade = true;
        AngleStep = pi/360; % (1/360)* 2*pi
        % lineAngle is the upper angle between first vertical and the
        % adjusted line "+"  means right "-"  means left
        lineAngle = 0; % (90/360)*2*pi
        lineLengthDegree = 3; 
        lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth) - 10;

%         if blockData(trial,:) == 1  
            
        while respToBeMade
            
            
%             Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
            Screen('DrawLine', window,blackcolor,dotXpos_cue, dotYpos_cue + 10, dotXpos_cue + tan(lineAngle)*lineLengthPixel, dotYpos_cue + lineLengthPixel,2);                       
            Screen('Flip',window);
                            
       
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(leftKey)
                response = 1;
                lineAngle = lineAngle - AngleStep;
            elseif keyCode(rightKey)
                response = 0;
                lineAngle = lineAngle + AngleStep;
            elseif keyCode(spaceKey)
                respToBeMade = false;
            end
        end
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        WaitSecs(0.3);
        t2 = GetSecs;
        %         Record the response
        responseTime = t2-t1;
        lineAngleAll = [lineAngleAll;lineAngle];
        responseTimeVector = [responseTimeVector;responseTime];
        responseVector = [responseVector;response];
        TrialAll =  [TrialAll; trial];
        BlockAll =[BlockAll; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        conditionAll = [conditionAll;condition];
        gaborDistanceFromFixationDegreeAll = [gaborDistanceFromFixationDegreeAll; gaborDistanceFromFixationDegreeNow];
        intervalTimesVector = [intervalTimesVector;intervalTimes];
        orientationAll = [orientationAll;orientation];
        WaitSecs(1);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        %         open(vidObj);
        %         currFrame = Screen('GetImage', window);
        %         writeVideo(vidObj,currFrame);
        %         imageArray = Screen('GetImage', window, [200 264 874 544]);
        %         imageArray = [imageArray; {Screen('GetImage', window, [200 264 874 544])}];
        
            end
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'finalize');
        RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector gaborDistanceFromFixationDegreeAll responseVector lineAngleAll responseTimeVector];  %
    end
    %----------------------------------------------------------------------
    %                      save parameters files
    %----------------------------------------------------------------------
    %     time = clock;
    %     RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
    %     fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
    %     save(fileName,'RespMat','subIlluDegree','intervalTimesVector','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber','blockNumber');

    
    toc;
    % close(vidObj);
    
    %----------------------------------------------------------------------
    %                      save parameters files
    %----------------------------------------------------------------------
    time = clock;
    % RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
    fileName = ['../../data/GaborDrift/gabor_lineAdjust/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
    save(fileName,'RespMat','subIlluDegree','intervalTimesVector','cueVerDisDegree','gabor','viewingDistance','trialNumber','blockNumber','lineAngleAll','responseTimeVector');
    

%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;

fprintf(1,'\n\nThis part of the experiment took %.0f min.',(toc)/60);
fprintf(1,'\n\nOK!\n');

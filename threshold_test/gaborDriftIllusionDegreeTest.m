%% my first gabor drift

% test degree illusion in  1 location across the visual field with only one
% fixed oritation 

%% clear the workspace
close all;
clearvars;
sca;
%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------
name = input('>>>> Participant name (e.g.: AB):  ','s');
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
addpath 'function';

%     Screen('Prefere nce','VisualDebugLevel',0); % warning triangle

% set up screens
screens = Screen('Screens');
screenNumber = max(screens);
blackColor = BlackIndex(screenNumber);
whiteColor = WhiteIndex(screenNumber);
grey = whiteColor/2;


% set the window size
winSize = [];   %[0 0 1024 768];


%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

[window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
[xCenter, yCenter] = RectCenter(winRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
Screen('TextSize', window, 40);
% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);
framerate = FrameRate(window);

%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------


% set individual parameter start: physical and perceived angle
subIlluDegreeStart = 45;

% gabor size from visual angle
gaborDimPix = 50;  % gabor size in pixels
viewingDistance = 60; % subject distance to the screen
% gaborVisualAngle = 2;  % gabor visual angle
% screen_diagonal = sqrt(winRect(3).^2 + winRect(4).^2);
% gaborDimPix= visual_angle2pixel(gaborVisualAngle, screen_diagonal, viewingDistance, screenNumber);
% gaborDimPix = deg2pix(gaborVisualAngle,viewingDistance,screenXpixels,displaywidth);



% % xfactor gaborMoveSpeedPixel  in x axis   of patch cue  it's in the middle of perceived gabor and physical gabor
% xcueFactor = xgaborFactor/2;

% gabor location from center in angle
gaborDistanceFromFixationDegree = 8;   % visual angle degree
gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegree,viewingDistance,screenXpixels,displaywidth);  %
% gaborDistanceFromFixation = visual_angle2pixel(gaborDistanceFromFixationDegree, screen_diagonal, viewingDistance, screenNumber);

% internal motion of gabor drift speed  frame  
InternalDriftCyclesPerSecond = 4; % 3 Hz  in lisi
InternalDriftCyclesPerFrame = InternalDriftCyclesPerSecond * 360;
InternalDriftPhaseIncrPerFrame = InternalDriftCyclesPerFrame/framerate; %degree per frame



% gaborExternalMotionDegreePerSec = 2;
% % gabor moving along a linear path of length:  in dva 
% gaborExternalMotionLengthDegree = 2; % dva   trajactory is 3 degree of visual angle
% stimulusTime = gaborExternalMotionLengthDegree/gaborExternalMotionDegreePerSec;
% trajactary  xframe/yframe = tan(IllusionDegree)


% subIlluDegreeIncre =  


% set texture parameters   Obvious parameters
orientation = - 45;  %  0   45
contrast = 0.8;
aspectRatio = 1.0;
phase = 0;

% Spatial Frequency(Cycles Per Pixel)  gabor internal motion
% One Cycle = Grey-black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 2;  % cycles of present gabor
freq = numCycles/gaborDimPix; % per pixel how many cycles

% Sigma of Gussian
sigma = gaborDimPix/7;

propertiesMatFirst = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];

% Build a procedural gabor texture
backgroundOffset = [0.5 0.5 0.5 0.0];
disableNorm = 1;
preContrastMultiplier = 0.5;

[gabortex, gaborrect] = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% % % gabor moving path length
% pathLengthDegree = 2; % dva
% pathLengthPixel = deg2pix(pathLengthDegree,viewingDistance,screenXpixels,displaywidth);
% stimulusTime = pathLengthPixel/framerate; %1;   % length is 1 * 60 frame  60 pixel
stimulusTime = 1;


% % gabor moving speed
% gaborSpeed = 2; % dva/sec
% gaborSpeedPixels = deg2pix(gaborSpeed,viewingDistance,screenXpixels,displaywidth);
% gaborSpeedFrame = gaborSpeedPixels/framerate;


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');


%----------------------------------------------------------------------
%%%                         Draw stuff
%----------------------------------------------------------------------

% Experiment setup
subject_name = name;
trialNumber = 40;


% Make a vector to record the response for each trial
responseVector = zeros(1, trialNumber);
% Make a vector to record the interval time for each trial
intervalTimesVector = zeros(1, trialNumber);
subIlluDegree = zeros(1, trialNumber);
subIlluDegree(1) = subIlluDegreeStart;



%     % Recording by frame
%     vidObj = VideoWriter('garbordrift.avi');
%     vidObj.FrameRate = 60;



%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for trial = 1: trialNumber
          
    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;    
    end
    
%   yframe = [1:gaborSpeedFrame:300];
    yframe = [1:300];
    xframe = yframe * tan(subIlluDegree(trial)*pi/180);
    
    for frame = 1: (stimulusTime * framerate)
        
%         xgaborFactor(trial) = tan(subIlluDegree(trial) * pi/360);
        % define the tractory of gabor movement
        gaborLocation = CenterRectOnPointd(gaborrect, xCenter + gaborDistanceFromFixationPixel + ...
            xframe(frame), yCenter - yframe(frame));
        
       
        Screen('DrawTextures', window, gabortex, [], gaborLocation, orientation, [], [], [], [],...
            kPsychDontDoRotation, propertiesMatFirst');
        
        % Randomise the phase of the Gabors and make a properties matrix
        propertiesMatFirst(1) = propertiesMatFirst(1) + InternalDriftPhaseIncrPerFrame;
        
        
        % Draw fixation
        Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);

        
        % Flip to the screen
        Screen('Flip',window);
        %             % recording
        %             open(vidObj);
        %             currFrame = Screen('GetImage', window);
        %             writeVideo(vidObj,currFrame);
        
     
    end
    Screen('DrawDots', window,[xCenter yCenter], 10, [255 255 255 255], [], 2);
    Screen('Flip',window);
    
   
    
    %             open(vidObj);
    %             currFrame = Screen('GetImage', window);
    %             writeVideo(vidObj,currFrame);
    %             imageArray = [imageArray; {Screen('GetImage', window, [200 264 874 544])}];
    
    
    
    
    % Now we wait for a keyboard button signaling the observers response.
    % The left arrow key signals a "left" response and the right arrow key
    % a "right" response. You can also press escape if you want to exit the
    % program
    respToBeMade = true;
    while respToBeMade
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(leftKey)
            response = 1;
            subIlluDegreeIncre =  2;
            respToBeMade = false;
        elseif keyCode(rightKey)
            response = 0;
            subIlluDegreeIncre = - 2;
            respToBeMade = false;
        end
    end
    subIlluDegree(trial+1) = subIlluDegree(trial) + subIlluDegreeIncre;
    % Record the response
    responseVector(trial) = responseVector(trial) + response;
    TrialAll(trial) =  trial;
    
    WaitSecs(1); 
end

%     close(vidObj);
% cueDistance = sqrt((gaborMovePhaseIncrPerFrame * (ycueFactor - 1)).^2 + (gaborMovePhaseIncrPerFrame * xgaborFactor).^2);

time = clock;
RespMat = [TrialAll; subIlluDegree(1:trial); responseVector(1:trial)]';
fileName = ['data/DegreeTest/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'RespMat','orientation', 'InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber');

plot(subIlluDegree); 
mean(subIlluDegree(7:end));
plot(RespMat(:,2));
mean(RespMat(7:length(RespMat),2));


%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------
 
ShowCursor;
Screen('close all');
sca;
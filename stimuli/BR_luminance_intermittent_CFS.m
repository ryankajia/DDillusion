%% test subject psychophysical luminance at each location


clear all;
sca;
tic;
commandwindow;% mouse to commond window
% debugFlag = 1;
%% remenber the paramaters
% fid = fopen('binocular_rivalry_onset.m','r');
% mycode = fscanf(fid,'%300c');
% fclose('all');
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
%% parameters
subject_name = 'test';
% tilt_degrees = [5 10 20 30 45];
distance = 200;   % dia of the big constant circle background
backcolor = 0;
grating_dia = 80; % diameter of stimuli  grating
scale = 0.5 ;  % dia of stimula  for example  grating_dia*scale adjust dia of grating
thick = 3; % thick of the frame
preparing_time = 1;
disk_radius = 100; % grating radius
pixelsPerPeriod = 40;
contrast = 1;
angle_L = 0;
angle_R = angle_L + 90;
loc_test1 = 1; % location for test and exp
trial_test = 20;
loc_Start = 3;
same = 0;
% trial = locnum;
Perceive_previous = 0;
trial_number = 10;
QuitFlag = 0;
block_number = 5;
RedLumStart = 64; % ones(locunum,block_number)*64;
GreenLumStart = 64; % [];% ones(3,5)*64;
RedLumNow = [RedLumStart RedLumStart RedLumStart];
GreenLumNow = [GreenLumStart GreenLumStart GreenLumStart];
RedLum = [];
GreenLum = [];
RedLum = cell(trial_test,1);
GreenLum = cell(trial_test,1);

for i=1:trial_test
    RedLum{i}(1)=RedLumStart;
    GreenLum{i}(1)=GreenLumStart;
end

% RedLum = RedLumNow;
% GreenLum = GreenLumNow;

% LumStepStart = 10;
% LumStepNow = LumStepStart;
% LumStep = LumStepNow;
% GreenLum = 80;
% eye = 0;  % eye = 0 left eye red   eye = 1 left eye green
StiSec = 1; %how many second stimuli present
interSec = 3; % how many second stimuli and intermittent  total presentation time of stimuli
framecolor = [128 128 128];% frame color of the big circle
%% open screen (2 parts) and blend function

screens = Screen('Screens');
screennumber =  max(screens);
stereoMode = 4;
[wPtr,wrect] = Screen('OpenWindow',screennumber,backcolor,[0 0 1024 768],[],[],stereoMode);%1024 768
HideCursor;
Center = [wrect(3)/2,wrect(4)/2];

Screen('BlendFunction',wPtr,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% stimulus locations
ecc = 200;  % eccentricity    distance from  centre to stimuli centre of a circle
angles = (.5+(0:7))/8*360;
x = ecc*cosd(angles)'+Center(1);
y = ecc*sind(angles)'+Center(2);
stim_locations = [x y];

%% stimulation make texture

Grating_left_m = make_left_Gratings(disk_radius,pixelsPerPeriod,contrast,RedLumStart,angle_L);   %80    % How many pixels will each period/cycle occupy?
% GratingParvo = parvostimuli(stimula_mask);
Grating_right_m = make_right_Gratings(disk_radius,pixelsPerPeriod,contrast,RedLumStart,angle_R);  %40    % the right grating is 90 degree orthogonal to the left_gratings


gratingTex(1) = Screen('MakeTexture',wPtr,Grating_left_m);
gratingTex(2) = Screen('MakeTexture',wPtr,Grating_right_m);




%% background make texture

backTex = Screen('MakeTexture', wPtr, ones(wrect(1,4),wrect(1,3))*backcolor);%
%
for i =  1:wrect(1,3)/2:wrect(1,3)
    Screen('DrawLine',backTex,[0 0 0],i,0,i,wrect(1,4),thick);
end
for i = 1:wrect(1,4)/2:wrect(1,4)
    Screen('DrawLine',backTex,[0 0 0],0,i,wrect(1,3)*2,i,thick);
end
Screen('FillOval',backTex,backcolor,CenterRect([0 0 distance*2+grating_dia distance*2+grating_dia],Screen('Rect',backTex)));
Screen('FrameOval',backTex,framecolor,CenterRect([0 0 distance*2+grating_dia distance*2+grating_dia],Screen('Rect',backTex)),thick);
Screen('DrawLine',backTex,framecolor,wrect(3)/2-20,wrect(4)/2,wrect(3)/2+20,wrect(4)/2,thick);
Screen('DrawLine',backTex,framecolor,wrect(3)/2,wrect(4)/2-20,wrect(3)/2,wrect(4)/2+20,thick);


ovalrect_all = [];
% 8 stimulus circles
for Noval = 1:8
    ovalrectTem = CenterRectOnPoint([0 0 disk_radius*scale+10 disk_radius*scale+10],stim_locations(Noval,1),stim_locations(Noval,2));
    ovalrect_all = [ovalrect_all; ovalrectTem];
end
color_all = ones(8,3)*128;
Screen('FrameOval',backTex,color_all',ovalrect_all',thick);


%% draw background
word_rect = CenterRect([0,0,500,40],wrect);

Screen('SelectStereoDrawBuffer', wPtr, 0);
Screen('DrawTexture',wPtr,backTex);
Screen('TextSize',wPtr,50);
Screen('DrawText',wPtr,'Press any key to start',word_rect(1),word_rect(4)+350,[200,200,0],backcolor);

Screen('SelectStereoDrawBuffer', wPtr, 1);
Screen('DrawTexture',wPtr,backTex);
Screen('DrawText',wPtr,'Press any key to start',word_rect(1),word_rect(4)+350 ,[200,200,0],backcolor);

Screen('Flip',wPtr);

%% experimental conditions random

%% preparing

while ~KbCheck(-1)
end
FlushEvents;

WaitSecs(preparing_time);

%% stimula presenting

% trial_number = 20;
% exp_locations{1} = [3 2;3 2;3 2;3 4;3 4;3 4]; %[6 7; 6 8; 6 9; 6 10; 6 11; 6 12; 6 13; 6 14; 6 15; 6 16; 6 17; 6 18];
% exp_locations{2} =  fliplr(exp_locations{1}); % matrix reverse
load CFS/CFSMatMovie.mat
CFSFrequency= 8;
CFSMatMovie=Shuffle(CFSMatMovie);
CFSFrames = 100;
CFScont = 1;
% frameRate = 60;



% r2 = disk_radius;
% pict = 256*rand(disk_radius,disk_radius,3);
% mask2 = r2<disk_radius;
% pict(:,:,4) = mask2;
% pict(:,:,4) = uint8(pict(:,:,4)*255);
% load CFS images and Make Textures
CFSsize_scale = 0.25;
xsize = 256;
ysize = 256;
[x2,y2] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1); % make a axis
r2 = sqrt(x2.^2+y2.^2);
% pict = 256*rand(ysize,xsize,3);
mask2 = r2<xsize/2.*CFSsize_scale;

% pict(:,:,4) = mask2;
% pict(:,:,4) = uint8(pict(:,:,4)*255);
for i=1:CFSFrames
    CFSMatMovie{i} =CFScont*(CFSMatMovie{i}-128)+128;
    CFSImage=CFSMatMovie{i};  %.*mask+ContraN;
    CFSImage(:,:,4)=mask2*255;
    
    CFSImage = CFSImage((256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),(256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),:);
    CFSTex(i)=Screen('MakeTexture',wPtr,CFSImage);
end




trial_pre = 1;
Mark = 0;
prekeyIsDown=0;

while ~ Mark
    trial_pre = trial_pre + 1;
    response_pre(trial_pre) = 0;
    %                 WaitSecs(preparing_time);
    %                 FlushEvents;
    
    %         loc = [loc1 loc2 loc3];
    %         locationIndex = [1 2 3];% first trial is from loc2
    %
    %         %         loc_test = locationIndex(trial);
    %         stim_loc = stim_locations(locationIndex(trial),:);
    stim_loc = stim_locations(loc_Start,:);
    
    Grating_left_m = make_left_Gratings(disk_radius,pixelsPerPeriod,contrast,RedLumStart,angle_L);   %80    % How many pixels will each period/cycle occupy?
    % GratingParvo = parvostimuli(stimula_mask);
    Grating_right_m = make_right_Gratings(disk_radius,pixelsPerPeriod,contrast,GreenLumStart,angle_R);  %40    % the right grating is 90 degree orthogonal to the left_gratings
    
    
    gratingTex(1) = Screen('MakeTexture',wPtr,Grating_left_m);
    gratingTex(2) = Screen('MakeTexture',wPtr,Grating_right_m);
    
    trial_onset = GetSecs;
    
    
    while ~response_pre(trial_pre) % interSec total time of stimulus and intermittent
        % for frame = 1:(60*StiSec) % 0.5
        
        Screen('SelectStereoDrawBuffer', wPtr, eye);
        Screen('DrawTexture',wPtr,backTex);
        
        %             if frame <= (60*StiSec)
        %                 Screen('DrawTexture',wPtr,gratingTex(1),Screen('Rect',gratingTex(1)),CenterRectOnPoint(Screen('Rect',gratingTex(1))*scale,stim_loc(1),stim_loc(2)));
        %             end
        if GetSecs-trial_onset < StiSec
            Screen('DrawTexture',wPtr,gratingTex(1),Screen('Rect',gratingTex(1)),CenterRectOnPoint(Screen('Rect',gratingTex(1))*scale,stim_loc(1),stim_loc(2)));
            Screen('SelectStereoDrawBuffer', wPtr, 1-eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('DrawTexture',wPtr,gratingTex(2),Screen('Rect',gratingTex(2)),CenterRectOnPoint(Screen('Rect',gratingTex(2))*scale,stim_loc(1),stim_loc(2)));
            
        elseif GetSecs-trial_onset > StiSec && GetSecs - trial_onset < interSec
            
            
            x0 = stim_loc(1); % screen center
            y0 = stim_loc(2);
            %                 % [399.157857666016,747.433458412143]
            destrect = [x0-disk_radius.*scale/2, y0-disk_radius.*scale/2, x0+disk_radius.*scale/2, y0+disk_radius.*scale/2];

            
            w = randi(100,1);
            Screen('SelectStereoDrawBuffer', wPtr, eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('DrawTexture',wPtr,CFSTex(w),[],destrect);
            
            Screen('SelectStereoDrawBuffer', wPtr, 1-eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('DrawTexture',wPtr,CFSTex(w),[],destrect);
            
            if QuitFlag, break, end
        else
            %         if GetSecs - trial_onset >interSec && GetSecs-trial_onset < interSec + 0.5
            Screen('SelectStereoDrawBuffer', wPtr, eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('SelectStereoDrawBuffer', wPtr, 1-eye);
            Screen('DrawTexture',wPtr,backTex);
            %         end
        end
        
        
        Screen('Flip',wPtr);
        
        
        
        
        [ keyIsDown, timeSecs, keyCode ] = KbCheck(-1);
        if keyIsDown && ~prekeyIsDown  % prevent the same press was treated twice
            
            if keyCode(KbName('ESCAPE'))
                QuitFlag=1;               
            elseif keyCode(KbName('1'))||keyCode(KbName('1!'))
                response_pre(trial_pre) = 1;                
            elseif keyCode(KbName('2'))||keyCode(KbName('2@'))
                response_pre(trial_pre) = 2;                
            end
            
            Perceive_previous = response_pre(trial_pre-1);
            if Perceive_previous ~= response_pre(trial_pre)
                same = 0;
            else
                same = same + 1;
                if same == 5
                    Mark = 1;
                end
                
            end
            %             disp(num2str(same))
        end
        prekeyIsDown = keyIsDown;
        
        if QuitFlag, break, end
    end
    
    
    
    if QuitFlag, break, end
    WaitSecs(preparing_time);
    
end
WaitSecs(preparing_time);




for trial = 1:trial_number
    
    %       stim_loc = stim_locations(loc_Start,:);
    locationIndex = [2 3];% first trial is from loc2
    
    %         loc_test = locationIndex(trial);
    stim_loc = stim_locations(locationIndex(mod(trial,2)+1),:);
    
    
    
    Grating_left_m = make_left_Gratings(disk_radius,pixelsPerPeriod,contrast,RedLumStart,angle_L);   %80    % How many pixels will each period/cycle occupy?
    % GratingParvo = parvostimuli(stimula_mask);
    Grating_right_m = make_right_Gratings(disk_radius,pixelsPerPeriod,contrast,GreenLumStart,angle_R);  %40    % the right grating is 90 degree orthogonal to the left_gratings
    
    
    gratingTex(1) = Screen('MakeTexture',wPtr,Grating_left_m);
    gratingTex(2) = Screen('MakeTexture',wPtr,Grating_right_m);
    
    trial_onset = GetSecs;
    
    prekeyIsDown=0;
    response(trial) = 0;
    while ~response(trial) % interSec total time of stimulus and intermittent
        % for frame = 1:(60*StiSec) % 0.5
        
        Screen('SelectStereoDrawBuffer', wPtr, eye);
        Screen('DrawTexture',wPtr,backTex);
        
        %             if frame <= (60*StiSec)
        %                 Screen('DrawTexture',wPtr,gratingTex(1),Screen('Rect',gratingTex(1)),CenterRectOnPoint(Screen('Rect',gratingTex(1))*scale,stim_loc(1),stim_loc(2)));
        %             end
        if GetSecs-trial_onset < StiSec
            Screen('DrawTexture',wPtr,gratingTex(1),Screen('Rect',gratingTex(1)),CenterRectOnPoint(Screen('Rect',gratingTex(1))*scale,stim_loc(1),stim_loc(2)));
            Screen('SelectStereoDrawBuffer', wPtr, 1-eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('DrawTexture',wPtr,gratingTex(2),Screen('Rect',gratingTex(2)),CenterRectOnPoint(Screen('Rect',gratingTex(2))*scale,stim_loc(1),stim_loc(2)));
            
        elseif GetSecs-trial_onset > StiSec && GetSecs - trial_onset < interSec
            
            
            x0 = stim_loc(1); % screen center
            y0 = stim_loc(2);
            %                 % [399.157857666016,747.433458412143]
            destrect = [x0-disk_radius.*scale/2, y0-disk_radius.*scale/2, x0+disk_radius.*scale/2, y0+disk_radius.*scale/2];
            %                                 t=Screen('MakeTexture',wPtr,pict);

            
            w = randi(100,1);
            Screen('SelectStereoDrawBuffer', wPtr, eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('DrawTexture',wPtr,CFSTex(w),[],destrect);
            
            Screen('SelectStereoDrawBuffer', wPtr, 1-eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('DrawTexture',wPtr,CFSTex(w),[],destrect);
            
            if QuitFlag, break, end
        else
            %                     if GetSecs - trial_onset >interSec && GetSecs-trial_onset < interSec + 0.5
            Screen('SelectStereoDrawBuffer', wPtr, eye);
            Screen('DrawTexture',wPtr,backTex);
            Screen('SelectStereoDrawBuffer', wPtr, 1-eye);
            Screen('DrawTexture',wPtr,backTex);
            %                     end
        end
        
        
        Screen('Flip',wPtr);
        
        
        
        
        [ keyIsDown, timeSecs, keyCode ] = KbCheck(-1);
        if keyIsDown && ~prekeyIsDown  % prevent the same press was treated twice
            
            if keyCode(KbName('ESCAPE'))
                QuitFlag=1;
                
                
                
            elseif keyCode(KbName('1'))||keyCode(KbName('1!'))
                response(trial) = 1;
                %                     RedLumNow(trial)  = RedLum{trial}(end)  - LumStep; % 1=red reduce the red luminance
                %                     GreenLumNow(trial) = GreenLum{trial}(end)  + LumStep;
            elseif keyCode(KbName('2'))||keyCode(KbName('2@'))
                response(trial) = 2;
                %                     RedLumNow(trial) = RedLum{trial}(end)  + LumStep; % 1=red reduce the red luminance
                %                     GreenLumNow(trial) = GreenLum{trial}(end) - LumStep; % 1=green induce the green luminance
            end
            
            
            
            
            
            
            
        end
    end
    response_all{trial} = response;
    if QuitFlag, break, end
    WaitSecs(preparing_time);
end
sca;
toc;
time = clock;
fileName = ['data_intermittent presentation/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'subject_name','response_all');
%% remenber the paramaters
% fid = fopen('binocular_rivalry_onset.m','r');
% mycode = fscanf(fid,'%300c');
% fclose('all');

% if debugFlag
%     pretestDur = 10;
%     posttestDur = 10;
%     waittime = 1;
%     adaDur = 1;
% else
%     pretestDur = 120;
%     posttestDur = 180;
%     waittime = 60;
% end

clear all
%% sbj & contrast setup
sbj.name       = input('Subject Name? ','s');
Whole_Face     = input('Whole Face? 0:top 1:whole 2:only top');
Round          = input('which round?');
face_contrast0 = 0.5;
CFS_contrast   = 0.6;


Screen('Preference', 'SkipSyncTests', 1); 
whichscreen=max(Screen('Screens'));
stereomode=4; 
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white-black)/2);
kec=80; %% mac    

onsetT=0.2;  
frameRate=60;
prtime=0.2;
pausetime=0.5;

[windowPtr, rect]=Screen('OpenWindow',whichscreen,gray,[], [], [],stereomode);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% stimuli make
%Face
face_name={'2_1','2_2','2_3','2_4','2_5','2_6','2_7','3_1','3_2','3_3','3_4','3_5','3_6','3_7','4_1','4_2','4_3','4_4','4_5','4_6','4_7'};
face_bottom_name={'b2_1','b2_2','b2_3','b2_4','b2_5','b2_6','b2_7','b3_1','b3_2','b3_3','b3_4','b3_5','b3_6','b3_7','b4_1','b4_2','b4_3','b4_4','b4_5','b4_6','b4_7'};
face=[length(face_name),1];

for i=1:length(face_name)
        face_pic=imread(['hfp_face_rsw/',face_name{i},'.jpg']);  
        face_pic=double(face_pic);        
        face(i)=Screen('MakeTexture',windowPtr,face_pic);  
        face_bottom_pic=imread(['hfp_face_rsw/',face_bottom_name{i},'.jpg']);  
        face_bottom_pic=double(face_bottom_pic);  
        face_bottom(i)=Screen('MakeTexture',windowPtr,face_bottom_pic);    

end

position_case=2;%beside the fixation
switch Whole_Face
    case 0
        top_case=3; 
    case 1
        top_case=1;%kinds of case
    case 2
        top_case=1;
end

load 'face index.mat'
trils=(length(face_name)+4*3*3)*position_case*top_case;

% face_index(:,1)=mod((1:trils),length(face_name))+1;
face_index(:,1)=repmat(A',position_case*top_case,1);%face name
face_index(1:trils/position_case,2)=1;%position
switch Whole_Face
    case 0
        ntrils=trils/top_case/position_case;
        face_index(ntrils+1:2*ntrils,3)=1;
        face_index(2*ntrils+1:3*ntrils,3)=2;
        face_index(3*ntrils+1:4*ntrils,3)=1;
        face_index(4*ntrils+1:5*ntrils,3)=2;
    case 1
        face_index(:,3)=0;%kinds of case
    case 2
        face_index(:,3)=0;
end

face_index(:,4)=mod(randperm(trils),2); %eyes
face_index(:,5)=mod(randperm(trils),2)*2-1; %misalign position
face_index=face_index(randperm(size(face_index,1)), :);

rect_index=mod(randperm(2000),4)+1;
% eye_index=mod(randperm(2000),2);

%CFS

load CFSMatMovie3.mat
CFSMatMovie=Shuffle(CFSMatMovie);
CFSFrames=100;
CFSTex={CFSFrames,1};
for i=1:CFSFrames
    CFSMatMovie{i} =CFS_contrast*(CFSMatMovie{i}-128)+128;
    CFSImage=CFSMatMovie{i};
    CFSTex{i}=Screen('MakeTexture',windowPtr,CFSImage);
end
CFSFrequency=6;

%bg

bgimg=Screen('MakeTexture',windowPtr,imread('background.jpg'));
whloe_face_rect=Screen('MakeTexture',windowPtr,imread('rect.png'));

%rect

rectheight=calculateEccenticH(4.5,700);
rectwidth=calculateEccenticW(3.7,700);
offset =10; 
offsetrange=5;
bottom_offset=rectwidth/3;
Rect1=[0 0 rectwidth rectheight];
Rect20=CenterRect(Rect1,rect);
Rect200{1}=OffsetRect(Rect20,offset,-offset-rectheight/4);
Rect200{2}=OffsetRect(Rect20,-offset,-offset-rectheight/4);
Rect200{3}=OffsetRect(Rect20,offset,-offset/2-rectheight/4);
Rect200{4}=OffsetRect(Rect20,-offset,-offset/2-rectheight/4);
bgRect=Rect20+[-rectwidth-20 -rectheight rectwidth+20 rectheight];

%% show

Screen('FillRect',windowPtr,gray);
Screen('DrawText',windowPtr,'Click SPACE key when ready',50,80);
Screen('SelectStereoDrawBuffer', windowPtr, 1);
Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);

Screen('SelectStereoDrawBuffer', windowPtr, 0);
Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);

Screen('Flip', windowPtr);

[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
while ~(keyCode(44)) %%%spacekey
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
end
WaitSecs(1);

    
% fixation
Screen('SelectStereoDrawBuffer', windowPtr, 1);
Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);

Screen('SelectStereoDrawBuffer', windowPtr, 0);
Screen('DrawTexture', windowPtr, bgimg, [],bgRect );
Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);

Screen('Flip', windowPtr);

WaitSecs(1);

press=0; CycleCounter=1;

while CycleCounter<length(face_index)+1
    
    %%    random rect

    position=rectwidth/2;     
    offset_2=randi(offsetrange)-(offsetrange+1)/2;
    Rect2=Rect200{rect_index(CycleCounter)}+[offset_2 offset_2 offset_2 offset_2];
    if face_index(CycleCounter,2)
        Rect2=OffsetRect(Rect2,position,0);
    else
        Rect2=OffsetRect(Rect2,-position,0);
    end
    Rect3=Rect2+[0 Rect2(2)/2 0 0];
    Rect_bottom=Rect2+[0 rectheight/2 0 0];
%     Rect_bottom=OffsetRect(Rect_bottom,randsrc(1,1,[bottom_offset -bottom_offset]),0);
    Rect_bottom=OffsetRect(Rect_bottom,bottom_offset*face_index(CycleCounter,5),0);
    Rect_CFS=bgRect+[30 Rect2(2)-bgRect(2)+rectheight/2 -30 -30];
    
    
    %%   show Face 
     w=1;
    for i=1:(prtime*frameRate)  
        
        
        if mod(i,CFSFrequency)==0
            w=w+1;           
            w=mod(w,CFSFrames)+1;    
        end
        
       contrast =face_contrast0;
        if i < onsetT*frameRate
            face_contrast =(1-cos(pi/onsetT/frameRate*i))/2*contrast;
        else
            face_contrast = face_contrast0;
        end
        
        
        if i < onsetT*frameRate
            rect_contrast = 0.5+(1-cos(pi/onsetT/frameRate*i))/2;
        else
            rect_contrast = 1;
        end
        
     
        
        switch Whole_Face
            
            case 0 %half
                
                
                switch face_index(CycleCounter,3)
                    
                    case 0 %top
                        
                        Screen('SelectStereoDrawBuffer', windowPtr, 0);                                  
                        Screen('DrawTexture', windowPtr, bgimg, [],bgRect);  
                        Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);  
                        Screen('DrawTexture', windowPtr,whloe_face_rect, [],OffsetRect(Rect2,0,rectheight/2),[],[],1);
                        Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);                 
                        Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
                 
                 
                        Screen('SelectStereoDrawBuffer', windowPtr, 1);                
                        Screen('DrawTexture', windowPtr, bgimg, [],bgRect);  
                        Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);   
                        Screen('DrawTexture', windowPtr,whloe_face_rect, [],OffsetRect(Rect2,0,rectheight/2),[],[],1);
                        Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);               
                        Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
                    
                    case 1%CFS
                         
                        righteye=face_index(CycleCounter,4);
                        if righteye==1
                            lefteye=0;                     
                        else
                            lefteye=1;
                        end
                        
                        Screen('SelectStereoDrawBuffer', windowPtr, righteye);
                        Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
                        Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);
                        Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
        
        
                        Screen('SelectStereoDrawBuffer', windowPtr, lefteye);
                        Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
                        Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);
                        Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
                    
                    case 2%miss a line
                        if mod(i,CFSFrequency)==0          
                            w=w+1;           
                            w=mod(w,CFSFrames)+1;      
                        end
                        
                        righteye=face_index(CycleCounter,4);
                        if righteye==1
                            lefteye=0;                     
                        else
                            lefteye=1;
                        end
                        
                        Screen('SelectStereoDrawBuffer', windowPtr, righteye);
                        Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
                        Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);
                        Screen('DrawTexture', windowPtr,whloe_face_rect, [],OffsetRect(Rect2,0,rectheight/2),[],[],1);
                        Screen('DrawTexture',windowPtr,face_bottom(face_index(CycleCounter)),[],Rect_bottom,[],[],face_contrast);
                        Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
        
        
                        Screen('SelectStereoDrawBuffer', windowPtr, lefteye);
                        Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
                        Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);
                        Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
                        
                end
            case 1 %whole
                                 
                Screen('SelectStereoDrawBuffer', windowPtr, 0);                                  
                Screen('DrawTexture', windowPtr, bgimg, [],bgRect); 
                Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);
                Screen('DrawTexture', windowPtr,whloe_face_rect, [],Rect2,[],[],rect_contrast);
                Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);                                                
                Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
                 
                 
                Screen('SelectStereoDrawBuffer', windowPtr, 1);                                  
                Screen('DrawTexture', windowPtr, bgimg, [],bgRect); 
                Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);
                Screen('DrawTexture', windowPtr,whloe_face_rect, [],Rect2,[],[],rect_contrast);
                Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);                                                
                Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
            
            case 2 %only top
                        
                Screen('SelectStereoDrawBuffer', windowPtr, 0);                                  
                Screen('DrawTexture', windowPtr, bgimg, [],bgRect);  
                Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);  
                Screen('DrawTexture', windowPtr,whloe_face_rect, [],OffsetRect(Rect2,0,rectheight/2),[],[],1);
                Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);                 
                Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
                 
                 
                Screen('SelectStereoDrawBuffer', windowPtr, 1);                
                Screen('DrawTexture', windowPtr, bgimg, [],bgRect);  
                Screen('DrawTexture',windowPtr,face(face_index(CycleCounter)),[],Rect2,[],[],face_contrast);   
                Screen('DrawTexture', windowPtr,whloe_face_rect, [],OffsetRect(Rect2,0,rectheight/2),[],[],1);
                Screen('DrawTexture',windowPtr,CFSTex{w},[],Rect_CFS,[],[],CFS_contrast);               
                Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
        end
        
         Screen('Flip', windowPtr);
        
        ResponseMatBlock(CycleCounter,1:3) = face_index(CycleCounter,1:3);
        
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        if (keyIsDown == 1)
            PressedKey = find(keyCode>0);
            CurrentKeyCode = PressedKey;
            ResponseMatBlock(CycleCounter,4) = kec-CurrentKeyCode;%%%left=0;Right=1;
            press=1;
            
            if keyCode(41) %%%% ESC
                outputFileName1 = sprintf('Data/Face_%d_%s_%s_%s_%s_%d%d',Whole_Face,Round,sbj.name , date);
                save( sprintf('%s.mat',outputFileName1) , 'ResponseMatBlock');
                disp('UserBreak');
                Screen('CloseAll'); 
                break;
            end
            break;
        end
      
    end
 %% response   
 
 
  Screen('SelectStereoDrawBuffer', windowPtr, 0);
  Screen('DrawTexture', windowPtr, bgimg, [],bgRect);
  Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
     
  Screen('SelectStereoDrawBuffer', windowPtr, 1);
  Screen('DrawTexture', windowPtr, bgimg, [],bgRect );
  Screen('DrawDots', windowPtr, [(Rect20(1)+Rect20(3))*0.5 (Rect20(2)+Rect20(4))*0.5],4, black, [], 2);
     
  Screen('Flip', windowPtr);
    

    if ~press
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        while ~keyIsDown
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        end
        if (keyIsDown == 1)
            PressedKey = find(keyCode>0);
            CurrentKeyCode = PressedKey;
            ResponseMatBlock(CycleCounter,4) = kec-CurrentKeyCode;%%%left=0;Right=1;
            press=1;
            
            if keyCode(41) %%%% ESC
                outputFileName1 = sprintf('Data/Face_%d_%s_%s_%s_%s_%d%d',Whole_Face,Round,sbj.name , date);
                save( sprintf('%s.mat',outputFileName1) , 'ResponseMatBlock');
                disp('UserBreak');
                Screen('CloseAll'); 
                break;
            end
        end
    end

%% pause 'pausetime'
    
    ttt=GetSecs;
    while GetSecs<ttt+pausetime
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        if (keyIsDown == 1)&&keyCode(41) %%%% ESC
                outputFileName1 = sprintf('Data/Face_%d_%s_%s_%s_%s_%d%d',Whole_Face,Round,sbj.name , date);
                save( sprintf('%s.mat',outputFileName1) , 'ResponseMatBlock');
                disp('UserBreak');
                Screen('CloseAll'); 
                break;
        end
    end

%% add skiped trial & reset
    
    if ~(ResponseMatBlock(CycleCounter,4)==0 || ResponseMatBlock(CycleCounter,4)==1)
        face_index=[face_index;face_index(CycleCounter,:)];
    end
        
    
    press=0;
    keyIsDown = 0;
    CycleCounter=CycleCounter+1;
    
end

%% analyze
if Whole_Face
    Rate=zeros(8,length(face_name));
    for cycle=1:length(ResponseMatBlock)
        for faceNo=1:length(face_name)
            if ResponseMatBlock(cycle,1)==faceNo
                Rate(1,faceNo)=Rate(1,faceNo)+1;%total
                if ResponseMatBlock(cycle,4)==1 
                    Rate(3,faceNo)=Rate(3,faceNo)+1;%right
                    if ResponseMatBlock(cycle,2)&&ResponseMatBlock(cycle,4)==1 
                        Rate(4,faceNo)=Rate(4,faceNo)+1;%position(right) right
                    end
                elseif ResponseMatBlock(cycle,4)==0
%                     Rate(9,faceNo)=Rate(9,faceNo)+1;%left
                else
                    Rate(2,faceNo)=Rate(2,faceNo)+1;
                    
                end
            end
        end
    end
Rate(2,:)=Rate(1,:)-Rate(2,:);%affective total trail
Rate(5,:)=Rate(3,:)-Rate(4,:);%position2 right
Rate(6,:)=Rate(3,:)./Rate(2,:);
Rate(7,:)=Rate(4,:)./(Rate(2,:)/2);
Rate(8,:)=Rate(5,:)./(Rate(2,:)/2);

else
    
    Rate=zeros(14,length(face_name));
    for cycle=1:length(ResponseMatBlock)
        for faceNo=1:length(face_name)
            if ResponseMatBlock(cycle,1)==faceNo
                Rate(1,faceNo)=Rate(1,faceNo)+1;%total
                if ResponseMatBlock(cycle,4)==0||ResponseMatBlock(cycle,4)==1
                    Rate(2,faceNo)=Rate(2,faceNo)+1;
                end
                if ResponseMatBlock(cycle,3)==0&&ResponseMatBlock(cycle,4)==1%top 
                    Rate(3,faceNo)=Rate(3,faceNo)+1;
                    if ResponseMatBlock(cycle,2)
                        Rate(4,faceNo)=Rate(4,faceNo)+1;
                    end
                elseif ResponseMatBlock(cycle,3)==1&&ResponseMatBlock(cycle,4)==1 %CFS
                    Rate(6,faceNo)=Rate(6,faceNo)+1;
                    if ResponseMatBlock(cycle,2)
                        Rate(7,faceNo)=Rate(7,faceNo)+1;
                    end
                end
            end
        end
    end
 %Rate(2,:)=trils/length(face_name);%affective total trail
 Rate(5,:)=Rate(3,:)-Rate(4,:);%Top position2
 Rate(8,:)=Rate(6,:)-Rate(7,:);%CFS position2
 Rate(9,:)=Rate(3,:)./(Rate(2,:)/top_case);
 Rate(10,:)=Rate(4,:)./(Rate(2,:)/position_case/top_case);
 Rate(11,:)=Rate(5,:)./(Rate(2,:)/position_case/top_case);
 
 Rate(12,:)=Rate(6,:)./(Rate(2,:)/top_case);
 Rate(13,:)=Rate(7,:)./(Rate(2,:)/position_case/top_case);
 Rate(14,:)=Rate(8,:)./(Rate(2,:)/position_case/top_case);
 
    
end

outputFileName1 = sprintf('Data/Face_%d_%s_%s_%s_%s_%d%d',Whole_Face,Round,sbj.name , date);
save( sprintf('%s.mat',outputFileName1) , 'ResponseMatBlock','Rate');

%% end

Screen('DrawText', windowPtr, sprintf('Exp is over. thank you.'),  rect(3)*0.25, 100, [130 130 130]);
Screen('DrawText',windowPtr,'Exp is over. thank you.',50,80);
Screen('Flip', windowPtr);

[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
while ~(keyCode(44)) %%%spacekey
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
end

Screen('CloseAll'); fclose all; disp('Well')

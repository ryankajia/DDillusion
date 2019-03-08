function invisibleface
global  time frameRate CFSFrequency CFSFrames  CFSTex windowPtr bgimg bgrect  screenRect black ppd face rl lr AF DeleteFlag QuitFlag Deletesignal releaseFlag pp stimulir

time=2;
offsetT = 0;
onsetT =0;
pp=0;

eye1=0; eye2=1;
w=1;
KbName('UnifyKeyNames'); 
KeyE = KbName('ESCAPE');
KeyDel= KbName('UpArrow');


for i=1:(time*frameRate)
    if mod(i,CFSFrequency)==0
        w=w+1;
        w=mod(w,CFSFrames)+1;
    end
    Screen('SelectStereoDrawBuffer', windowPtr, rl);%eye1=0 to show on the left side screen
    Screen('DrawTexture', windowPtr, bgimg,[],bgrect);
    Screen('SelectStereoDrawBuffer', windowPtr, rl);
    Screen('DrawTexture',windowPtr, CFSTex{w},[],CenterRectOnPoint([0 0 stimulir stimulir],screenRect(3)/2+pp*ppd,screenRect(4)/2+pp*ppd));
    Screen('DrawDots', windowPtr, [screenRect(3)/2 screenRect(4)/2],[8], [black], [], [2]);
    
    Screen('SelectStereoDrawBuffer', windowPtr, lr);
    Screen('DrawTexture', windowPtr, bgimg,[],bgrect);
    %% set alpha--transcrepancy
    if i < onsetT*frameRate
        alpha = (1-cos(pi/onsetT/frameRate*i))/2;
    elseif time*frameRate - i < offsetT*frameRate
        alpha = 1-(1+cos(pi/offsetT/frameRate*(time*frameRate - i)))/2;
    else alpha = 1;
    end
    Screen('SelectStereoDrawBuffer', windowPtr,lr);
    Screen('DrawTexture',windowPtr, face{AF}, [],CenterRectOnPoint([0 0 stimulir stimulir],screenRect(3)/2+pp*ppd,screenRect(4)/2+pp*ppd),[],[],[alpha]);
    Screen('Flip',windowPtr);
    
    [ keyIsDown, ~, keyCode ] = KbCheck(-1);
    if keyIsDown && keyCode(KeyE)
        QuitFlag=1;
    end
    if QuitFlag==1   break, end
    
    
    %% delete the visible trial 
 
    [keyIsDown,timeSecs,keyCode] = KbCheck;
    
    if keyIsDown

        if keyCode(KeyDel)&&releaseFlag == 1
            DeleteFlag=1;
            Deletesignal=1;
        end
        releaseFlag = 0;
    else
        releaseFlag = 1;
    end
    if DeleteFlag==1 break,end
  
end
  
end
%% Reset

sca;
close all;
clear;
rng('shuffle');

%% Psychtoolbox-Initialize

% Psychtoolbox-Setup
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
% Prioritize extended screen
screens = Screen('Screens');
screenNumber = max(screens);
% Get colors
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey=(black+white)/2;
% Open Window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
% Get FlipInv
flipInv = Screen('GetFlipInterval', window);

% Get params about the screen
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

% Claim priority
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
vbl=Screen('Flip',window); 

HColumn=[360:-1:0];
HColumnTex=zeros(360,30,3);
for i = 1:360
    [r,g,b]=hsl2rgb(361-i,1,0.5);
    HColumnTex(i,:,1)=r;
    HColumnTex(i,:,2)=g;
    HColumnTex(i,:,3)=b;
end

HColumnTex=Screen('MakeTexture',window,HColumnTex);

Hvalue=180;
Svalue=1;
Lvalue=0.5;


Screen('DrawTexture', window,HColumnTex,[],CenterRectOnPointd([0 0 30 360],xCenter+215 ,yCenter));
Screen('FillRect',window,black,CenterRectOnPointd([0 0 30 2],xCenter+215,yCenter-Hvalue+180))
SL_Area=zeros(400,400,3);
for x =1:400
    for y = 1:400
        [r,g,b]=hsl2rgb(Hvalue,x/400,y/400);
        SL_Area(x,y,1)=r;
        SL_Area(x,y,2)=g;
        SL_Area(x,y,3)=b;
    end
end
TTex=Screen('MakeTexture',window,SL_Area);
Screen('DrawTexture', window,TTex,[],CenterRectOnPointd([0 0 400 400],xCenter-30 ,yCenter));
Screen('FrameOval',window,black,CenterRectOnPointd([0 0 10 10],Lvalue*400+xCenter-230,Svalue*400+yCenter-200));

% preview block
[rp,gp,bp]=hsl2rgb(Hvalue,Svalue,Lvalue);
Screen('FillRect',window,[rp,gp,bp],CenterRectOnPointd([0 0 20 20],xCenter+185,yCenter));
%         Screen('DrawText',window,[char(string(Hvalue)),' ',char(string(Svalue)),' ',char(string(Lvalue))],xCenter+250,yCenter,black);
Screen('Flip',window)

        
%% Collect Mouse Reaction
while 1 
    [x,y,buttons]=GetMouse;
    if buttons(1)>0
        TTexSig=0;
        % left click, do something
        if (x>=xCenter+200) && (x<=xCenter+230) && (y>=yCenter-180) && (y<=yCenter+180)
            Hvalue=180-y+yCenter;
            TTexSig=1;
        end
        
        if (x>=xCenter-230) && (x<=xCenter+170) && (y>=yCenter-200) && (y<=yCenter+200)
            Lvalue=(x-xCenter+230)/400;
            Svalue=(y-yCenter+200)/400;
        end
        
        
        Screen('DrawTexture', window,HColumnTex,[],CenterRectOnPointd([0 0 30 360],xCenter+215 ,yCenter));
        Screen('FillRect',window,black,CenterRectOnPointd([0 0 30 2],xCenter+215,yCenter-Hvalue+180))
        if TTexSig==1
            SL_Area=zeros(400,400,3);
            for x =1:400
                for y = 1:400
                    [r,g,b]=hsl2rgb(Hvalue,x/400,y/400);
                    SL_Area(x,y,1)=r;
                    SL_Area(x,y,2)=g;
                    SL_Area(x,y,3)=b;
                end
            end
            TTex=Screen('MakeTexture',window,SL_Area);
        end
        Screen('DrawTexture', window,TTex,[],CenterRectOnPointd([0 0 400 400],xCenter-30 ,yCenter));
        
        
        % preview block
        [rp,gp,bp]=hsl2rgb(Hvalue,Svalue,Lvalue);
        Screen('FillRect',window,[rp,gp,bp],CenterRectOnPointd([0 0 20 20],xCenter+185,yCenter));
%         Screen('DrawText',window,[char(string(Hvalue)),' ',char(string(Svalue)),' ',char(string(Lvalue))],xCenter+250,yCenter,black);
        
        % selector circle
        Screen('FrameOval',window,1-[rp,gp,bp],CenterRectOnPointd([0 0 10 10],Lvalue*400+xCenter-230,Svalue*400+yCenter-200));
        
        Screen('Flip',window)
        
    elseif buttons(3)>0
        break
    end
end



%% End

Priority(0);
vbl=Screen('Flip',window,vbl + 0.5* flipInv); 
WaitSecs(1);
Screen('Close',window);



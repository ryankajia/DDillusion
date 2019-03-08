function Offset = calculateEccenticH(E,d)
% Offset = calculateEccenticH(E)

% d(mm)被试到屏幕距离 45.5
% E(du)视角角度制 3.72 13/200(d/x)
%%%%如果计算大小，那么E是所需要角度的一半，然后值要乘以二；计算离心的话，不用改变
% d=660;
x=tan(E*pi/180)*d;
% rect=Screen('Rect', max(Screen('Screens')));
rect=[0 0 1024 768];%MEG
% [width, height]=Screen('DisplaySize', max(Screen('Screens')));
height=305;%行为学试验 屏幕高度
Offset=x*rect(4)/height;
end
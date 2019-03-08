function Offset = calculateEccenticW(E,d)

% d(mm) 28
% E(du) 2.29  8/200(d/x)
%%%%如果计算大小，那么E是所需要角度的一半，然后值要乘以二；计算离心的话，不用改变
% d=80;
x=tan(E*pi/180)*d;
% rect=Screen('Rect', max(Screen('Screens')));
rect=[0 0 1024 768];%MEG
% [width, height]=Screen('DisplaySize', max(Screen('Screens')));
width=405;%行为学试验
Offset=x*rect(3)/width;
end







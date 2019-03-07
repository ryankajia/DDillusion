双漂移实验说明

    所有实验中被试的眼睛必须始终盯住白色注视点，不能直接看刺激。无论是测试中，还是判断时。实验首先要检测每个被试的错觉阈值，再将每个被试的错觉角度带入到最终实验中。
 1  threshold test 文件夹    100个trial  大约5分钟  （line 33 winSize = [0 0 1024 768]; 将“0 0 1024 768”删除，刺激即可全屏显示）
被试任务：  判断illusion path的方向，跟垂直线比是向左还是向右，按键“左”“右”
实验结束后直接出结果 如下
meanSubIlluDegree = [38.7692   45.6923   44.6154   51.0769]
每次实验前都要重新测试阈值，96个trial，取平均值即可。

2   把meanSubIlluDegree的4个数字 拷贝到 function/conditionRandDis 第17行中
3   run  stimuli/ gaborDrift2Orit2dist_testgabor_line 输入被试名字
这次还是flash apparent motion judgement 实验
也就是说在错觉gabor消失的最后一点的flash，  到呈现的test flash的位置和方向，调整line的方向
任务：调整line的方向，使得line的两端分别指向前后两个gabor，按键“左”“右”确定后按空格键进入下一个trial.如果觉得是垂直，则直接按空格。

结果保存在data中，直接把data文件夹拷贝给我就可以啦。结束啦~~~

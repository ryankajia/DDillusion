% grnerate my own colormap for plot

function colorMap = mycolorMap(number,rgbmark)
colorMaptemp = [];
colorMap= [];
for gradua = 0:(1/number):1
    if rgbmark == 1
        colorMaptemp = [gradua 0 0];
    elseif rgbmark == 2
        colorMaptemp = [gradua gradua 0];
    elseif rgbmark == 3
        colorMaptemp = [gradua gradua gradua];
    elseif rgbmark == 4
        colorMaptemp = [0 gradua gradua];
    elseif rgbmark == 5
        colorMaptemp = [0 0 gradua];
    end
    colorMap = cat(1,colorMap,colorMaptemp);
end


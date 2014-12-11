function [ ] = drill(x, y)
%DRILL splits two adjacent objects that are close together
%   Starts at z = -158 and decrements while spinning;

    puma_moveto_xyzoat(x, y, -158, 0, 90, 0);
    puma_speed(200);
    
    for i = -158 : -2 : -170
    
        t = mod(i, 4) * -90;
        puma_moveto_xyzoat(x, y, i, 0, 90, t);
        
    end
    
    puma_speed(20);
end


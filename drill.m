function [ ] = drill(x, y)
%DRILL splits two adjacent objects that are close together
%   Starts at z = -158 and decrements while spinning;


robot_radius = sqrt(180^2 + 360^2);
d_tool = 125;
d_gripper_center = 110;
robot_z = -160;

%centroid = [-340, 320];
o = 0;
a = 90;

theta = atan2d(y,x);
radius = sqrt(x^2 + y^2);


% find cotangent line and intersect
if radius > robot_radius
    robot_x = cosd(theta) * robot_radius;
    robot_y = sind(theta) * robot_radius;
    d_obj = radius - robot_radius;
    
    o = abs(atand((x - robot_x) / (y - robot_y)));
    a = asind((d_obj) / (d_gripper_center)) + 90;
    robot_z = robot_z - (d_tool - sqrt(d_tool^2 - d_obj^2));
    
% else use coordinates of centroid
else
    robot_x = x;
    robot_y = y;
end


    puma_moveto_xyzoat(robot_x, robot_y, robot_z, o, a, 0);
    puma_speed(200);
    
    for i = robot_z : -1 : robot_z - 6
    
        t = mod(i, 4) * 90;
        puma_moveto_xyzoat(robot_x, robot_y, i, o, a, t);
        
    end
    
    puma_speed(20);
end


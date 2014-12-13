function [ XYZ_OAT ] = pickup_object( centroid, orientation )
%GET_XYZOAT Summary of this function goes here
%   Detailed explanation goes here

robot_radius = sqrt(180^2 + 360^2);
d_tool = 125;
d_gripper_center = 110;
robot_z = -188;

%centroid = [-340, 320];
x = centroid(1);
y = centroid(2);
o = 0;
a = 90;
t = orientation;

x_pad = x;
y_pad = y;
z_pad = robot_z;

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
    
    % choose tool angle based on quadrant
    % quad I
    if y < 222
        t = t + 68;
        x_pad = robot_x + 20;
        y_pad = robot_y;
        if x < -395
            z_pad = robot_z + 40;
        else
            z_pad = robot_z + 60;
        end
    %quad II
    elseif x < -340
        t = t + 68;
        x_pad = robot_x + 20;
        y_pad = robot_y - 20;
        if y > 279
            z_pad = robot_z + 40;
        else
            z_pad = robot_z + 60;
        end
    %quad III and IV
    elseif x < -280
        t = t + 48;
        x_pad = robot_x;
        y_pad = robot_y - 20;
        if y > 279
            z_pad = robot_z + 40;
        else
            z_pad = robot_z + 60;
        end
    else
        t = t + 30;
        x_pad = robot_x;
        y_pad = robot_y - 20;
        if y > 279
            z_pad = robot_z + 40;
        else
            z_pad = robot_z + 60;
        end
    end
    
% else use coordinates of centroid
else
    robot_x = x;
    robot_y = y;
end

XYZ_OAT = [robot_x, robot_y, robot_z, o, a, t];

% move robot to position to pick up object
    % set XYZOAT
    puma_speed(20);
    puma_moveto_xyzoat(robot_x, robot_y, -100, o, a, t);
    gripper('o');
    puma_moveto_xyzoat(x_pad, y_pad, z_pad, o, a, t);
    
    % lower gripper
    puma_speed(20);
    puma_moveto_xyzoat(robot_x, robot_y, robot_z, o, a, t); 
    puma_speed(100);
    
    % close gripper
    gripper('c');

    %raise gripper
    puma_safe();
    
end


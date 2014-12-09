function [ XYZ_OAT ] = pickup_object( centroid, orientation )
%GET_XYZOAT Summary of this function goes here
%   Detailed explanation goes here

robot_radius = sqrt(183^2 + 362^2);
d_tool = 125;
d_gripper_center = 110;
robot_z = -190;

%centroid = [-340, 320];
x = centroid(1);
y = centroid(2);
o = 0;
a = 90;
t = orientation;

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

XYZ_OAT = [robot_x, robot_y, robot_z, o, a, t];

% move robot to position to pick up object
    % set XYZOAT
    puma_speed(20);
    puma_moveto_xyzoat(robot_x, robot_y, -100, o, a, t);
    
    % lower gripper
    puma_read();
    puma_speed(20);
    puma_moveto_xyzoat(robot_x, robot_y, robot_z, o, a, t); 
    puma_read();
    puma_speed(100);
    
    % close gripper
    gripper('c');

    %raise gripper
    puma_moveto_xyzoat(robot_x, robot_y, 0, 0, 90, t);
    
end


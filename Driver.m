close all;

addpath('./dependencies/');
addpath('./Throw/Debug/');

% which puma is being used
puma_number = '1';

% define file names
l_img_file_name = 'left.ppm';
r_img_file_name = 'right.ppm';

% import p matrices
l_p_file = 'dependencies/left_p_matrix.mat';
r_p_file = 'dependencies/right_p_matrix.mat';
l_p = importdata(l_p_file);
r_p = importdata(r_p_file);

% ready puma for movement
puma_speed(20);
puma_ready();
puma_speed(50);
numobj = 1;


while numobj > 0
   
    % ready position
    puma_ready();
    
    % open gripper
    take_pictures(puma_number);
    gripper('o');

    % calculate centroids and orientations for left and right images
    l_stats = find_cent_orient(l_img_file_name);
    r_stats = find_cent_orient(r_img_file_name);
    
    % break if l_stat or r_stat is an empty struct
    if ~isfield(l_stats, 'orientations') || ~isfield(r_stats, 'orientations')
       break;        
    end
    
    % get points in uv
    numobj = size(l_stats.('centroids'), 1);
    points = zeros([3, numobj]);
    
    % get points in xyz
    points(:, 1) = uv2xyz(l_stats.('centroids')(1,:).', l_p, r_stats.('centroids')(1,:).', r_p);
    
    % interpolate between orientations from left and right
    orient = (l_stats.('orientations')(1) + r_stats.('orientations')(1)) / 2;
    
    % add offset between robot frame and camera frame
    xyz = points(:, 1).' + [-410, 140, -190];
    
    
    pickup_object(xyz, orient);
    
    
end

puma_ready();
gripper('o');
puma_speed(20);
puma_nest();
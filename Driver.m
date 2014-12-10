close all;

addpath('./dependencies/');
addpath('./Throw/Debug/');

% Define distance for objects that can use easy pickup
easy_distance = 100;

% Define which puma we are using
puma_number = '1';

% Import p matrices
l_p = importdata('dependencies/left_p_matrix.mat');
r_p = importdata('dependencies/right_p_matrix.mat');

% Place puma in ready position
puma_speed(20);
puma_ready();
puma_speed(100);

while numobj > 0
   
    puma_defense();
    
    % Process the images
    take_pictures(puma_number);
    [l_pic, l_n] = improcessing('left.ppm', 1, 1);
    [r_pic, r_n] = improcessing('right.ppm', 1, 2);
    
    % Verify that the same number of objects exist in each file
    if l_n ~= r_n
        dsp('Images contain different number of objects');
        continue;
    end

    % Pick the first easily accessible object
    obj_found = 0;
    for i = l_n:-1:1
        
        % Remove all but one object
        l_temp_pic = (l_pic == i);
        r_temp_pic = (r_pic == i);
        
        % Find the centroid in each picture
        l_cent = regionprops(l_temp_pic, 'Centroid');
        r_cent = regionprops(r_temp_pic, 'Centroid');
        points(:,1) = uv2xyz(l_cent.Centroid(1,:).', l_p, r_cent.Centroid(1,:).', r_p);
        
        % add offset between robot frame and camera frame
        xyz = points(:, 1).' + [-410, 140, -190];
        
        % Continue if object found is not easily accessible
        if sqrt(xyz(1)^2 + xyz(2)^2) < easy_distance
            
            % An easy object has been found, find it's orientation
            obj_found = 1;
            l_orient = orientation(l_temp_pic);
            r_orient = orientation(r_temp_pic);
            orient = l_orient + r_orient / 2;
            break;
            
        end
        
    end
    
    % Pick up an object or process the image for objects touching
    if obj_found == 1
        pickup_object(xyz, orient);
        throw_object();
    else
        % find_duplicate_objs();
        % Get the centroid of the double object
        % drill(); the objects to a new position
    end
    
    
end

% Place puma in nest position
puma_speed(20);
puma_ready();
puma_nest();
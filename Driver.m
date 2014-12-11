close all;

addpath('./dependencies/');
addpath('./Throw/Debug/');

% Definitons
easy_distance = 100;
areas = [ 500, 5000, 10000 ];
tolerance = 10;

% Define which puma we are using
puma_number = '1';

% Import p matrices
l_p = importdata('dependencies/left_p_matrix.mat');
r_p = importdata('dependencies/right_p_matrix.mat');

% Place puma in ready position
puma_speed(20);
puma_ready();
puma_speed(100);
puma_defense();

for j = 1:10 % THIS WILL HAVE TO BE CHANGED IN FINAL PROJECT

    % Process the images
    take_pictures(puma_number);

    % Process image with different intensities
    for i = .9:-.1:.1

        [l_pic, l_n] = improcessing('left.ppm',i, areas,1,1);
        [r_pic, r_n] = improcessing('right.ppm',i,areas,1,2);

        % Is object detected at this intensity
        if l_n == r_n && l_n ~= 0

            % Find the first easily accessible object
            for n = l_n:-1:1

                % Remove all but one object
                l_temp_pic = (l_pic == n);
                r_temp_pic = (r_pic == n);

                % Find the centroid in each picture
                t_cent = regionprops(l_temp_pic, 'Centroid');
                l_cent = t_cent.Centroid(1,:).';
                t_cent = regionprops(r_temp_pic, 'Centroid');
                r_cent = t_cent.Centroid(1,:).';
                xyz = uv2xyz(l_cent, l_p, r_cent, r_p).';
                
                % Check that we are looking at the same object
                if abs(xyz(3)) > tolerance
                    %%%%% This should remove the chance that we are looking
                    %%%%% at a different object in each camera
                   continue; 
                end
                
                % Set offset for robot coordinate frame
                xyz(1) = xyz(1) - 410;
                xyz(2) = xyz(2) + 140;
                xyz(3) = -190;

                % Do nothing if object found is not easily accessible
                if sqrt(xyz(1)^2 + xyz(2)^2) < easy_distance

                    % An easy object has been found, find it's orientation
                    l_orient = orientation(l_temp_pic);
                    r_orient = orientation(r_temp_pic);
                    orient = l_orient + r_orient / 2;

                    % Pick-up and throw the object
                    %pickup_object(xyz, orient);
                    %throw_object();
                    %puma_defense();
                    
                end
            end
        end
        
        % When i == .1, check for adjacent objects
        % process image with different area
        % drill()
        % puma_defense()
        
    end
end

% Place puma in nest position
puma_speed(20);
puma_ready();
puma_nest();

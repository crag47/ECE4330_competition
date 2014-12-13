close all;

addpath('./dependencies/');
addpath('./Throw/Debug/');

% Definitons
easy_distance = sqrt(183^2 + 362^2);
areas = [ 500, 5000, 10000 ];
tolerance = 40;

% Define which puma we are using
puma_number = '2';

% Import p matrices
l_p = importdata('dependencies/left_p_matrix.mat');
r_p = importdata('dependencies/right_p_matrix.mat');

% Place puma in ready position
puma_speed(20);
puma_ready();
puma_speed(100);
puma_defense();

for j = 1:99999999 % THIS WILL HAVE TO BE CHANGED IN FINAL PROJECT

    % Process the images
    take_pictures(puma_number);

    % Process image with different intensities
    i = 10;
    while i > 2
        i = i - 1;
        [l_pic, r_pic, l_n, r_n] = process_images('left.ppm', 'right.ppm', i, areas, 1, 1, 2);

        if l_n == r_n && l_n ~= 0
            % Find the first easily accessible object
            for n = l_n:-1:1

                % Remove all but one object
                l_temp_pic = (l_pic == n);
                r_temp_pic = (r_pic == n);

                % Find the centroid in each picture
                l_props = regionprops(l_temp_pic,'Centroid','Perimeter','Orientation');           
                r_props = regionprops(r_temp_pic,'Centroid','Perimeter','Orientation');
                l_cent = l_props.Centroid(1,:).';
                r_cent = r_props.Centroid(1,:).';
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
                xyz(3) = -185;

                % Do nothing if object found is not easily accessible
                % if sqrt(xyz(1)^2 + xyz(2)^2) < easy_distance

                    % Choose the image with least area
                    % smaller area
                    if l_props.Perimeter < r_props.Perimeter
                        orient = orientation(l_temp_pic);
                    else
                        orient = orientation(r_temp_pic);
                    end

                    % Pick-up and throw the object
                    puma_safe();
                    puma_speed(100);
                    
                    pickup_object([xyz(1), xyz(2)], orient);
                    throw_object();
                    i = 0;
                    break;
                    
                % end
            end
        end
    end
        
        % When i == 2, check for adjacent objects
        if i == 2
            new_areas = areas * 2;
            new_areas(3) = new_areas(3) * 1.5;
            [l_pic, l_n] = improcessing('left.ppm',.9, new_areas,1,1);
            [r_pic, r_n] = improcessing('right.ppm',.9,new_areas,1,2);
            
          %   if l_n == r_n && l_n ~= 0
            if l_n ~= 0 && r_n ~= 0
            
                % Find the centroid in each picture
                l_temp_pic = (l_pic == l_n);
                r_temp_pic = (r_pic == r_n);
                l_props = regionprops(l_temp_pic,'Centroid');      
                r_props = regionprops(r_temp_pic,'Centroid');
                l_cent = l_props.Centroid(1,:).';
                r_cent = r_props.Centroid(1,:).';
                if(abs(l_cent) < abs(r_cent))
                   l_cent = r_cent;
                else
                    r_cent = l_cent;
                end
                xyz = uv2xyz(l_cent, l_p, r_cent, r_p).';

                % Set offset for robot coordinate frame
                puma_safe();
                drill(xyz(1)-410,xyz(2)+140);
                puma_defense();
            end
            
       end
        
end

% Place puma in nest position
puma_speed(20);
puma_ready();
puma_nest();

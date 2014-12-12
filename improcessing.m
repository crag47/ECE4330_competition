function [image, n] = improcessing(image, intensity, areas, display, f_num)
% Less selective image processing to determine if objects are on edge of
% box

    % Read in the image
    image = imread(image);
    if display == 1
        figure(f_num); subplot(3,2,1); subimage(image);
    end
    
    % Convert the image to black and white
    image = im2bw(image, intensity);
    if display == 1
        subplot(3,2,2); subimage(image);
    end
    
    % Remove small inconsistencies
    image = bwareaopen(image, areas(1), 4);
    if display == 1
        subplot(3,2,3); subimage(image);
    end
    
    % Remove areas too small to be objects
    image = bwareaopen(imcomplement(image), areas(2), 4);
    if display == 1
        subplot(3,2,4); subimage(image);
    end
    
    % Remove areas too big to be objects
    image = image - bwareaopen(image, areas(3), 4);
    if display == 1
        subplot(3,2,5); subimage(image);
    end

    [image, n] = bwlabel(image, 4);

end


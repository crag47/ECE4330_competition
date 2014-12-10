function [image, n] = improcessing( image, display, figure_num )
% Returns the image with objects already categorized into n objects

    if display == 0
        % This should run faster since memory allocation is unnecessary
        image = imread(image); % Read in image
        image = im2bw(image,.9); % Convert to black and white
        image = bwareaopen(image, 10000, 8); % Remove small inconsistencies
        % Remove objects too small
        image = bwareaopen(imcomplement(image), 5000, 8);
        % Remove objects too big
        image = image - bwareaopen(image, 10000, 8); 
        % Remove all but the closest object
        [image, n] = bwlabel( image, 8); % Same procedure, but saves each individual image to display
        
    else
        figure(figure_num);
        i1 = imread(image); subplot(3,2,1); subimage(i1);
        i2 = im2bw(i1,.9); subplot(3,2,2); subimage(i2);
        i3 = bwareaopen(i2, 10000, 8);subplot(3,2,3); subimage(i3);
        i4 = bwareaopen(imcomplement(i3), 5000, 8);subplot(3,2,4); subimage(i4);
        i5 = i4 - bwareaopen(i4, 10000, 8);subplot(3,2,5); subimage(i5);
        [i6, n] = bwlabel( i5, 8);
        image = i6;
    end
   
end

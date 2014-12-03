function image = improcessing( image, display )

if display
    % Setup images
    i1 = imread(image);
    figure(1);
    imshow(i1);

    % Turn the image to black and white
    i2 = im2bw(i1,.9);
    figure(2);
    imshow(i2);

    % Remove small inconsistencies
    i3 = bwareaopen(i2, 10000, 8);
    figure(3);
    imshow(i3);

    % Remove all objects smaller than a cylinder
    i3 = imcomplement(i3);
    i4 = bwareaopen(i3, 5000, 8);
    figure(4);
    imshow(i4);

    % Remove all objects that are too large to be a cylinder
    i5 = i4 - bwareaopen(i4, 10000, 8);
    figure(5);
    imshow(i5);

    % Get the cylinder that is closest to the robot
    [i6, n] = bwlabel( i5, 8);
    i6 = (i6 == n);
    figure(6);
    imshow(i6);
    image = i6;
else
    % Setup images
    image = imread(image);

    % Turn the image to black and white
    image = im2bw(image,.9);
    
    % Remove small inconsistencies
    image = bwareaopen(image, 10000, 8);
    
    % Remove all objects smaller than a cylinder
    image = bwareaopen(imcomplement(image), 5000, 8);
    
    % Remove all objects that are too large to be a cylinder
    image = image - bwareaopen(image, 10000, 8);
    
    % Get the cylinder that is closest to the robot
    [image, n] = bwlabel( image, 8);
    image = (image == n);
end
    

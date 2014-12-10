function [ orient ] = orientation( image )
%orientation Returns the orientation of the object
%   Uses canny edge detection and hough transform to determine the
%   orientation of the object

    image = edge(image, 'canny');
    
    % Perform hough transform of object outline
    [H,T,~] = hough(image);
    
    % Find hough peaks
    P = houghpeaks(H,2,'threshold',ceil(.2*max(H(:))));
    
    % Find orientation using average orientation
    orient = (T(P(1,2)) + T(P(2,2))) / 2;

end


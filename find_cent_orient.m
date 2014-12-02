function [ s ] = find_cent_orient( image )
% return structure with centroids and orientations of first object in image

% convert image to black and white
I  = imread(image);
Igray = im2bw(I, .9); 

% Find edges in intensity image
BW = edge(Igray, 'canny');

% separate object outlines into data structure
[BW2, n] = bwlabel(BW, 8);

if n ~= 0 

    s = (BW2 == 1);

    % perform hough transform of object outline
    [H,T,R] = hough(s);

    % find hough peaks
    P  = houghpeaks(H,2,'threshold',ceil(.2*max(H(:))));
    
    % find hough lines
    lines = houghlines(s,T,R,P,'FillGap',15,'MinLength',10);   
    
    % find and return interpolations of centroid and orientation
    orientation = (T(P(1,2)) + T(P(2,2))) / 2;
    centroid = interp_cent(lines(1), lines(2));
    s = struct('centroids', centroid, 'orientations', orientation);
    return;
    
end

% return empty struct if no object was present
s = struct;

end

function [ centroid ] = interp_cent( line1, line2 )
x1 = (line1.point1(1) + line2.point1(1)) / 2;
y1 = (line1.point1(2) + line2.point1(2)) / 2;

x2 = (line1.point2(1) + line2.point2(1)) / 2;
y2 = (line1.point2(2) + line2.point2(2)) / 2;

centroid_x = (x1 + x2) / 2;
centroid_y = (y1 + y2) / 2;

centroid = [centroid_x, centroid_y];

end


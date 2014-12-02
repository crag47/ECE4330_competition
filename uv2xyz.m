function xyz = uv2xyz( left_uv, left_p, right_uv, right_p )
% uv2xyz - Calculates the xyz coordinates
%   left_uv = [u;v] coordinate of the left image
%   left_p  = left camera intrinsic/extrinsic matrix
%   right_uv = [u;v] coordinate of the right image
%   right_p = right camera intrinsic/extrinsic matrix
%   returns xyz = [x;y;z] as the 3D coordinate

B = zeros(4,1);
for i = 1:2
    B(i) = right_uv(i,1) * right_p(3,4) - right_p(i,4);
    B(i+2) = left_uv(i,1) * left_p(3,4) - left_p(i,4);
end

A = zeros(4,3);
for i = 1:2
    A(i,1:3) = right_p(i,1:3) - right_uv(1,1) * right_p(3,1:3);
    A(i+2,1:3) = left_p(i,1:3) - left_uv(1,1) * left_p(3,1:3);
end

xyz = inv(transpose(A) * A) * transpose(A) * B;
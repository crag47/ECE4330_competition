function puma_moveto_xyzoat(varargin)
%moveto_xyzoat Wrapper function for the system call
%   Need to handle when operator is not given

program = 'Puma_MOVETO_XYZOAT';
if nargin == 6 
    % Case where all arguments are provided individually
    a = zeros(1,6);
    for i = 1:6
        a(i) = varargin{i};
    end
    args = sprintf(' %f, %f, %f, %f, %f, %f',a(1),a(2),a(3),a(4),a(5),a(6));
else
    return;
end

system(strcat(program,args));

puma_read();

end


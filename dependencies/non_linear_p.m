function [ p ] = non_linear_p(data)
    
    zero_vector = [0;0;0];
    
    % Create the p matrix
    ref_w = [data.Rc_1, data.Tc_1; 0, 0, 0, 1];
    p = horzcat(data.KK, zero_vector)*ref_w;
    
end


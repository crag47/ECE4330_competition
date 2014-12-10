function [] = puma_safe()
%safe Moves puma to safety position for subsequent moves

    puma_moveto_joints(-30, -150, 45, 180, 75, -50);
    puma_read();

end

